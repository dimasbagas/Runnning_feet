import 'package:flutter/material.dart';
import 'package:runningfeet/pages/hisroty.dart';
import 'package:runningfeet/pages/maps.dart';
import 'package:runningfeet/pages/running.dart';

class ButtonNavigation extends StatelessWidget {
  final void Function()? onTap;
  final void Function()? onHistoryTap;
  final void Function()? onLocationTap;

  const ButtonNavigation({
    super.key,
    this.onTap,
    this.onHistoryTap,
    this.onLocationTap,
  });

  final Color mainOrange = const Color(0xFFff7f27);

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final navigationWidth = screenWidth * 0.9;
    const double fabSize = 70.0;

    return Container(
      decoration: BoxDecoration(
        color: mainOrange,
        borderRadius: const BorderRadius.only(
          // topLeft: Radius.circular(40),
          // bottomLeft: Radius.circular(40),
          // topRight: Radius.circular(40),
          // bottomRight: Radius.circular(40),
        ),
        boxShadow: [BoxShadow(color: Colors.black, blurRadius: 10)],
      ),
      height: 70, 
      width: navigationWidth,

      child: Stack(
        clipBehavior: Clip.none, 
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 50.0)
            .copyWith(top: 10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center, 
              children: [
                IconButton(
                  icon: const Icon(Icons.history, size: 30, color: Colors.white),
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => History()),
                    );
                  },
                  tooltip: 'History',
                ),
                IconButton(
                  icon: const Icon(Icons.location_on, size: 30, color: Colors.white),
                  onPressed: (){
                    Navigator.push(context, MaterialPageRoute(builder: (context) => Maps()),
                    );
                  },
                  tooltip: 'Location',
                ),
              ],
            ),
          ),

          Positioned(
            top: -35, 
            left: (navigationWidth / 2) - (fabSize / 04),
            child: GestureDetector(
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => Running()),
                );
              },
              child: Container(
                height: fabSize,
                width: fabSize,
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