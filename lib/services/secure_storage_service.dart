import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorageService {
  static const _storage = FlutterSecureStorage(
    aOptions: AndroidOptions(encryptedSharedPreferences: true),
    iOptions: IOSOptions(accessibility: KeychainAccessibility.first_unlock),
  );
  static const _tokenKey = 'auth_token';
  static const _pinKey = 'user_pin';

  Future<void> saveToken(String token) async {
    await _storage.write(key: _tokenKey, value: token);
    // Jangan pernah mencetak nilai token ke log.
    debugSafeLog('Token berhasil disimpan');
  }

  Future<String?> getToken() async => _storage.read(key: _tokenKey);
  Future<void> deleteToken() async {
    await _storage.delete(key: _tokenKey);
    debugSafeLog('Token berhasil dihapus');
  }

  Future<void> savePin(String pin) async =>
      _storage.write(key: _pinKey, value: pin);
  Future<String?> getPin() async => _storage.read(key: _pinKey);
  Future<void> deleteAll() async => _storage.deleteAll();
  Future<bool> hasToken() async => _storage.containsKey(key: _tokenKey);
}

void debugSafeLog(String message) {
  // Pesan status saja; tidak menerima/menampilkan kredensial.
  // ignore: avoid_print
  print('[SecureHub] $message');
}
