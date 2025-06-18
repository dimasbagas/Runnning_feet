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
      appBar: AppBar(title: Text("Running Tracking")),
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
                    ), // Melengkungkan sudut Card
                  ),
                  child: Container(
                    decoration: BoxDecoration(
                      color: mainOrange,
                      borderRadius: BorderRadius.circular(
                        15,
                      ), // Pastikan tetap ada
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
                          ), // Perbaiki tanda kutip
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
                  child: ListTile(
                    leading: const Icon(
                      Icons.run_circle_outlined,
                      color: Colors.blue,
                      size: 40,
                    ),
                    title: Text("Lari lari id"),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Mulai"),
                        Text("Selesai"),
                        Text("durasi text"),
                      ],
                    ),
                    trailing: const Icon(Icons.arrow_forward_ios),
                    isThreeLine: true,
                    onTap: () {},
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: ButtonNavigation(
        onTap: () {
          // Tambahkan aksi sesuai kebutuhan, misalnya navigasi
        },
      ),
    );
  }
}
