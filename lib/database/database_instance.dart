import 'dart:io';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import '../models/lari_model.dart'; 

class DatabaseInstance {
  // Implementasi Singleton Pattern
  DatabaseInstance._privateConstructor();
  static final DatabaseInstance instance = DatabaseInstance._privateConstructor();

  static Database? _database;
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  static const String _databaseName = 'my_database.db';
  static const int _databaseVersion = 4;

  static const String lariTableName = 'lari';
  static const String colLariId = 'id';
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
        await db.execute('PRAGMA foreign_keys = ON');
      },
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE $lariTableName (
        $colLariId INTEGER PRIMARY KEY AUTOINCREMENT,
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
        FOREIGN KEY ($colDetailLariId) REFERENCES $lariTableName ($colLariId) ON DELETE CASCADE
      )
    ''');
  }

  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    // Implementasi upgrade database jika diperlukan.
    // Contoh: menambahkan kolom baru atau memodifikasi tabel.
    // Jangan lupa untuk mengubah _databaseVersion jika Anda memodifikasi skema.
    // Misalnya, jika Anda ingin menghapus tabel lama dan membuat ulang:
    // if (oldVersion < 2) {
    //   await db.execute('DROP TABLE IF EXISTS $lariDetailTableName');
    //   await db.execute('DROP TABLE IF EXISTS $lariTableName');
    //   await _onCreate(db, newVersion);
    // }
  }

  Future<int> insertLari(Map<String, dynamic> row) async {
    final db = await instance.database;
    return await db.insert(lariTableName, row);
  }

  Future<int> insertDetailLari(Map<String, dynamic> row) async {
    final db = await instance.database;
    return await db.insert(lariDetailTableName, row);
  }

  // Mengembalikan List<LariModel>
  Future<List<LariModel>> getAllLari() async {
    final db = await instance.database;
    final data = await db.query(lariTableName, orderBy: '$colLariId DESC');

    final List<LariModel> lariList = [];
    for (var row in data) {
      try {
        // PERHATIAN: Pastikan LariModel.fromJson dapat menangani row[colMulai] yang mungkin null
        // Jika lari belum selesai, colSelesai bisa null.
        // Konfirmasi LariModel.fromJson Anda mendukung ini.
        lariList.add(LariModel.fromJson(row));
      } catch (e) {
        // Sebaiknya gunakan print atau logger untuk debugging
        // print("Gagal parsing record lari dengan id ${row[colLariId]}. Error: $e");
        // Atau Anda bisa memilih untuk tidak menambahkan yang gagal parse
      }
    }
    return lariList;
  }

  // Mengubah nama method agar sesuai dengan yang diharapkan di Maps widget
  // Mengembalikan List<Map<String, dynamic>> agar Maps widget bisa memprosesnya
  Future<List<Map<String, dynamic>>> getDetailLariByLariId(int lariId) async {
    final db = await instance.database;
    final data = await db.query(
      lariDetailTableName,
      where: '$colDetailLariId = ?',
      whereArgs: [lariId],
      orderBy: '$colWaktu ASC', // Penting untuk urutan rute di peta
    );
    // Mengembalikan raw data Map<String, dynamic>
    // Maps widget yang akan mengubahnya menjadi MapLatLng
    return data;
  }

  Future<int> updateLari(int lariId, Map<String, dynamic> row) async {
    final db = await instance.database;
    return await db.update(
      lariTableName,
      row,
      where: '$colLariId = ?',
      whereArgs: [lariId],
    );
  }
  
  Future<int> deleteLari(int lariId) async {
    final db = await instance.database;
    return await db.delete(
      lariTableName,
      where: '$colLariId = ?',
      whereArgs: [lariId],
    );
  }
}