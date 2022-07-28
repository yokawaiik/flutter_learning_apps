import 'dart:io';

import 'package:sqflite/sqflite.dart';

import "../constants/config.dart" as config;

import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

class DBHelper {
  Database? _db;

  Future<Database?> get db async {
    if (_db != null) return _db!;

    _db = await _initDatabase();
    return _db!;
  }

  // singleton for only one instance DB in the app
  DBHelper._privateConstructor();
  static final DBHelper instance = DBHelper._privateConstructor();

  Future<Database?> _initDatabase() async {
    Directory documentDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentDirectory.path, config.dataBaseName);

    return await openDatabase(
      path,
      version: config.dataBaseVersion,
      // onCreate: config.onCreate,
    );
  }

}