import 'package:flutter_bloc/flutter_bloc.dart';

abstract class AuthEvent {}
class CheckAuthStatus extends AuthEvent {}

abstract class AuthState {}
class AuthInitial extends AuthState {}
class AuthUnlocked extends AuthState {}

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc() : super(AuthInitial()) {
    on<CheckAuthStatus>((event, emit) {
      emit(AuthUnlocked());
    });
  }
}
