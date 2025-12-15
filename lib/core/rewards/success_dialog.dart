import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive/hive.dart';
import 'package:foni_jomeja/core/audio/tap_sound.dart';

class SuccessDialog extends StatefulWidget {
  final int rewardStars;
  final VoidCallback onAgain;
  final VoidCallback onNext;
  final VoidCallback onHome;

  const SuccessDialog({
    super.key,
    this.rewardStars = 1,
    required this.onAgain,
    required this.onNext,
    required this.onHome,
  });

  @override
  State<SuccessDialog> createState() => _SuccessDialogState();
}

class _SuccessDialogState extends State<SuccessDialog> {
  late int _newStars;
  bool _rewardGiven = false;

  @override
  void initState() {
    super.initState();

    final box = Hive.box('scores');
    final currentStars = box.get('stars', defaultValue: 0);

    _newStars = currentStars + widget.rewardStars;

    // ⭐ IMPORTANT: add star ONLY ONCE
    if (!_rewardGiven) {
      box.put('stars', _newStars);
      _rewardGiven = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: Stack(
        clipBehavior: Clip.none,
        children: [

          // 🧱 MAIN CARD
          Container(
            margin: const EdgeInsets.only(top: 30),
            padding: const EdgeInsets.fromLTRB(20, 50, 20, 24),
            decoration: BoxDecoration(
              color: const Color(0xFFFFF7E6),
              borderRadius: BorderRadius.circular(30),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 12,
                  offset: Offset(0, 6),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "Syabas!",
                  style: GoogleFonts.baloo2(
                    fontSize: 36,
                    fontWeight: FontWeight.w900,
                    color: const Color(0xFF6B3A00),
                  ),
                ),

                const SizedBox(height: 8),

                Text(
                  "Kamu berjaya 🎉",
                  style: GoogleFonts.baloo2(
                    fontSize: 20,
                    color: Colors.brown,
                  ),
                ),

                const SizedBox(height: 16),

                // ⭐ REWARD ROW
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      "assets/images/home/star.png",
                      height: 40,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      "+${widget.rewardStars}",
                      style: GoogleFonts.baloo2(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFF6B3A00),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 24),

                // 🔘 ACTION BUTTONS
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _actionButton("Ulang", widget.onAgain),
                    _actionButton("Seterusnya", widget.onNext),
                    _actionButton("Home", widget.onHome),
                  ],
                ),
              ],
            ),
          ),

          // ❌ CLOSE BUTTON
          Positioned(
            right: -6,
            top: -6,
            child: GestureDetector(
              onTap: () {
                TapSound.play();
                Navigator.pop(context);
              },
              child: const CircleAvatar(
                radius: 18,
                backgroundColor: Colors.redAccent,
                child: Icon(Icons.close, color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _actionButton(String text, VoidCallback onTap) {
    return GestureDetector(
      onTap: () {
        TapSound.play();
        onTap();
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
        decoration: BoxDecoration(
          color: const Color(0xFFBFECAC),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          text,
          style: GoogleFonts.baloo2(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: const Color(0xFF6B3A00),
          ),
        ),
      ),
    );
  }
}
