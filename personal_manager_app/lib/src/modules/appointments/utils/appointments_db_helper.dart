import 'dart:io';

import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:personal_manager_app/src/models/db_exception.dart';
import 'package:personal_manager_app/src/modules/appointments/models/appointment.dart';

import 'package:personal_manager_app/src/modules/tasks/models/task.dart';
import 'package:sqflite/sqflite.dart';

import '../constants/db_config.dart' as config;

class AppointmentsDBHelper {
  Database? _db;

  Future<Database> get database async {
    if (_db != null) return _db!;

    _db = await _initDatabase();
    return _db!;
  }

  // singleton for only one instance DB in the app
  AppointmentsDBHelper._privateConstructor();
  static final AppointmentsDBHelper instance =
      AppointmentsDBHelper._privateConstructor();

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
  Future<Appointment?> create(Appointment task) async {
    try {
      final db = await database;

      final insertedId = await db.insert(config.table, task.toMap());

      print("insertedId $insertedId");

      task.id = insertedId;

      return task;
    } catch (e) {
      print("Future<Appointment?> create $e");
      DBException(e.toString());
    }
  }

  Future<Appointment?> get(int id) async {
    final db = await database;

    final row = await db.query(
      config.table,
      where: "id = ?",
      whereArgs: [id],
    );

    return Appointment.fromMap(row.first);
  }

  Future<List<Appointment>> getAll(DateTime currentDate) async {
    try {
      final db = await database;

      final startDate = DateTime(currentDate.year, currentDate.month);
      final endDate = DateTime(currentDate.year, currentDate.month + 1);

      final tasks = await db.query(
        config.table,
        where: "${config.apptDate} BETWEEN ? AND ?",
        whereArgs: [
          startDate.microsecondsSinceEpoch,
          endDate.microsecondsSinceEpoch,
        ],
      );

      print(tasks);

      return tasks.isNotEmpty
          ? tasks
              .map((item) {
                return Appointment.fromMap(item);
              })
              .toList()
              .reversed
              .toList()
          : [];
    } catch (e) {
      print("Future<List<Appointment>> getAll");
      throw DBException(e.toString());
    }
  }

  Future<int> update(Appointment task) async {
    final db = await database;

    return await db.update(
      config.table,
      task.toMap(),
      where: "id = ?",
      whereArgs: [task.id],
    );
  }

  Future<int> delete(int id) async {
    final db = await database;

    return await db.delete(
      config.table,
      where: "id = ?",
      whereArgs: [id],
    );
  }
}
