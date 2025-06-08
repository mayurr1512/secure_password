import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:password_manager/data/model/credential.dart';
import 'package:password_manager/data/repository/credential_repository.dart';

abstract class CredentialEvent {}

class LoadCredentials extends CredentialEvent {}

class AddCredential extends CredentialEvent {
  final Credential credential;
  AddCredential(this.credential);
}

class UpdateCredential extends CredentialEvent {
  final Credential credential;
  UpdateCredential(this.credential);
}

class DeleteCredential extends CredentialEvent {
  final Credential credential;
  DeleteCredential(this.credential);
}

abstract class CredentialState {}

class CredentialLoading extends CredentialState {}

class CredentialLoaded extends CredentialState {
  final List<Credential> credentials;
  CredentialLoaded(this.credentials);
}

class CredentialBloc extends Bloc<CredentialEvent, CredentialState> {
  final CredentialRepository _repository;
  List<Credential> _credentials = [];

  CredentialBloc(this._repository) : super(CredentialLoading()) {
    on<LoadCredentials>((event, emit) async {
      _credentials = await _repository.getAllCredentials();
      emit(CredentialLoaded(List.from(_credentials)));
    });

    on<AddCredential>((event, emit) async {
      final newCredential = await _repository.insertCredential(event.credential);
      _credentials.add(newCredential);
      emit(CredentialLoaded(List.from(_credentials)));
    });

    on<UpdateCredential>((event, emit) async {
      await _repository.updateCredential(event.credential);
      final index = _credentials.indexWhere((c) => c.id == event.credential.id);
      if (index != -1) {
        _credentials[index] = event.credential;
        emit(CredentialLoaded(List.from(_credentials)));
      }
    });

    on<DeleteCredential>((event, emit) async {
      await _repository.deleteCredential(event.credential.id);
      _credentials.removeWhere((c) => c.id == event.credential.id);
      emit(CredentialLoaded(List.from(_credentials)));
    });
  }
}

