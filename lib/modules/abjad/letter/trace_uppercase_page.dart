import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive/hive.dart';
import 'package:foni_jomeja/core/audio/tap_sound.dart';
import 'trace_lowercase_page.dart';


class TraceUppercasePage extends StatefulWidget {
  final String letter;
  final int stage;
  final int expectedStrokes;

  const TraceUppercasePage({
    super.key,
    required this.letter,
    required this.stage,
    required this.expectedStrokes,
  });

  @override
  State<TraceUppercasePage> createState() => _TraceUppercasePageState();
}

class _TraceUppercasePageState extends State<TraceUppercasePage> {
  int strokeCount = 0;
  bool _hasNavigated = false; // ✅ guard for auto-next

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
                // 🔝 TOP BAR (BACK + STAR)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Row(
                    children: [
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

                const SizedBox(height: 20),

                // 🅰️ TITLE
                Text(
                  "Jejak Huruf Besar",
                  style: GoogleFonts.baloo2(
                    fontSize: 28,
                    fontWeight: FontWeight.w800,
                    color: const Color(0xFF6B3A00),
                  ),
                ),

                Text(
                  "Tahap ${widget.stage}",
                  style: GoogleFonts.baloo2(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: Colors.brown,
                  ),
                ),

                const SizedBox(height: 6),

                Text(
                  "Garisan: $strokeCount / ${widget.expectedStrokes}",
                  style: GoogleFonts.baloo2(
                    fontSize: 18,
                    color: Colors.brown,
                  ),
                ),

                const SizedBox(height: 12),

                // 🅰️ TRACE AREA
                Expanded(
                  child: Center(
                    child: GestureDetector(
                      onPanStart: (_) {
                        if (_hasNavigated) return;

                        setState(() {
                          strokeCount++;
                        });

                        // ✅ AUTO NEXT when enough strokes
                        if (strokeCount >= widget.expectedStrokes) {
                          _hasNavigated = true;

                          // 🎉 short delay for success feeling
                          Future.delayed(const Duration(milliseconds: 800), () {
                            if (!mounted) return;

                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) =>  TraceLowercasePage(
                                  letter: widget.letter,
                                  stage: widget.stage,
                                  expectedStrokes: widget.expectedStrokes, // Placeholder value
                                ), // 🔜 next: lowercase
                              ),
                            );
                          });
                        }
                      },
                      child: Container(
                        width: 260,
                        height: 260,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(28),
                          boxShadow: const [
                            BoxShadow(
                              color: Color(0xFF9ED8F3),
                              offset: Offset(6, 6),
                              blurRadius: 12,
                            ),
                          ],
                        ),
                        child: Center(
                          child: Text(
                            widget.letter,
                            style: GoogleFonts.baloo2(
                              fontSize: 180,
                              fontWeight: FontWeight.w900,
                              color: Colors.grey.shade300,
                            ),
                          ),
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
