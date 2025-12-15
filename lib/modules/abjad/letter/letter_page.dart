//test je
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:foni_jomeja/core/audio/tap_sound.dart';
import 'package:hive/hive.dart';
import 'introduce_letter_page.dart';


class LetterPage extends StatelessWidget {
  final String letter;

  const LetterPage({
    super.key,
    required this.letter,
  });

  @override
  Widget build(BuildContext context) {
    final int stars = Hive.box('scores').get('stars', defaultValue: 0);
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // 🌿 Background
          Positioned.fill(
            child: Image.asset(
              "assets/images/bg/bg3.png",
              fit: BoxFit.cover,
            ),
          ),

          SafeArea(
            child: Column(
              children: [
                // 🔝 TOP BAR
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Row(
                    children: [
                    // ⬅️ BACK
                    GestureDetector(
                     onTap: () {
                       TapSound.play();
                       Navigator.pop(context);
             },
              child: Image.asset(
              "assets/images/button/return.png",
              height: 46,
           ),
         ),

        const Spacer(),

        // ⭐ STAR CONTAINER
        Stack(
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
      ],
    ),
  ),


          const SizedBox(height: 80),

          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => IntroduceLetterPage(letter: letter),
                ),
              );
            },
            child: Text(
              "Mulakan Huruf $letter",
              style: GoogleFonts.baloo2(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    ),
        ],
      ),
    );
  }
}