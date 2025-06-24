import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_maps/maps.dart';
import 'package:runningfeet/database/database_instance.dart';

class Maps extends StatefulWidget {
  final int lariId;

  const Maps({super.key, required this.lariId});

  @override
  State<Maps> createState() => _MapsState();
}

class _MapsState extends State<Maps> {
  final Color mainOrange = const Color(0xFFff7f27);
  final Color mainSage = const Color(0xFF1FB69A);

  final DatabaseInstance _databaseInstance = DatabaseInstance.instance;
  late Future<List<MapLatLng>> _routePointsFuture;
  MapLatLng? _initialFocalLocation;

  @override
  void initState() {
    super.initState();
    _routePointsFuture = _loadRoutePoints(widget.lariId);
  }

  Future<List<MapLatLng>> _loadRoutePoints(int lariId) async {
    final rawData = await _databaseInstance.getDetailLariByLariId(lariId);
    List<MapLatLng> points = [];

    for (var row in rawData) {
      final lat = row['latitude'] as double?;
      final lon = row['longitude'] as double?;
      if (lat != null && lon != null) {
        points.add(MapLatLng(lat, lon));
      }
    }

    if (points.isNotEmpty) {
      _initialFocalLocation = points.first;
    }

    return points;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Rute Lari #${widget.lariId}"),
        backgroundColor: mainSage,
        foregroundColor: Colors.white,
      ),
      body: Container(
        color: mainSage,
        child: SafeArea(
          child: FutureBuilder<List<MapLatLng>>(
            future: _routePointsFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text("Error: ${snapshot.error}"));
              } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
                final routePoints = snapshot.data!;
                final focalPoint = _initialFocalLocation ?? routePoints.first;

                return SfMaps(
                  layers: [
                    MapTileLayer(
                      initialZoomLevel: 15,
                      initialFocalLatLng: focalPoint,
                      urlTemplate:
                          "https://tile.openstreetmap.org/{z}/{x}/{y}.png",
                      initialMarkersCount:
                          routePoints.length, // Menentukan jumlah marker
                      markerBuilder: (BuildContext context, int index) {
                        final point = routePoints[index];
                        return MapMarker(
                          latitude: point.latitude,
                          longitude: point.longitude,
                          child: Icon(
                            index == 0
                                ? Icons.my_location
                                : index == routePoints.length - 1
                                ? Icons.flag_circle
                                : Icons.radio_button_checked,
                            color: index == 0 || index == routePoints.length - 1
                                ? Colors.red.shade800
                                : Colors.blue.shade600,
                            size: index == 0 || index == routePoints.length - 1
                                ? 30
                                : 15,
                          ),
                        );
                      },
                      sublayers: [
                        if (routePoints.length > 1)
                          MapPolylineLayer(
                            polylines: {
                              MapPolyline(
                                points: routePoints,
                                color: Colors.green.shade700,
                                width: 4,
                              ),
                            },
                          ),
                      ],
                    ),
                  ],
                );
              } else {
                return const Center(
                  child: Text(
                    "Tidak ada data rute.",
                    style: TextStyle(color: Colors.white),
                  ),
                );
              }
            },
          ),
        ),
      ),
    );
  }
}
