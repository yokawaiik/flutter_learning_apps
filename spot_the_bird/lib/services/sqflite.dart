import 'dart:io';

import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static final _dataBaseName = "DBSpotTheBird.db";
  static final _dataBaseVersion = 1;

  // table
  static final table = "spots";
  static final columnId = "id";

  // name field
  static final columnTitle = "Birdname";
  static final columnDescription = "birdDescription";
  static final columnUrl = "url";
  static final longitude = "longitude";
  static final latitude = "latitude";

  // singleton for only one instance DB in the app
  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  // path to db
  Future<Database> _initDatabase() async {
    Directory documentDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentDirectory.path, _dataBaseName);

    return await openDatabase(
      path,
      version: _dataBaseVersion,
      onCreate: _onCreate,
    );
  }

  // DATABASE
  // create table
  Future<void> _onCreate(Database database, int version) async {
    await database.execute("""
        CREATE TABLE $table (
          $columnId INTEGER PRIMARY KEY,

          $columnTitle TEXT NOT NULL,
          $columnDescription TEXT NOT NULL,
          $columnUrl TEXT NOT NULL,
          $latitude REAL NOT NULL,
          $longitude REAL NOT NULL
        )
      """);
  }

  Future<int?> insert(Map<String, dynamic> row) async {
    Database? db = await instance.database;
    return await db!.insert(table, row);
  }

  Future<int?> delete(int id) async {
    Database? db = await instance.database;
    return await db!.delete(table, where: "$columnId = ?", whereArgs: [id]);
  }

  Future<List<Map<String, dynamic>>> qureyAllRows() async {
    Database? db = await instance.database;
    return await db!.query(table);
  }

  //
  // END DATABASE

  // only one app-wide reference to db
  static Database? _database;

  Future<Database?> get database async {
    if (_database != null) return _database;
    _database = await _initDatabase();
    return _database;
  }
}
