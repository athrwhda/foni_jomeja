import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:foni_jomeja/core/audio/tap_sound.dart';
import 'package:hive/hive.dart';
import 'trace_uppercase_page.dart';
import 'package:foni_jomeja/home/home_page.dart';



class IntroduceLetterPage extends StatelessWidget {
  final String letter;

  const IntroduceLetterPage({
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
              "assets/images/bg/bg4.jpeg",
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
                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const HomePage(),
                            ),
                            (route) => false,
                          );
                        },
                        child: Image.asset(
                          "assets/images/button/home.png",
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

                const SizedBox(height: 30),

                // 🅰️ LETTER DISPLAY
                Text(
                  letter,
                  style: GoogleFonts.baloo2(
                    fontSize: 120,
                    fontWeight: FontWeight.w900,
                    color: const Color(0xFF6B3A00),
                  ),
                ),

                const SizedBox(height: 8),

                Text(
                  letter.toLowerCase(),
                  style: GoogleFonts.baloo2(
                    fontSize: 80,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF6B3A00),
                  ),
                ),

                const SizedBox(height: 20),

                // 🔊 LISTEN BUTTON (placeholder)
                GestureDetector(
                  onTap: () {
                    TapSound.play();
                    // 🔜 later: play letter sound
                  },
                  child: Image.asset(
                    "assets/images/button/sound.png",
                    height: 64,
                  ),
                ),

                const Spacer(),

                // ➡️ NEXT BUTTON
                Padding(
                  padding: const EdgeInsets.only(bottom: 30),
                  child: GestureDetector(
                    onTap: () {
                      TapSound.play();
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => TraceUppercasePage(
                            letter: letter,
                            stage: 1,
                            expectedStrokes: 3, // Placeholder value
                          ),
                        ),
                      );
                      // 🔜 later: go to tracing
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 48,
                        vertical: 16,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFFBFECAC),
                        borderRadius: BorderRadius.circular(30),
                        boxShadow: const [
                          BoxShadow(
                            color: Color(0xFFA0DE85),
                            offset: Offset(4, 4),
                            blurRadius: 8,
                          ),
                        ],
                      ),
                      child: Text(
                        "Seterusnya",
                        style: GoogleFonts.baloo2(
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFF6B3A00),
                        ),
                      ),
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
