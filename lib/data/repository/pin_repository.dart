import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class PinRepository {
  final _storage = const FlutterSecureStorage();
  static const _pinKey = 'user_pin';

  Future<void> savePin(String pin) async {
    await _storage.write(key: _pinKey, value: pin);
  }

  Future<String?> getPin() async {
    return await _storage.read(key: _pinKey);
  }

  Future<bool> hasPin() async {
    return (await getPin()) != null;
  }

  Future<bool> validatePin(String pin) async {
    final saved = await getPin();
    return saved == pin;
  }
}