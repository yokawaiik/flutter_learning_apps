import 'dart:io';

import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:personal_manager_app/src/models/db_exception.dart';
import 'package:personal_manager_app/src/modules/contacts/models/contact.dart';

import 'package:sqflite/sqflite.dart';

import '../constants/db_config.dart' as config;

class ContactsDBHelper {
  Database? _db;

  Future<Database> get tasksDB async {
    if (_db != null) return _db!;

    _db = await _initDatabase();
    return _db!;
  }

  // singleton for only one instance DB in the app
  ContactsDBHelper._privateConstructor();
  static final ContactsDBHelper instance = ContactsDBHelper._privateConstructor();

  Future<Database?> _initDatabase() async {
    Directory documentDirectory = await getApplicationDocumentsDirectory();
    String path = join(
      documentDirectory.path,
      config.dataBaseName,
    );

    return await openDatabase(
      path,
      version: config.dataBaseVersion,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute(config.createTableTasksSql());
  }

  // actions
  Future<Contact?> create(Contact task) async {
    try {
      print(task);

      final db = await tasksDB;

      final insertedId = await db.insert(config.table, task.toMap());

      print("insertedId $insertedId");

      task.id = insertedId;

      return task;
    } catch (e) {
      print("Future<Task?> create $e");
      DBException(e.toString());
    }
  }

  Future<Contact?> get(int id) async {
    final db = await tasksDB;

    final row = await db.query(
      config.table,
      where: "id = ?",
      whereArgs: [id],
    );

    return Contact.fromMap(row.first);
  }

  Future<List<Contact>> getAll() async {
    // Future getAll() async {
    try {
      final db = await tasksDB;

      print("1");

      final contacts = await db.query(config.table);

      return contacts.isNotEmpty
          ? contacts
              .map((item) {
                return Contact.fromMap(item);
              })
              .toList()
              .reversed
              .toList()
          : [];
    } catch (e) {
      print("Future<List<Task>> getAll");
      throw DBException(e.toString());
    }
  }

  Future<int> update(Contact task) async {
    final db = await tasksDB;

    return await db.update(
      config.table,
      task.toMap(),
      where: "id = ?",
      whereArgs: [task.id],
    );
  }

  Future<int> delete(int id) async {
    final db = await tasksDB;

    return await db.delete(
      config.table,
      where: "id = ?",
      whereArgs: [id],
    );
  }

  Future<void> updateStatus(Contact task) async {
    final db = await tasksDB;

    await db.update(
      config.table,
      task.toMap(),
      where: "id = ?",
      whereArgs: [task.id],
    );
  }
}
