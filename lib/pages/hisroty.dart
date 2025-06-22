import 'package:flutter/material.dart';
import 'package:runningfeet/database/database_instance.dart';
import 'package:runningfeet/models/lari_detail_models.dart';
import 'package:runningfeet/pages/button_navigation.dart';

import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart';

class History extends StatefulWidget {
  const History({super.key});

  @override
  State<History> createState() => _HistoryState();
}

class _HistoryState extends State<History> {
  final Color mainOrange = const Color(0xFFff7f27);
  final Color mainSage = const Color(0xFF1FB69A);

  final DatabaseInstance _databaseInstance = DatabaseInstance.instance;

  // late Future<List<LariModel>> _lariData;
  late Future<Map<String, dynamic>> _weatherData;

  @override
  void initState() {
    super.initState();
    // Panggil method untuk memuat semua data
    _loadData();
  }

  void _loadData() {
    _weatherData = _getDataFromAPI();
    // _lariData = _databaseInstance.getAllLari();
    _databaseInstance.database;
  }

  Future<Map<String, dynamic>> _getDataFromAPI() async {
    // Fungsi ini sudah bagus, tidak ada perubahan
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
      // Lebih baik menampilkan pesan error yang lebih spesifik
      return Future.error('Tidak ada koneksi internet atau server bermasalah.');
    }
  }

  // Navigasi ke CreatePage dan refresh data setelah kembali
  void _navigateToCreatePage() async {
    // PERBAIKAN LOGIKA: Tunggu hasil dari halaman CreatePage
    await Navigator.of(
      context,
    ).push(MaterialPageRoute(builder: (context) => const CreatePage()));

    // Setelah kembali, refresh data lari dengan memanggil setState
    setState(() {
      _lariData = _databaseInstance.getAllLari();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Running Tracking"), centerTitle: true),
      backgroundColor: mainSage,
      body: SafeArea(
        child: Container(
          color: mainSage,
          child: Padding(
            padding: EdgeInsets.all(8.0),
            child: Column(
              children: [
                // kondisi cuaca hari ini
                FutureBuilder<Map<String, dynamic>>(
                  future: _weatherData,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      return Card(
                        color: Colors.red.shade100,
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Text(
                            'Error: ${snapshot.error}',
                            style: TextStyle(color: Colors.red),
                          ),
                        ),
                      );
                    } else if (snapshot.hasData) {
                      final data = snapshot.data!;
                      final main = data['main'];
                      final weather = data['weather'][0]['description'];
                      final temperature = main['temp'];
                      final description = weather['description'];
                      final cityName = data['name'];

                      return Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Container(
                          decoration: BoxDecoration(
                            color: mainOrange,
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Padding(
                            padding: EdgeInsets.all(16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Cuaca di $cityName",
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  "Suhu: $temperature °C",
                                  style: TextStyle(fontSize: 16),
                                ),
                                Text(
                                  "Kondisi: ${description[0].toUpperCase()}${description.substring(1)}",
                                  style: TextStyle(fontSize: 16),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    } else {
                      return Center(child: Text('Tidak ada data cuaca'));
                    }
                  },
                ),
                // Card(
                //   shape: RoundedRectangleBorder(
                //     borderRadius: BorderRadius.circular(15),
                //   ),
                //   child: Container(
                //     decoration: BoxDecoration(
                //       color: mainOrange,
                //       borderRadius: BorderRadius.circular(15),
                //     ),
                //     child: Padding(
                //       padding: EdgeInsets.all(16.0),
                //       child: Column(
                //         crossAxisAlignment: CrossAxisAlignment.start,
                //         children: [
                //           Text(
                //             "Cuaca di Pamekasan",
                //             style: TextStyle(
                //               fontSize: 18,
                //               fontWeight: FontWeight.bold,
                //             ),
                //           ),
                //           Text("Suhu: °C", style: TextStyle(fontSize: 16)),
                //           Text("Kondisi: ", style: TextStyle(fontSize: 16)),
                //         ],
                //       ),
                //     ),
                //   ),
                // ),

                // card riwayat lari
                SizedBox(height: 10),
                Text(
                  "Riwayat Lari",
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const Divider(),
                Expanded(
                  child: FutureBuilder<List<LariModel>>(
                    future: _lariData,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      } else if (snapshot.hasError) {
                        return Center( child: Text("Error: ${snapshot.error}"));
                      } else if (snapshot.hasData) {
                        final lariList = snapshot.data!;
                        return ListView.builder(
                          itemCount: lariList.length,
                          itemBuilder: (context, index) {
                            final lari = lariList[index];

                            String durasiText = "Lari belum selesai";
                            if (lari.selesai != null) {
                              final durasi = lari.selesai!.difference(lari.mulai);
                              durasiText = "Durasi: ${durasi.inHours} jam ${durasi.inMinutes.remainder(60)} menit ${durasi.inSeconds.remainder(60)}";
                            }
                          }
                          );
                      }
                    },

                    return Card (
                      margrin: const EdgeInsets.symmetric(vertical: 6.0),
                      child: ListTile(
                        leading: const,
                      ),
                    )
                    color: mainOrange,
                    margin: const EdgeInsets.symmetric(vertical: 6.0),
                    child: Padding(
                      // Tambahkan Padding di sekitar konten Card
                      padding: const EdgeInsets.symmetric(
                        vertical: 8.0,
                        horizontal: 16.0,
                      ), // Sesuaikan padding sesuai kebutuhan
                      child: Row(
                        // Gunakan Row untuk menampung ikon dan teks
                        crossAxisAlignment:
                            CrossAxisAlignment.center, // Atur perataan vertikal
                        children: [
                          const Icon(
                            Icons.run_circle_outlined,
                            color: Colors.blue,
                            size: 40,
                          ),
                          SizedBox(
                            width: 16,
                          ), // Beri sedikit jarak antara ikon dan teks
                          Expanded(
                            // Gunakan Expanded agar Column teks mengisi sisa ruang
                            child: Column(
                              crossAxisAlignment:
                                  CrossAxisAlignment.start, // Agar teks rata kiri
                              mainAxisAlignment: MainAxisAlignment
                                  .center, // Pusatkan teks secara vertikal dalam Column
                              children: [
                                Text(
                                  "Lari #${lari.id}",
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ), // Opsional: Beri style pada judul
                                ),
                                Text("Mulai: ${DateFormat('dd MMMM yyyy HH:mm').format(lari.mulai)}"),
                                if (lari.selesai != null)
                                Text("Selesai : ${DateFormat('dd MMMM yyyy HH:mm').format(lari.selesai!)}"),
                                Text(durasiText),
                              ],
                            ),
                          ),
                          const Icon(Icons.arrow_forward_ios),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: ButtonNavigation(onTap: () {}),
    );
  }
}
