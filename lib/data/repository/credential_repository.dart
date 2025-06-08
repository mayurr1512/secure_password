import 'package:password_manager/data/db/encrypted_database.dart';
import '../model/credential.dart';

class CredentialRepository {
  final _table = 'credentials';

  Future<Credential> insertCredential(Credential credential) async {
    final db = await EncryptedDatabase.database;
    final id = await db.insert(_table, credential.toMap()); // id auto-generated here
    return credential.copyWith(id: id); // Return the updated object with new id
  }

  Future<List<Credential>> getAllCredentials() async {
    final db = await EncryptedDatabase.database;
    final List<Map<String, dynamic>> maps = await db.query(_table);
    return maps.map((map) => Credential.fromMap(map)).toList();
  }

  Future<void> updateCredential(Credential credential) async {
    final db = await EncryptedDatabase.database;
    await db.update(
      _table,
      credential.toMap(),
      where: 'id = ?',
      whereArgs: [credential.id ?? 0],
    );
  }

  Future<void> deleteCredential(num? id) async {
    final db = await EncryptedDatabase.database;
    await db.delete(_table, where: 'id = ?', whereArgs: [id ?? 0]);
  }

  Future<void> clearAll() async {
    final db = await EncryptedDatabase.database;
    await db.delete(_table);
  }
}
