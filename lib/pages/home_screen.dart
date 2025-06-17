import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Running Tracking")),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(8.0),
          child: Column(
            children: [
              // kondisi cuaca hari ini
              Card(
                child: Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Cuaca di pamekasan",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text("Suhu: °C'", style: TextStyle(fontSize: 16)),
                      Text('Kondisi: ', style: TextStyle(fontSize: 16)),
                    ],
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
    );
  }
}