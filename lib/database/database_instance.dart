

import 'dart:io';

import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

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
    String path - join(documentsDirectory.path, _databaseName);
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
}