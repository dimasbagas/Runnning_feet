import 'package:flutter/material.dart';
import 'package:runningfeet/pages/button_navigation.dart';

class History extends StatefulWidget {
  const History({super.key});

  @override
  State<History> createState() => _HistoryState();
}

class _HistoryState extends State<History> {
  final Color mainOrange = const Color(0xFFff7f27);
  final Color mainSage = const Color(0xFF1FB69A);

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
                Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(
                      15,
                    ),
                  ),
                  child: Container(
                    decoration: BoxDecoration(
                      color: mainOrange,
                      borderRadius: BorderRadius.circular(
                        15,
                      ),
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Cuaca di Pamekasan",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            "Suhu: °C",
                            style: TextStyle(fontSize: 16),
                          ),
                          Text("Kondisi: ", style: TextStyle(fontSize: 16)),
                        ],
                      ),
                    ),
                  ),
                ),

                // card riwayat lari
                SizedBox(height: 10),
                Text(
                  "Riwayat Lari",
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const Divider(),
                Card(
                  color: mainOrange,
                  margin: const EdgeInsets.symmetric(vertical: 6.0),
                  child: Padding( // Tambahkan Padding di sekitar konten Card
                    padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0), // Sesuaikan padding sesuai kebutuhan
                    child: Row( // Gunakan Row untuk menampung ikon dan teks
                      crossAxisAlignment: CrossAxisAlignment.center, // Atur perataan vertikal
                      children: [
                        const Icon(
                          Icons.run_circle_outlined,
                          color: Colors.blue,
                          size: 40,
                        ),
                        SizedBox(width: 16), // Beri sedikit jarak antara ikon dan teks
                        Expanded( // Gunakan Expanded agar Column teks mengisi sisa ruang
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start, // Agar teks rata kiri
                            mainAxisAlignment: MainAxisAlignment.center, // Pusatkan teks secara vertikal dalam Column
                            children: [
                              Text(
                                "Lari lari id",
                                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold), // Opsional: Beri style pada judul
                              ),
                              Text("Mulai"),
                              Text("Selesai"),
                              Text("durasi text"),
                            ],
                          ),
                        ),
                        const Icon(Icons.arrow_forward_ios),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: ButtonNavigation(
        onTap: () {},
      ),
    );
  }
}