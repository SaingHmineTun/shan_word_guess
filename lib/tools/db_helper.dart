import 'dart:io';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'data.dart'; // Import your static shanSentences list

class DBHelper {
  static Future<Database> database() async {
    if (Platform.isWindows || Platform.isLinux) {
      sqfliteFfiInit();
      databaseFactory = databaseFactoryFfi;
    }

    final dbPath = await getDatabasesPath();

    return openDatabase(
      join(dbPath, 'shan_sentences.db'),
      onCreate: (db, version) async {
        // 1. Create the table
        await db.execute(
          'CREATE TABLE sentences(id INTEGER PRIMARY KEY AUTOINCREMENT, text TEXT)',
        );
        // 2. Seed the database with static data immediately on creation
        for (var sentence in shanSentences) {
          await db.insert('sentences', {'text': sentence});
        }
      },
      version: 1,
    );
  }

  // Helper method to manually check if we need to seed (optional safety)
  static Future<void> checkAndSeed() async {
    final db = await DBHelper.database();
    final data = await db.query('sentences');
    if (data.isEmpty) {
      for (var sentence in shanSentences) {
        await db.insert('sentences', {'text': sentence});
      }
    }
  }

  static Future<void> insert(String table, Map<String, Object> data) async {
    final db = await DBHelper.database();
    await db.insert(table, data, conflictAlgorithm: ConflictAlgorithm.replace);
  }

  static Future<List<Map<String, dynamic>>> getData(String table) async {
    final db = await DBHelper.database();
    return db.query(table);
  }

  static Future<void> delete(int id) async {
    final db = await DBHelper.database();
    await db.delete('sentences', where: 'id = ?', whereArgs: [id]);
  }

  static Future<void> update(int id, String newText) async {
    final db = await DBHelper.database();
    await db.update('sentences', {'text': newText}, where: 'id = ?', whereArgs: [id]);
  }

  static Future<void> deleteAll() async {
    final db = await DBHelper.database();
    await db.delete('sentences');
  }

}