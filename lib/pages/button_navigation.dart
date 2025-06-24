import 'package:flutter/material.dart';
import 'package:runningfeet/pages/hisroty.dart';
import 'package:runningfeet/pages/maps.dart';
import 'package:runningfeet/pages/running.dart';

class ButtonNavigation extends StatelessWidget {
  final int lariId;

  final void Function()? onTap; // ← ini baris tambahan
  final void Function()? onHistoryTap;
  final void Function()? onLocationTap;
  // final int lariId;

  const ButtonNavigation({
    super.key,
    this.onTap,
    this.onHistoryTap,
    this.onLocationTap,
    required this.lariId,
  });

  // const ButtonNavigation({super.key, required this.lariId});

  final Color mainOrange = const Color(0xFFff7f27);

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final navigationWidth = screenWidth * 0.9;
    const double fabSize = 70.0;

    return Container(
      decoration: BoxDecoration(
        color: mainOrange,
        borderRadius: const BorderRadius.only(),
        boxShadow: [BoxShadow(color: Colors.black, blurRadius: 10)],
      ),
      height: 70,
      width: navigationWidth,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 50.0,
            ).copyWith(top: 10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                IconButton(
                  icon: const Icon(
                    Icons.history,
                    size: 30,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => History()),
                    );
                  },
                  tooltip: 'History',
                ),
                IconButton(
                  icon: const Icon(
                    Icons.location_on,
                    size: 30,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Maps(lariId: lariId),
                      ),
                    );
                  },
                  tooltip: 'Location',
                ),
              ],
            ),
          ),
          Positioned(
            top: -35,
            left: (navigationWidth / 2) - (fabSize / 4),
            child: Material(
              color: Colors.transparent,
              shape: const CircleBorder(),
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
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                child: InkWell(
                  onTap: () async {
                    await Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const Running()),
                    );
                    if (onTap != null)
                      onTap!(); // ⬅️ memicu refresh dari History
                  },
                  borderRadius: BorderRadius.circular(fabSize / 2),
                  child: Center(
                    child: Icon(
                      Icons.directions_run,
                      color: Colors.blue.shade900,
                      size: 36,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
