import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive/hive.dart';

OverlayEntry createStarOverlay(BuildContext context) {
  final stars = Hive.box('scores').get('stars', defaultValue: 0);

  return OverlayEntry(
    builder: (_) => Positioned(
      top: MediaQuery.of(context).padding.top + 8,
      right: 16,
      child: IgnorePointer(
        child: Stack(
          alignment: Alignment.centerLeft,
          children: [
            Image.asset(
              "assets/images/button/star_container.png",
              height: 56,
            ),
            Positioned(
              right: 43,
              top: 8,
              child: Text(
                "$stars",
                style: GoogleFonts.baloo2(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}
