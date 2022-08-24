import 'dart:io';

import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

import '../model/model.dart';

class DatabaseHelper {
  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  static Database? _database;
  Future<Database> get database async => _database ??= await _initDatabase();

  Future<Database> _initDatabase() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, 'schedules.db');
    print(documentsDirectory);
    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE schedules(
        id INTEGER PRIMARY KEY,
        time TEXT,
        gr INT
      )
    ''');
  }

  Future<List<Schedules>> getSchedules() async {
    Database db = await instance.database;
    var schedules = await db.query('schedules', orderBy: 'time');
    List<Schedules> SchedulesList = schedules.isNotEmpty
        ? schedules.map((c) => Schedules.fromMap(c)).toList()
        : [];

    return SchedulesList;
  }

  Future<int> add(Schedules schedules) async {
    Database db = await instance.database;
    return await db.insert('schedules', schedules.toMap());
  }

  Future<int> remove(int id) async {
    Database db = await instance.database;
    return await db.delete('schedules', where: 'id = ?', whereArgs: [id]);
  }

  Future<int> update(Schedules schedules) async {
    Database db = await instance.database;
    print('update yok');
    return await db.update('schedules', schedules.toMap(),
        where: 'id = ?', whereArgs: [schedules.id]);
  }
}
