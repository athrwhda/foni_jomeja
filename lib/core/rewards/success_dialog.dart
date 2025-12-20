import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:foni_jomeja/core/audio/tap_sound.dart';
import 'package:audioplayers/audioplayers.dart';

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
  final AudioPlayer _player = AudioPlayer();

  @override
  void initState() {
    super.initState();
    _playWinSound();
  }

  Future<void> _playWinSound() async {
    await _player.play(
      AssetSource('audio/win_chimes.wav'),
    );
  }

  @override
  void dispose() {
    _player.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: Stack(
        clipBehavior: Clip.none,
        children: [

          /// 🧱 MAIN CARD
          Container(
            margin: const EdgeInsets.only(top: 36),
            padding: const EdgeInsets.fromLTRB(24, 56, 24, 28),
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

                const SizedBox(height: 6),

                Text(
                  "Kamu berjaya 🎉",
                  style: GoogleFonts.baloo2(
                    fontSize: 20,
                    color: Colors.brown,
                  ),
                ),

                const SizedBox(height: 18),

                /// ⭐ STAR REWARD
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      "assets/images/home/star.png",
                      height: 42,
                    ),
                    const SizedBox(width: 10),
                    Text(
                      "+${widget.rewardStars}",
                      style: GoogleFonts.baloo2(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFF6B3A00),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 28),

                /// 🔘 ACTION BUTTONS (PNG)
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _iconButton(
                      asset: "assets/images/button/return.png",
                      onTap: widget.onAgain,
                    ),
                    _iconButton(
                      asset: "assets/images/button/seterusnya.png",
                      onTap: widget.onNext,
                    ),
                    _iconButton(
                      asset: "assets/images/button/home.png",
                      onTap: widget.onHome,
                    ),
                  ],
                ),
              ],
            ),
          ),

          /// ❌ CLOSE BUTTON
          Positioned(
            top: 0,
            right: 0,
            child: GestureDetector(
              onTap: () {
                TapSound.play();
                Navigator.pop(context);
              },
              child: Image.asset(
                "assets/images/button/close.png",
                height: 42,
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// 🔘 ICON BUTTON HELPER
  Widget _iconButton({
    required String asset,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: () {
        TapSound.play();
        onTap();
      },
      child: Image.asset(asset, height: 54),
    );
  }
}
