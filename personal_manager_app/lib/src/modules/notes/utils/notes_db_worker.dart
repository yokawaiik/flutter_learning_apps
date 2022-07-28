import 'dart:io';

import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:personal_manager_app/src/models/db_exception.dart';
import 'package:personal_manager_app/src/modules/notes/models/note.dart';
import 'package:sqflite/sqflite.dart';

import '../constants/db.dart' as config;

class NotesDBWorker {
  Database? _db;

  Future<Database> get notesDB async {
    if (_db != null) return _db!;

    _db = await _initDatabase();
    return _db!;
  }

  // singleton for only one instance DB in the app
  NotesDBWorker._privateConstructor();
  static final NotesDBWorker instance = NotesDBWorker._privateConstructor();

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
    await db.execute('''
        CREATE TABLE IF NOT EXISTS ${config.table} (
          ${config.id} INTEGER PRIMARY KEY AUTOINCREMENT,
          ${config.title} TEXT,
          ${config.content} TEXT,
          ${config.color} INTEGER
        )
      ''');
  }

  // actions
  Future<Note?> create(Note note) async {
    try {
      print(note);

      final db = await notesDB;


      final insertedId = await db.insert(config.table, note.toMap());

      // final insertedId = await db.rawInsert('''
      //     INSERT INTO notes (title, content, color)
      //     VALUES (?, ?, ?)
      //   ''', [
      //   note.title,
      //   note.content,
      //   note.color,
      // ]);

      print("insertedId $insertedId");

      note.id = insertedId;
      return note;
    } catch (e) {
      print("Future<Note?> create $e");
      DBException(e.toString());
    }
  }

  Future<Note?> get(int id) async {
    final db = await notesDB;

    final row = await db.query(
      config.table,
      where: "id = ?",
      whereArgs: [id],
    );

    return Note.fromMap(row.first);
  }

  Future<List<Note>> getAll() async {
    // Future getAll() async {
    try {
      final db = await notesDB;

      print("1");

      final notes = await db.query(config.table);

      return notes.isNotEmpty
          ? notes.map((item) {
              // print("Future<List<Note>> getAll() ${item}");
              return Note.fromMap(item);
            }).toList().reversed.toList()
          : [];
    } catch (e) {
      print("Future<List<Note>> getAll");
      throw DBException(e.toString());
    }
  }

  Future<int> update(Note note) async {
    final db = await notesDB;

    return await db.update(
      config.table,
      note.toMap(),
      where: "id = ?",
      whereArgs: [note.id],
    );
  }

  Future<int> delete(int id) async {
    final db = await notesDB;

    return await db.delete(
      config.table,
      where: "id = ?",
      whereArgs: [id],
    );
  }
}
