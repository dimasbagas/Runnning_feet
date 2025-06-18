import 'package:flutter/material.dart';
import 'package:runningfeet/pages/hisroty.dart';
import 'package:runningfeet/pages/maps.dart';
import 'package:runningfeet/pages/running.dart';

class ButtonNavigation extends StatelessWidget {
  final void Function()? onTap;
  const ButtonNavigation({super.key, this.onTap});

  final Color mainOrange = const Color(0xFFff7f27);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: mainOrange,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(40),
          bottomLeft: Radius.circular(40),
          topRight: Radius.circular(40),
          bottomRight: Radius.circular(40),
        ),
        boxShadow: [BoxShadow(color: Colors.black, blurRadius: 10)],
      ),
      height: 70,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Tombol kiri
              IconButton(
                icon: const Icon(Icons.history, size: 30, color: Colors.white),
                onPressed: () {
                  // navigasi ke riwayat
                  Navigator.push(context, 
                  MaterialPageRoute(builder: (context) => History()));
                },
                tooltip: 'Location',
              ),
              const SizedBox(width: 0),
              // Tombol kanan
              IconButton(
                icon: const Icon(Icons.location_on, size: 30, color: Colors.white),
                onPressed: () {
                  // navigasi  ke lokasi atau lainnya
                  Navigator.push(context, 
                  MaterialPageRoute(builder: (context) => Maps()));
                },
                tooltip: 'History',
              ),
            ],
          ),
          // Tombol tengah (floating button)
          Positioned(
            top: -35,
            left: MediaQuery.of(context).size.width / 2 - 35,
            child: GestureDetector(
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => Running()));
              }, 
              child: Container(
                height: 70,
                width: 70,
                decoration: BoxDecoration(
                  color: mainOrange,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black,
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Icon(
                  Icons.directions_run,
                  color: Colors.blue.shade900,
                  size: 36,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
