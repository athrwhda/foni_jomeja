import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive/hive.dart';

import 'package:foni_jomeja/core/audio/tap_sound.dart';
import 'package:foni_jomeja/core/rewards/success_dialog.dart';
import 'package:foni_jomeja/core/rewards/star_overlay.dart';

import 'data/suku_data.dart';
import 'sukuhome.dart';

class SukuFlow3 extends StatefulWidget {
  final SukuStage stage;
  final int stageIndex;
  const SukuFlow3({
    super.key, 
    required this.stage,
    required this.stageIndex,
    });

  @override
  State<SukuFlow3> createState() => _SukuFlow3State();
}

class _SukuFlow3State extends State<SukuFlow3>
    with SingleTickerProviderStateMixin {
  final AudioPlayer _player = AudioPlayer();

  int attemptCount = 0;
  late int requiredAttempts;

  bool isListening = false;
  int stars = 0;

  OverlayEntry? _starOverlay;

  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();

    stars = Hive.box('scores').get('stars', defaultValue: 0);
    requiredAttempts = Random().nextInt(3) + 1; // Set the number of required attempts for success

    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..repeat(reverse: true);

    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.12).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await _play(widget.stage.audio); // 🔊 BA.mp3 on enter
    });
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _player.dispose();
    super.dispose();
  }

  // =======================
  // 🔊 AUDIO
  // =======================
  Future<void> _play(String assetPath) async {
    await _player.stop();
    await _player.play(
      AssetSource(assetPath.replaceFirst('assets/', '')),
    );
  }

  // =======================
  // 🎤 FAKE LISTENING
  // =======================
 Future<void> _onSayPressed() async {
  if (isListening) return;

  TapSound.play();

  setState(() => isListening = true);

  // 🎤 Simulated listening
  await _play(widget.stage.audio);

  await Future.delayed(const Duration(seconds: 3));

  setState(() => isListening = false);
  attemptCount++;

  // 🎯 RANDOMIZED VALIDATION
  final bool isCorrect = attemptCount >= requiredAttempts;

  if (isCorrect) {
    _showSuccessPopup();
  } else {
    await _play('assets/audio/wrong_chime.wav');

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Cuba lagi 😊',
          style: GoogleFonts.baloo2(fontSize: 18),
        ),
        duration: const Duration(seconds: 1),
        backgroundColor: Colors.orange,
      ),
    );
  }
}


  // =======================
  // 🎉 SUCCESS
  // =======================
  void _showSuccessPopup() {
    // ⭐ add star
    Hive.box('scores').put('stars', stars + 1);

    // 🔓 unlock next stage
    final progressBox = Hive.box('progress');
final unlockedIndex =
    progressBox.get('suku_unlocked_index', defaultValue: 0);

// 🔒 ONLY unlock if finishing CURRENT unlocked stage
if (widget.stageIndex == unlockedIndex) {
  progressBox.put('suku_unlocked_index', unlockedIndex + 1);
}

    _starOverlay = createStarOverlay(context);
    Overlay.of(context).insert(_starOverlay!);

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => SuccessDialog(
        rewardStars: 1,
        onAgain: () {
          Navigator.pop(context);
          _starOverlay?.remove();

          attemptCount = 0;
          requiredAttempts = Random().nextInt(3) + 1;
        },
        
        onNext: () {
          Navigator.pop(context);
          _starOverlay?.remove();
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (_) => const SukuHome()),
            (route) => false,
          );
        },
        onHome: () {
          Navigator.pop(context);
          _starOverlay?.remove();
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (_) => const SukuHome()),
            (route) => false,
          );
        },
      ),
    );
  }

  // =======================
  // 🖥️ UI
  // =======================
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'assets/images/bg/bg4.jpeg',
              fit: BoxFit.cover,
            ),
          ),
          SafeArea(
            child: Column(
              children: [
                _buildTopBar(),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Sebutkan',
                        style: GoogleFonts.baloo2(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFF6B3A00),
                        ),
                      ),

                      const SizedBox(height: 20),

                      _bigCard(widget.stage.display),

                      const SizedBox(height: 32),

                      ScaleTransition(
                        scale: _pulseAnimation,
                        child: GestureDetector(
                          onTap: _onSayPressed,
                          child: Image.asset(
                            isListening
                                ? 'assets/images/button/mic_active.png'
                                : 'assets/images/button/mic.png',
                            height: 90,
                          ),
                        ),
                      ),

                      const SizedBox(height: 12),

                      Text(
                        isListening
                            ? 'Mendengar...'
                            : 'Tekan dan sebut',
                        style: GoogleFonts.baloo2(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFF6B3A00),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // =======================
  // 🔧 HELPERS
  // =======================
  Widget _buildTopBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          GestureDetector(
            onTap: () {
              TapSound.play();
              Navigator.pop(context);
            },
            child: Image.asset(
              'assets/images/button/hamburger.png',
              height: 46,
            ),
          ),
          const Spacer(),
          Stack(
            alignment: Alignment.centerLeft,
            children: [
              Image.asset(
                'assets/images/button/star_container.png',
                height: 56,
              ),
              Positioned(
                right: 43,
                top: 8,
                child: Text(
                  '$stars',
                  style: GoogleFonts.baloo2(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _bigCard(String text) {
    return Container(
      width: 200,
      height: 200,
      decoration: BoxDecoration(
        color: const Color(0xFFFFF2CC),
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.15),
            offset: const Offset(6, 8),
            blurRadius: 14,
          ),
          BoxShadow(
            color: Colors.white.withOpacity(0.7),
            offset: const Offset(-4, -4),
            blurRadius: 10,
          ),
        ],
      ),
      alignment: Alignment.center,
      child: Text(
        text,
        style: GoogleFonts.baloo2(
          fontSize: 72,
          fontWeight: FontWeight.bold,
          color: const Color(0xFF6B3A00),
        ),
      ),
    );
  }
}
