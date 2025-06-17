import 'package:flutter/material.dart';

class ButtonNavigation extends StatefulWidget {
  const ButtonNavigation({super.key});

  @override
  State<ButtonNavigation> createState() => _ButtonNavigationState();
}

class _ButtonNavigationState extends State<ButtonNavigation> {
  final Color mainOrange = const Color(0xFFff7f27);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: const Color(0xFF1FB69A),
      ),
      // const SizedBox(height: 60),
      extendBody: true,
      bottomNavigationBar: Container(
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
        width: 400,
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Tombol kiri
                IconButton(
                  icon: Icon(Icons.location_on, size: 30, color: Colors.white),
                  onPressed: () => {},
                  tooltip: 'Location',
                ),
                // Kosong untuk floating button berada disini
                const SizedBox(width: 0),
                // Tombol kanan
                IconButton(
                  icon: Icon(Icons.history, size: 30, color: Colors.white),
                  onPressed: () => {},
                  tooltip: 'Profile',
                ),
              ],
            ),
            // Tombol tengah floating
            Positioned(
              top: -35,
              left: MediaQuery.of(context).size.width / 2 - 35,
              child: GestureDetector(
                onTap: () => {},
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
      ),
    );
  }
}
