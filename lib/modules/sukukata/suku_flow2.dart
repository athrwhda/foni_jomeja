import 'dart:math';
import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive/hive.dart';

import 'package:foni_jomeja/core/audio/tap_sound.dart';
import 'package:foni_jomeja/core/rewards/success_dialog.dart';
import 'package:foni_jomeja/core/rewards/star_overlay.dart';

import 'data/suku_data.dart';
import 'suku_flow3.dart';

class SukuFlow2 extends StatefulWidget {
  final SukuStage stage;
  final int stageIndex; // ✅ ADD THIS

  const SukuFlow2({
    super.key,
    required this.stage,
    required this.stageIndex, // ✅ KEEP
  });

  @override
  State<SukuFlow2> createState() => _SukuFlow2State();
}

class _SukuFlow2State extends State<SukuFlow2>
    with TickerProviderStateMixin {
  late final AudioPlayer _player;
  final Random _random = Random();

  late List<String> options;
  int correctCount = 0;
  int stars = 0;

  bool _playedPromptOnce = false;

  OverlayEntry? _starOverlay;

  late AnimationController _wiggleController;
  late Animation<double> _wiggleAnimation;
  int? _wiggleIndex;

  final List<AnimationController> _popControllers = [];

  final List<Color> clayColors = const [
    Color(0xFFFFE082),
    Color(0xFFB3E5FC),
    Color(0xFFC8E6C9),
    Color(0xFFFFCDD2),
    Color(0xFFD1C4E9),
    Color(0xFFFFE0B2),
  ];

  @override
  void initState() {
    super.initState();

    _player = AudioPlayer();
    stars = Hive.box('scores').get('stars', defaultValue: 0);

    _wiggleController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );

    _wiggleAnimation = TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: 0, end: -8), weight: 1),
      TweenSequenceItem(tween: Tween(begin: -8, end: 8), weight: 2),
      TweenSequenceItem(tween: Tween(begin: 8, end: 0), weight: 1),
    ]).animate(
      CurvedAnimation(parent: _wiggleController, curve: Curves.easeOut),
    );

    _resetAndPrepareOptions();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (!_playedPromptOnce) {
        await _play(widget.stage.promptAudio);
        _playedPromptOnce = true;
      }
      _playPopIn();
    });
  }

  @override
  void dispose() {
    for (final c in _popControllers) {
      c.dispose();
    }
    _wiggleController.dispose();
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
  // 🔁 OPTIONS RESET
  // =======================
  void _resetAndPrepareOptions() {
    options = List.from(widget.stage.options);
    options.shuffle(_random);

    _wiggleIndex = null;

    for (final c in _popControllers) {
      c.dispose();
    }
    _popControllers.clear();

    for (int i = 0; i < options.length; i++) {
      _popControllers.add(
        AnimationController(
          vsync: this,
          duration: const Duration(milliseconds: 380),
        ),
      );
    }
  }

  Future<void> _playPopIn() async {
    for (int i = 0; i < _popControllers.length; i++) {
      await Future.delayed(Duration(milliseconds: 120 * i));
      _popControllers[i].forward(from: 0);
    }
  }

  // =======================
  // 👆 TAP OPTION
  // =======================
  Future<void> _onTapOption(String value, int index) async {
    TapSound.play();

    if (value == widget.stage.display) {
      setState(() => correctCount++);

      await _play(widget.stage.audio);

      if (correctCount >= 3) {
        _showSuccessPopup();
      } else {
        setState(() => _resetAndPrepareOptions());
        await Future.delayed(const Duration(milliseconds: 200));
        _playPopIn();
      }
    } else {
      setState(() => _wiggleIndex = index);
      _wiggleController.forward(from: 0);
      await _play('assets/audio/wrong_chime.wav');
    }
  }

  // =======================
  // 🎉 SUCCESS
  // =======================
  void _showSuccessPopup() {
    _starOverlay = createStarOverlay(context);
    Overlay.of(context).insert(_starOverlay!);

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => SuccessDialog(
        rewardStars: 0,
        onAgain: () {
          Navigator.pop(context);
          _starOverlay?.remove();
          setState(() {
            correctCount = 0;
            _resetAndPrepareOptions();
          });
          _playPopIn();
        },
        onNext: () {
          Navigator.pop(context);
          _starOverlay?.remove();
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (_) => SukuFlow3(
                stage: widget.stage,
                stageIndex: widget.stageIndex, // ✅ FIXED
              ),
            ),
          );
        },
        onHome: () {
          Navigator.pop(context);
          _starOverlay?.remove();
          Navigator.pop(context);
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
                      GestureDetector(
                        onTap: () async {
                          TapSound.play();
                          await _play(widget.stage.audio);
                        },
                        child: Image.asset(
                          'assets/images/button/sound.png',
                          height: 46,
                        ),
                      ),
                      const SizedBox(height: 28),
                      Wrap(
                        spacing: 16,
                        runSpacing: 16,
                        alignment: WrapAlignment.center,
                        children: List.generate(options.length, (i) {
                          final value = options[i];
                          final controller = _popControllers[i];

                          return ScaleTransition(
                            scale: CurvedAnimation(
                              parent: controller,
                              curve: Curves.elasticOut,
                            ),
                            child: AnimatedBuilder(
                              animation: _wiggleAnimation,
                              builder: (_, child) {
                                return Transform.translate(
                                  offset: Offset(
                                    _wiggleIndex == i
                                        ? _wiggleAnimation.value
                                        : 0,
                                    0,
                                  ),
                                  child: child,
                                );
                              },
                              child: GestureDetector(
                                onTap: () => _onTapOption(value, i),
                                child: _clayOption(
                                  value,
                                  clayColors[i % clayColors.length],
                                ),
                              ),
                            ),
                          );
                        }),
                      ),
                      const SizedBox(height: 24),
                      Text(
                        'Betul: $correctCount / 3',
                        style: GoogleFonts.baloo2(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
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

  Widget _clayOption(String text, Color color) {
    return Container(
      width: 140,
      height: 80,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.15),
            offset: const Offset(4, 6),
            blurRadius: 10,
          ),
          BoxShadow(
            color: Colors.white.withOpacity(0.6),
            offset: const Offset(-3, -3),
            blurRadius: 6,
          ),
        ],
      ),
      alignment: Alignment.center,
      child: Text(
        text,
        style: GoogleFonts.baloo2(
          fontSize: 36,
          fontWeight: FontWeight.bold,
          color: const Color(0xFF6B3A00),
        ),
      ),
    );
  }
}
