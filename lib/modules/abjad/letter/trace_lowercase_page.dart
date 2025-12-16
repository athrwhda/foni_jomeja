import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive/hive.dart';
import 'package:foni_jomeja/core/audio/tap_sound.dart';
import 'package:foni_jomeja/core/rewards/success_dialog.dart';
import 'package:foni_jomeja/core/rewards/star_overlay.dart';
import 'package:foni_jomeja/modules/abjad/abjadhome.dart';
import 'package:foni_jomeja/home/home_page.dart';
import 'package:foni_jomeja/modules/abjad/letter/introduce_letter_page.dart';

class TraceLowercasePage extends StatefulWidget {
  final String letter;
  final int stage;
  final int expectedStrokes;

  const TraceLowercasePage({
    super.key,
    required this.letter,
    required this.stage,
    required this.expectedStrokes,
  });

  @override
  State<TraceLowercasePage> createState() => _TraceLowercasePageState();
}

class _TraceLowercasePageState extends State<TraceLowercasePage> {
  int strokeCount = 0;
  bool _hasFinished = false;

  @override
  Widget build(BuildContext context) {
    final int stars = Hive.box('scores').get('stars', defaultValue: 0);

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // 🌿 BACKGROUND
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
                      GestureDetector(
                        onTap: () {
                          TapSound.play();
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

                // 🔤 TITLE
                Text(
                  "Jejak Huruf Kecil",
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

                // ✍️ TRACE AREA
                Expanded(
                  child: Center(
                    child: GestureDetector(
                      onPanStart: (_) {
                        if (_hasFinished) return;

                        setState(() {
                          strokeCount++;
                        });

                        if (strokeCount >= widget.expectedStrokes) {
                          _hasFinished = true;

                          Future.delayed(const Duration(milliseconds: 600), () {
                            if (!mounted) return;

                            // ⭐ ADD STAR (always allowed)
                            final scoreBox = Hive.box('scores');
                            scoreBox.put(
                              'stars',
                              scoreBox.get('stars', defaultValue: 0) + 1,
                            );

                            // 🔓 CORRECT UNLOCK LOGIC
                            final progressBox = Hive.box('progress');
                            final int unlockedIndex = progressBox.get(
                              'abjad_unlocked_index',
                              defaultValue: 0,
                            );

                            final int letterIndex =
                                widget.letter.codeUnitAt(0) -
                                'A'.codeUnitAt(0);

                            // ONLY unlock if this is the highest unlocked letter
                            if (letterIndex == unlockedIndex) {
                              progressBox.put(
                                'abjad_unlocked_index',
                                unlockedIndex + 1,
                              );
                            }

                            // ⭐ STAR OVERLAY (alive star)
                            final overlay = Overlay.of(context);
                            final starOverlay = createStarOverlay(context);
                            overlay.insert(starOverlay);

                            // 🎉 SUCCESS POPUP
                            showDialog(
                              context: context,
                              barrierDismissible: false,
                              builder: (_) => SuccessDialog(
                                onAgain: () {
                                  starOverlay.remove();
                                  Navigator.pushAndRemoveUntil(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => IntroduceLetterPage(
                                        letter: widget.letter,
                                      ),
                                    ),
                                    (route) => false,
                                  );
                                },
                                onNext: () {
                                  starOverlay.remove();
                                  Navigator.pushAndRemoveUntil(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => const AbjadHomePage(),
                                    ),
                                    (route) => false,
                                  );
                                },
                                onHome: () {
                                  starOverlay.remove();
                                  Navigator.pushAndRemoveUntil(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => const HomePage(),
                                    ),
                                    (route) => false,
                                  );
                                },
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
                            widget.letter.toLowerCase(),
                            style: GoogleFonts.baloo2(
                              fontSize: 160,
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
