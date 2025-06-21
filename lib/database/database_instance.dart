import 'dart:io';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:syncfusion_flutter_maps/maps.dart';


// --- BAGIAN YANG DIPERBAIKI ---
// Path import disesuaikan dengan struktur folder Anda: lib/database/ & lib/models/
import '../models/lari_model.dart';
// ----------------------------

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

  // --- Konfigurasi Database ---
  static const String _databaseName = 'my_database.db';
  static const int _databaseVersion = 4;

  // --- Nama Tabel & Kolom (untuk mencegah typo) ---
  static const String lariTableName = 'lari';
  static const String colLariId = 'id';
  static const String colMulai = 'mulai';
  static const String colSelesai = 'selesai';

  static const String lariDetailTableName = 'lari_detail';
  static const String colDetailId = 'id';
  static const String colDetailLariId = 'lari_id'; // Foreign Key
  static const String colWaktu = 'waktu';
  static const String colLatitude = 'latitude';
  static const String colLongitude = 'longitude';

  // Inisialisasi Database
  Future<Database> _initDatabase() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, _databaseName);
    return await openDatabase(
      path,
      version: _databaseVersion,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
      // Aktifkan foreign key constraint untuk integritas data
      onConfigure: (db) async {
        await db.execute('PRAGMA foreign_keys = ON');
      },
    );
  }

  // Membuat skema tabel saat database pertama kali dibuat
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

  // Menangani migrasi jika versi database berubah
  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    // Di sini Anda bisa menambahkan logika migrasi di versi selanjutnya
    // Contoh: if (oldVersion < 5) { await db.execute("ALTER TABLE..."); }
    // print('Upgrading database from version $oldVersion to $newVersion...');
  }

  // --- Metode CRUD (Create, Read, Update, Delete) ---

  Future<int> insertLari(Map<String, dynamic> row) async {
    final db = await instance.database;
    return await db.insert(lariTableName, row);
  }

  Future<int> insertDetailLari(Map<String, dynamic> row) async {
    final db = await instance.database;
    return await db.insert(lariDetailTableName, row);
  }

// ... kode Anda yang lain di DatabaseInstance

  Future<List<LariModel>> getAllLari() async {
    final db = await instance.database;
    final data = await db.query(lariTableName, orderBy: '$colLariId DESC');

    // --- PERBAIKAN DIMULAI DI SINI ---
    final List<LariModel> lariList = [];
    for (var row in data) {
      // Gunakan try-catch untuk menangani setiap baris data secara terpisah.
      // Jika satu baris data rusak, aplikasi tidak akan crash,
      // dan akan lanjut ke baris data berikutnya.
      try {
        // Cek secara eksplisit bahwa data penting tidak null sebelum parsing
        if (row[colMulai] != null) {
          lariList.add(LariModel.fromJson(row));
        } else {
          // Jika data 'mulai' null, cetak pesan error dan lewati record ini.
          // print("Skipping record with id ${row[colLariId]} because 'mulai' is null.");
        }
      } catch (e) {
        // Jika ada error lain saat parsing (misal format tanggal salah),
        // ini juga akan ditangkap.
        // print("Failed to parse record with id ${row[colLariId]}. Error: $e");
      }
    }
    return lariList;
    // --- PERBAIKAN SELESAI ---
  }

// ... sisa kode Anda

  Future<List<MapLatLng>> getDetailLari(int lariId) async {
    final db = await instance.database;
    // Menggunakan `query` dengan `whereArgs` untuk keamanan (mencegah SQL Injection)
    final data = await db.query(
      lariDetailTableName,
      where: '$colDetailLariId = ?',
      whereArgs: [lariId],
    );

    // Konversi langsung dengan .map agar lebih ringkas
    return data.map((e) {
      return MapLatLng(e[colLatitude] as double, e[colLongitude] as double);
    }).toList();
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
  
  // Fungsi delete (berkat "ON DELETE CASCADE", detailnya akan ikut terhapus)
  Future<int> deleteLari(int lariId) async {
    final db = await instance.database;
    return await db.delete(
      lariTableName,
      where: '$colLariId = ?',
      whereArgs: [lariId],
    );
  }
}