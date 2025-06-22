import 'package:flutter/material.dart';
import 'package:runningfeet/database/database_instance.dart';
import 'dart:async';
import 'package:tracking_run_demo/database/database_instance.dart';
import 'package:location/location.dart';

class Running extends StatefulWidget {
  const Running({super.key});

  @override
  State<Running> createState() => _RunningState();
}

class _RunningState extends State<Running> {
  final DatabaseInstance _databaseInstance = DatabaseInstance.instance;
  final Location _locationService = Location();

  late int _lariId;
  Timer? _timer;
  final List<LocationData?> _Location = [];

  bool _isRunning = false;

    @override
  void initState() {
    super.initState();
    // PERBAIKAN 2: Mengakses getter tanpa tanda kurung ()
    _databaseInstance.database;
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

        // PERBAIKAN 3: Menggunakan nama method yang benar
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
      appBar: AppBar(title: Text("Mulai Berlari")),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsetsGeometry.all(16.0),
          child: Column(

            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                "Selamat Berlari 🏃‍♂️",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 30,),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.redAccent,
                  padding: EdgeInsets.symmetric(vertical: 15),
                  textStyle: TextStyle(fontSize: 20),
                ),
                onPressed: () {
                  if (_isRunning) {
                    _stopRunning();
                  } else {
                    _startRunning();
                  }
                },
                child: Text(_isRunning ? "Berhenti Berlari" : "Mulai Berlari"),
              ),
              SizedBox(height: 30),
              Text("Riwayat Titik Lokasi",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),),
              Divider(),
              Expanded(
                child: ListView.builder(
                  itemBuilder: (context, index) {
                    final locationPoint = _Location[index];
                    if (locationPoint == null) {
                      return const ListTile(title: Text("Lokasi tidak valid"));
                    }
                return: Card(
                  elevation: 2,
                  margin: EdgeInsets.symmetric(vertical: 4),
                  child: ListTile(
                    leading: CircleAvatar(
                      child: Text((index = 1.toString())),
                    ),
                    title: Text(
                      "lat: $locationPoint.latitude?.toStringAsFixed(6), "),
                    subtitle: Text(
                      "Lot: $locationPoint.longitude?.toStringAsFixed(6)"),
                  ),
                );
                  }
                  ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
