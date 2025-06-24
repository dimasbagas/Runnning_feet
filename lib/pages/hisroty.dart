import 'package:flutter/material.dart';
import 'package:runningfeet/database/database_instance.dart';
import 'package:runningfeet/models/lari_model.dart';
import 'package:runningfeet/pages/button_navigation.dart';

import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:runningfeet/pages/maps.dart';

class History extends StatefulWidget {
  const History({super.key});

  @override
  State<History> createState() => _HistoryState();
}

class _HistoryState extends State<History> {
  final Color mainOrange = const Color(0xFFff7f27);
  final Color mainSage = const Color(0xFF1FB69A);

  final DatabaseInstance _databaseInstance = DatabaseInstance.instance;

  late Future<List<LariModel>> _lariData;
  late Future<Map<String, dynamic>> _weatherData;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  void _loadData() {
    _weatherData = _getDataFromAPI();
    _lariData = _databaseInstance.getAllLari();
  }

  Future<Map<String, dynamic>> _getDataFromAPI() async {
    try {
      final response = await http.get(
        Uri.parse(
          "https://api.openweathermap.org/data/2.5/weather?q=Pamekasan&appid=44be9e79396d022e0b9503a4fe80ea26&units=metric",
        ),
      );

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception(
          'Gagal memuat data cuaca. Status Code: ${response.statusCode}',
        );
      }
    } catch (e) {
      return Future.error(
        'Tidak ada koneksi internet atau server bermasalah: $e',
      );
    }
  }

  void _deleteLari(int? id) async {
    if (id != null) {
      await _databaseInstance.deleteLari(id);
      setState(() {
        _lariData = _databaseInstance.getAllLari();
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Catatan lari berhasil dihapus!')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Running Tracking"),
        titleTextStyle: Theme.of(context).textTheme.titleLarge?.copyWith(
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
        centerTitle: true,
        backgroundColor: mainSage,
      ),
      body: SafeArea(
        child: Container(
          color: mainSage,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                FutureBuilder<Map<String, dynamic>>(
                  future: _weatherData,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      return Card(
                        color: Colors.red.shade100,
                        margin: const EdgeInsets.symmetric(vertical: 8.0),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Text(
                            'Error: ${snapshot.error}',
                            style: const TextStyle(color: Colors.red),
                          ),
                        ),
                      );
                    } else if (snapshot.hasData) {
                      final data = snapshot.data!;
                      final main = data['main'];
                      final weatherInfo = data['weather'][0];
                      final temperature = main['temp'];
                      final description = weatherInfo['description'];
                      final cityName = data['name'];

                      return Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        margin: const EdgeInsets.symmetric(vertical: 8.0),
                        child: Container(
                          decoration: BoxDecoration(
                            color: mainOrange,
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Cuaca di $cityName",
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  "Suhu: ${temperature.toStringAsFixed(1)} °C",
                                  style: const TextStyle(
                                    fontSize: 16,
                                    color: Colors.white,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  "Kondisi: ${description[0].toUpperCase()}${description.substring(1)}",
                                  style: const TextStyle(
                                    fontSize: 16,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    } else {
                      return const Center(
                        child: Text('Tidak ada data cuaca yang tersedia'),
                      );
                    }
                  },
                ),
                const SizedBox(height: 10),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Riwayat Lari",
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const Divider(color: Colors.white70),
                Expanded(
                  child: FutureBuilder<List<LariModel>>(
                    future: _lariData,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      } else if (snapshot.hasError) {
                        return Center(
                          child: Text(
                            "Error: ${snapshot.error}",
                            style: const TextStyle(color: Colors.redAccent),
                          ),
                        );
                      } else if (snapshot.hasData &&
                          snapshot.data!.isNotEmpty) {
                        final lariList = snapshot.data!;
                        return ListView.builder(
                          itemCount: lariList.length,
                          itemBuilder: (context, index) {
                            final lari = lariList[index];

                            String durasiText = "Lari belum selesai";
                            if (lari.selesai != null) {
                              final durasi = lari.selesai!.difference(
                                lari.mulai,
                              );
                              durasiText =
                                  "Durasi: ${durasi.inHours} jam ${durasi.inMinutes.remainder(60)} menit ${durasi.inSeconds.remainder(60)} detik";
                            }

                            return Card(
                              color: mainOrange,
                              margin: const EdgeInsets.symmetric(vertical: 6.0),
                              child: ListTile(
                                leading: const Icon(
                                  Icons.run_circle_outlined,
                                  color: Colors.white,
                                  size: 40,
                                ),
                                title: Text(
                                  "Lari #${lari.id}",
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Mulai: ${DateFormat('dd MMMM HH:mm').format(lari.mulai)}",
                                      style: const TextStyle(
                                        color: Colors.white70,
                                      ),
                                    ),
                                    if (lari.selesai != null)
                                      Text(
                                        "Selesai : ${DateFormat('dd MMMM HH:mm').format(lari.selesai!)}",
                                        style: const TextStyle(
                                          color: Colors.white70,
                                        ),
                                      ),
                                    Text(
                                      durasiText,
                                      style: const TextStyle(
                                        color: Colors.white70,
                                      ),
                                    ),
                                  ],
                                ),
                                trailing: IconButton(
                                  icon: const Icon(
                                    Icons.delete,
                                    color: Colors.white,
                                  ),
                                  onPressed: () => _deleteLari(lari.id),
                                ),
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          Maps(lariId: lari.id!),
                                    ),
                                  );
                                },
                              ),
                            );
                          },
                        );
                      } else {
                        return const Center(
                          child: Text(
                            'Tidak ada riwayat lari ditemukan.',
                            style: TextStyle(color: Colors.white70),
                          ),
                        );
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: ButtonNavigation(
        lariId: 1,
        onTap: () {
          setState(() {
            _lariData = _databaseInstance
                .getAllLari(); // ⬅️ Refresh otomatis setelah kembali dari Running
          });
        },
      ),
    );
  }
}
