import 'package:flutter/material.dart';
import 'package:runningfeet/database/database_instance.dart';
import 'dart:async';
import 'package:location/location.dart';

class Running extends StatefulWidget {
  const Running({super.key});

  @override
  State<Running> createState() => _RunningState();
}

class _RunningState extends State<Running> {
  final DatabaseInstance _databaseInstance = DatabaseInstance.instance;
  final Location _locationService = Location();

  final Color mainOrange = const Color(0xFFff7f27);
  final Color mainSage = const Color(0xFF1FB69A);

  late int _lariId;
  Timer? _timer;
  final List<LocationData?> _locations = [];

  bool _isRunning = false;

  @override
  void initState() {
    super.initState();
  }

  Future<LocationData?> _getCurrentLocation() async {
    bool serviceEnabled = await _locationService.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await _locationService.requestService();
      if (!serviceEnabled) {
        return null;
      }
    }

    PermissionStatus permissionGranted = await _locationService.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await _locationService.requestPermission();
      if (permissionGranted != PermissionStatus.granted) {
        return null;
      }
    }
    return await _locationService.getLocation();
  }

  void _startRunning() async {
    setState(() {
      _locations.clear();
    });

    _lariId = await _databaseInstance.insertLari({
      'mulai': DateTime.now().toIso8601String(),
    });

    setState(() {
      _isRunning = true;
    });

    _timer = Timer.periodic(const Duration(seconds: 5), (timer) async {
      final LocationData? currentLocation = await _getCurrentLocation();

      if (currentLocation != null) {
        setState(() {
          _locations.add(currentLocation);
        });

        await _databaseInstance.insertDetailLari({
          'lari_id': _lariId,
          'latitude': currentLocation.latitude,
          'longitude': currentLocation.longitude,
          'waktu': DateTime.now().toIso8601String(),
        });
      }
    });
  }

  void _stopRunning() async {
    _timer?.cancel();
    await _databaseInstance.updateLari(_lariId, {
      'selesai': DateTime.now().toIso8601String(),
    });

    setState(() {
      _isRunning = false;
    });

    if (mounted) {
      Navigator.pop(context);
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Mulai Berlari"),
        backgroundColor: mainSage,
        titleTextStyle: Theme.of(context).textTheme.titleLarge?.copyWith(
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
      body: Container(
        color: mainSage,
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  "Selamat Berlari 🏃‍♂️",
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 30),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.redAccent,
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    textStyle: const TextStyle(fontSize: 20),
                  ),
                  onPressed: () {
                    if (_isRunning) {
                      _stopRunning();
                    } else {
                      _startRunning();
                    }
                  },
                  child: Text(
                    _isRunning ? "Berhenti Berlari" : "Mulai Berlari",
                  ),
                ),
                const SizedBox(height: 30),
                const Text(
                  "Riwayat Titik Lokasi",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const Divider(),
                Expanded(
                  child: ListView.builder(
                    itemCount: _locations.length,
                    itemBuilder: (context, index) {
                      final locationPoint = _locations[index];

                      if (locationPoint == null) {
                        return const ListTile(
                          title: Text("Lokasi tidak valid"),
                        );
                      }

                      return Card(
                        elevation: 2,
                        margin: const EdgeInsets.symmetric(vertical: 4),
                        color: mainOrange,
                        child: ListTile(
                          leading: CircleAvatar(
                            child: Text((index + 1).toString()),
                          ),
                          title: Text(
                            "Lat: ${locationPoint.latitude?.toStringAsFixed(6) ?? 'N/A'}",
                            style: const TextStyle(color: Colors.white),
                          ),
                          subtitle: Text(
                            "Lon: ${locationPoint.longitude?.toStringAsFixed(6) ?? 'N/A'}",
                            style: const TextStyle(color: Colors.white),
                          ),
                        ),
                      );
                    },
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
