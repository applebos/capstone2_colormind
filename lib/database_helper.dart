
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';


class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;
  static Database? _database;

  DatabaseHelper._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, 'colormind.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE emotion_data(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        date TEXT NOT NULL,
        imagePath TEXT NOT NULL,
        emotions TEXT NOT NULL,
        metadata TEXT
      )
    ''');
  }

  Future<int> insertEmotionData(Map<String, dynamic> row) async {
    Database db = await database;
    return await db.insert('emotion_data', row);
  }

  Future<List<Map<String, dynamic>>> queryAllEmotionData() async {
    Database db = await database;
    return await db.query('emotion_data');
  }

  Future<List<Map<String, dynamic>>> queryEmotionDataByDate(String date) async {
    Database db = await database;
    return await db.query('emotion_data', where: 'date = ?', whereArgs: [date]);
  }
}
