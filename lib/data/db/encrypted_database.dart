import 'dart:math';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:sqflite_sqlcipher/sqflite.dart';

class EncryptedDatabase {
  static Database? _db;
  static const _dbName = 'secure_passwords.db';
  static const _tableName = 'credentials';
  static const _passKey = 'db_encryption_key';

  static final FlutterSecureStorage _secureStorage = FlutterSecureStorage();

  static Future<Database> get database async {
    if (_db != null) return _db!;

    // Get or generate encryption key
    String? password = await _secureStorage.read(key: _passKey);
    if (password == null) {
      password = _generateRandomKey();
      await _secureStorage.write(key: _passKey, value: password);
    }

    _db = await openDatabase(
      _dbName,
      password: password,
      version: 1,
      onCreate: (db, version) {
        return db.execute('''
          CREATE TABLE $_tableName(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            siteName TEXT,
            username TEXT,
            password TEXT,
            category TEXT
          )
        ''');
      },
    );

    return _db!;
  }

  static String _generateRandomKey() {
    const chars = 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
    final rand = Random.secure();
    return List.generate(32, (_) => chars[rand.nextInt(chars.length)]).join();
  }
}
