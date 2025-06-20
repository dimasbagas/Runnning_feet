import 'dart:io';
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:runningfeet/models/lari_detail_models.dart';
import 'package:sqflite/sqflite.dart';

import '../models/lari_model.dart';

class DatabaseInstance {
  DatabaseInstance._privateConstructor();
  static final DatabaseInstance instance = DatabaseInstance._privateConstructor();

  static Database? _database;
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database;
  }

  static const String _databaseName = 'my_database.db';
  static const int _databaseVersion = 4;


  static const String lariTableName = 'lari';
  static const String colLariID = 'id';
  static const String colMulai = 'mulai';
  static const String colSelesai = 'selesai';


  static const String lariDetailTableName = 'lari_detail';
  static const String colDetailId = 'id';
  static const String colDetailLariId = 'lari_id';
  static const String colWaktu = 'waktu';
  static const String colLatitude = 'latitude';
  static const String colLongitude = 'longitude';


  Future<Database> _initDatabase() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, _databaseName);
    return await openDatabase(
      path,
      version: _databaseVersion,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
      onConfigure: (db) async {
        await db.execute('PRAGMA foreign_keys = on');
      },
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE $lariDetailTableName (
        $colLariID INTEGER PRIMARY KEY AUTOINCREMENT,
        $colMulai TEXT,
        $colSelesai TEXT
      )
    ''');

    await db.execute('''
      CREATE TABLE $lariDetailTableName (
      $colDetailId INTEGER PRIMARY KEY AUTOINCREMENT,
      $colDetailLariId INTEGER NOT NULL,
      $colWaktu TEXT NOT NULL,
      $colLatitude REAL NOT NULL, 
      $colLongitude REAL NOT NULL,
      FOREIGN KEY ($colDetailLariId) REFERENCES $lariTableName  ($colLariID) ON DELETE CASCADE
      )
    ''');
  }

  Future<int> insertLari(Map<String, dynamic> row) async {
    final db = await instance.database;
    return await db.insert(lariTableName, row);
  }

  Future<int> insertDetailLari(Map<String, dynamic> row) async {
    final db = await instance.database;
    return await db.insert(lariDetailTableName, row);
  }

  Future<List<LariModel>> getAllLari() async {
    final db = await instance.database;
    final data = await db.query(lariTableName, orderBy: '$colLariID DESC');

    final List<LariModel> lariList = [];
    for (var row in data) {
      try {
        if (row[colMulai] != null) {
          lariList.add(LariModel.fromJson(row));
        }
      } catch (e) {
        print("Failed to parse record with id ${row[colLariID]}. Error: $e");
      }
    }
    return lariList;
  }

  Future<List<MapLating>> getDetailLari(int lariId) async {
    final data = await db.query(
      lariDetailTableName,
      where: '$colDetailLariId = ?',
      whereArgs: [lariId],
    );

    return data.map((e) {
      return MapLatLng(e[colLatitude] as double, e[colLongitude] as double);
    }).toList();
  }

  Future<int> updateLari(int LariId, Map<String, dynamic> row) async {
      final db = await instance.database;
      return await db.update(
        lariTableName,
        row,
        where: '$colLariID = ?',
        whereArgs: [LariId],
      );
  }
}