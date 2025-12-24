import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive/hive.dart';

import 'package:foni_jomeja/core/audio/tap_sound.dart';
import 'package:foni_jomeja/home/home_page.dart';
import 'package:foni_jomeja/core/rewards/success_dialog.dart';
import 'package:foni_jomeja/core/rewards/star_overlay.dart';

import 'data/suku_data.dart';
import 'suku_flow2.dart';

class SukuFlow1 extends StatefulWidget {
  final SukuStage stage;
  final int stageIndex; // ✅ ADD THIS

  const SukuFlow1({
    super.key,
    required this.stage,
    required this.stageIndex, // ✅ FIXED
  });

  @override
  State<SukuFlow1> createState() => _SukuFlow1State();
}

class _SukuFlow1State extends State<SukuFlow1> {
  late final AudioPlayer _player;

  late List<String?> slots;
  late List<String> dragLetters;
  final Set<int> usedDragIndexes = {};

  bool isChecked = false;
  bool isCorrect = false;
  int stars = 0;

  OverlayEntry? _starOverlay;

  @override
  void initState() {
    super.initState();

    _player = AudioPlayer();
    stars = Hive.box('scores').get('stars', defaultValue: 0);
    _initDrag();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await _play(widget.stage.audio); // 🔊 BA on enter
    });
  }

  @override
  void dispose() {
    _player.dispose();
    super.dispose();
  }

  void _initDrag() {
    slots = List.filled(widget.stage.letters.length, null);
    dragLetters = List.from(widget.stage.letters);
    usedDragIndexes.clear();
    isChecked = false;
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

  void _reset() {
    TapSound.play();
    setState(() => _initDrag());
  }

  Future<void> _checkAnswer() async {
    final user = slots.join();
    final correct = widget.stage.display;

    setState(() {
      isChecked = true;
      isCorrect = user == correct;
    });

    if (isCorrect) {
      await _play(widget.stage.audio);
      _showSuccessPopup();
    } else {
      await _play('assets/audio/wrong_chime.wav');
      await Future.delayed(const Duration(milliseconds: 600));
      _reset();
    }
  }

  // =======================
  // 🎉 SUCCESS
  // =======================
  void _showSuccessPopup() {
    Hive.box('scores').put('stars', stars + 1);

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
          _reset();
        },
        onNext: () {
          Navigator.pop(context);
          _starOverlay?.remove();
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (_) => SukuFlow2(
                stage: widget.stage,
                stageIndex: widget.stageIndex, // ✅ NOW VALID
              ),
            ),
          );
        },
        onHome: () {
          Navigator.pop(context);
          _starOverlay?.remove();
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (_) => const HomePage()),
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
            child: Image.asset('assets/images/bg/bg4.jpeg', fit: BoxFit.cover),
          ),
          SafeArea(
            child: Column(
              children: [
                _buildTopBar(),

                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          _squareCard(widget.stage.display),
                          const SizedBox(width: 12),
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
                        ],
                      ),

                      const SizedBox(height: 28),

                      Wrap(
                        alignment: WrapAlignment.center,
                        children: List.generate(slots.length, (i) {
                          return DragTarget<Map<String, dynamic>>(
                            onAccept: (payload) {
                              setState(() {
                                slots[i] = payload['letter'];
                                usedDragIndexes.add(payload['index']);
                                if (!slots.contains(null)) _checkAnswer();
                              });
                            },
                            builder: (_, __, ___) {
                              return Padding(
                                padding: const EdgeInsets.all(6),
                                child: Stack(
                                  alignment: Alignment.center,
                                  children: [
                                    Image.asset(
                                      isChecked
                                          ? isCorrect
                                              ? 'assets/images/ui/Correct_box.png'
                                              : 'assets/images/ui/Wrong_box.png'
                                          : slots[i] == null
                                              ? 'assets/images/ui/Blank_box.png'
                                              : 'assets/images/ui/Drag_box.png',
                                      width: 74,
                                    ),
                                    if (slots[i] != null)
                                      Text(
                                        slots[i]!,
                                        style: GoogleFonts.baloo2(
                                          fontSize: 30,
                                          fontWeight: FontWeight.bold,
                                          color: const Color(0xFF6B3A00),
                                        ),
                                      ),
                                  ],
                                ),
                              );
                            },
                          );
                        }),
                      ),

                      const SizedBox(height: 12),

                      GestureDetector(
                        onTap: _reset,
                        child: Image.asset(
                          'assets/images/ui/Semula.png',
                          height: 50,
                        ),
                      ),

                      const SizedBox(height: 26),

                      Wrap(
                        spacing: 14,
                        children: List.generate(dragLetters.length, (i) {
                          final used = usedDragIndexes.contains(i);
                          final letter = dragLetters[i];

                          return Draggable<Map<String, dynamic>>(
                            data: {'letter': letter, 'index': i},
                            onDragStarted: () async {
                              await _play(
                                'assets/audio/audiohuruf/$letter.mp3',
                              );
                            },
                            feedback: _dragBox(letter),
                            childWhenDragging: Opacity(
                              opacity: 0.3,
                              child: _dragBox(letter),
                            ),
                            child: Opacity(
                              opacity: used ? 0.3 : 1,
                              child: IgnorePointer(
                                ignoring: used,
                                child: _dragBox(letter),
                              ),
                            ),
                          );
                        }),
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

  Widget _squareCard(String text) {
    return Container(
      width: 160,
      height: 160,
      decoration: BoxDecoration(
        color: const Color(0xFFFFF2B2),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.15),
            offset: const Offset(4, 6),
            blurRadius: 10,
          ),
        ],
      ),
      alignment: Alignment.center,
      child: Text(
        text,
        style: GoogleFonts.baloo2(
          fontSize: 64,
          fontWeight: FontWeight.bold,
          color: const Color(0xFF6B3A00),
        ),
      ),
    );
  }

  Widget _dragBox(String letter) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Image.asset('assets/images/ui/Drag_box.png', width: 74),
        Text(
          letter,
          style: GoogleFonts.baloo2(
            fontSize: 30,
            fontWeight: FontWeight.bold,
            color: const Color(0xFF6B3A00),
          ),
        ),
      ],
    );
  }
}
