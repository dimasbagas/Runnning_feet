import 'package:flutter/material.dart';
import 'package:connectivity_plus/connectivity_plus.dart'; // Tambahkan dependensi ini
import 'package:runningfeet/pages/hisroty.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Firstpage(),
    );
  }
}

class Firstpage extends StatefulWidget {
  const Firstpage({super.key});

  @override
  State<Firstpage> createState() => _FirstpageState();
}

class _FirstpageState extends State<Firstpage> {
  bool _isConnected = true; // Status koneksi awal

  @override
  void initState() {
    super.initState();
    _checkInternetConnection(); // Cek koneksi saat aplikasi dimulai
  }

  Future<void> _checkInternetConnection() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    setState(() {
      _isConnected = (connectivityResult != ConnectivityResult.none);
    });

    // Pantau perubahan koneksi secara real-time
    Connectivity().onConnectivityChanged.listen((ConnectivityResult result) {
      setState(() {
        _isConnected = (result != ConnectivityResult.none);
      });
    } as void Function(List<ConnectivityResult> event)?);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: const Color(0xFF1FB69A),
        child: SafeArea(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset('assets/image/logo.png'),
                const Text(
                  "RunningFeet",
                  style: TextStyle(
                    fontSize: 40,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFFFE7F20),
                  ),
                ),
                const SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 40.0),
                  child: Text(
                    "Control your exercise activity tracking with various health statistics",
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 16, color: Color(0xffffffff)),
                  ),
                ),
                const SizedBox(height: 20), // Jarak sebelum status koneksi
                Text(
                  _isConnected
                      ? ''
                      : '',
                  style: TextStyle(
                    fontSize: 16,
                    color: _isConnected ? Colors.green : Colors.red,
                  ),
                ),
                const SizedBox(height: 40), // Jarak sebelum tombol
                ElevatedButton(
                  onPressed: _isConnected
                      ? () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => History()),
                          );
                        }
                      : null, // Nonaktifkan tombol jika tidak ada koneksi
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFFE7F20),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 60, vertical: 10),
                  ),
                  child: Text(
                    "Get Started",
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Color(0xffffffff),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
// Terhubung ke Internet
// Tidak Ada Koneksi Internet
// ndkVersion = flutter.ndkVersion