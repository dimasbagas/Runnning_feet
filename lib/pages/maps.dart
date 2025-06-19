import 'package:flutter/material.dart';

class Maps extends StatefulWidget {
  const Maps({super.key});

  @override
  State<Maps> createState() => _MapsState();
}

class _MapsState extends State<Maps> {
  // MapLatLng loc = const MapLatLng(-7.160477, 113.481809);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: const Text("Maps Tracking"),
      // ),
      // body: SafeArea(
      //   child: Column(
      //     children: [
      //       SizedBox(
      //         height: 300,
      //         child: SfMaps(
      //           layers: [
      //             MapTileLayer(
      //               initialZoomLevel: 15,
      //               initialFocalLatLng: loc,
      //               urlTemplate:
      //                   "https://tile.openstreetmap.org/{z}/{x}/{y}.png",
      //               initialMarkersCount: 1,
      //               markerBuilder: (BuildContext context, int index) {
      //                 return MapMarker(
      //                   latitude: loc.latitude,
      //                   longitude: loc.longitude,
      //                   child: const Icon(Icons.location_on, color: Colors.red),
      //                 );
      //               },
      //             ),
      //           ],
      //         ),
      //       ),
      //     ],
      //   ),
      // ),
    );
  }
}