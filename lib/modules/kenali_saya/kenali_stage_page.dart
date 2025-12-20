import 'dart:async';
import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive/hive.dart';
import 'package:foni_jomeja/core/audio/tap_sound.dart';
import 'package:foni_jomeja/modules/kenali_saya/kenalihome.dart';
import 'package:foni_jomeja/core/rewards/success_dialog.dart';
import 'package:foni_jomeja/core/rewards/star_overlay.dart';

import 'data/kenali_letters.dart';
import 'kenali_confuse_page.dart';

/// =======================
/// 🌀 WIGGLE ON TAP (LOCAL)
/// =======================
class WiggleOnTap extends StatefulWidget {
  final Widget child;
  final VoidCallback onTap;

  const WiggleOnTap({super.key, required this.child, required this.onTap});

  @override
  State<WiggleOnTap> createState() => _WiggleOnTapState();
}

class _WiggleOnTapState extends State<WiggleOnTap>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _anim;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 260),
    );

    _anim = TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: 0, end: -6), weight: 1),
      TweenSequenceItem(tween: Tween(begin: -6, end: 6), weight: 2),
      TweenSequenceItem(tween: Tween(begin: 6, end: 0), weight: 1),
    ]).animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeOut));
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        await _ctrl.forward(from: 0);
        widget.onTap();
      },
      child: AnimatedBuilder(
        animation: _anim,
        builder: (_, child) {
          return Transform.translate(
            offset: Offset(_anim.value, 0),
            child: child,
          );
        },
        child: widget.child,
      ),
    );
  }
}

/// =======================
/// 📘 KENALI STAGE PAGE
/// =======================
class KenaliStagePage extends StatefulWidget {
  final int letterIndex;
  const KenaliStagePage({super.key, required this.letterIndex});

  @override
  State<KenaliStagePage> createState() => _KenaliStagePageState();
}

class _KenaliStagePageState extends State<KenaliStagePage> {
  late KenaliLetterData data;
  final AudioPlayer _player = AudioPlayer();

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

    _player.setAudioContext(
      AudioContext(
        android: const AudioContextAndroid(
          isSpeakerphoneOn: true,
          stayAwake: true,
          contentType: AndroidContentType.speech,
          usageType: AndroidUsageType.media,
          audioFocus: AndroidAudioFocus.gain,
        ),
      ),
    );

    data = kenaliLetters[widget.letterIndex];
    stars = Hive.box('scores').get('stars', defaultValue: 0);
    _initDrag();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _playIntroSequence();
    });
  }

  void _initDrag() {
    slots = List.filled(data.correctLetters.length, null);
    dragLetters = List.from(data.correctLetters);
    usedDragIndexes.clear();
    isChecked = false;
  }

  // =======================
  // ⭐ SCALING HELPERS
  // =======================
  double _slotBoxSize() {
    final count = data.correctLetters.length;
    if (count <= 3) return 74;
    if (count == 4) return 64;
    return 56;
  }

  double _slotFontSize() {
    final count = data.correctLetters.length;
    if (count <= 3) return 30;
    if (count == 4) return 26;
    return 22;
  }

  // =======================
  // 🔊 AUDIO
  // =======================
  String _kenaliAudio(String file) {
    return 'audio/kenali/${data.letter}/$file';
  }

  Future<void> _play(String path) async {
    await _player.stop();
    await _player.setSourceAsset(path);
    await _player.resume();
    await _player.onPlayerComplete.first;
  }

  Future<void> _playIntroSequence() async {
    await _play(_kenaliAudio('intro.mp3'));
    await _play(_kenaliAudio('part1.mp3'));
    await _play(_kenaliAudio('part2.mp3'));
    await _play(_kenaliAudio('word.mp3'));
  }

  void _reset() {
    TapSound.play();
    setState(() => _initDrag());
  }

  Future<void> _checkAnswer() async {
    final user = slots.join();
    final correct = data.correctLetters.join();

    setState(() {
      isChecked = true;
      isCorrect = user == correct;
    });

    if (isCorrect) {
      await _play(_kenaliAudio('word.mp3'));
      _showSuccessPopup();
    } else {
      await _play('audio/wrong_chime.wav');
    }
  }

  // =======================
  // 🎉 SUCCESS POPUP
  // =======================
  void _showSuccessPopup() {
    Hive.box('scores').put(
      'stars',
      Hive.box('scores').get('stars', defaultValue: 0) + 1,
    );

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
              builder: (_) =>
                  KenaliConfusePage(letterIndex: widget.letterIndex),
            ),
          );
        },
        onHome: () {
          Navigator.pop(context);
          _starOverlay?.remove();
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (_) => const KenaliHome()),
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
    final boxSize = _slotBoxSize();
    final fontSize = _slotFontSize();

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
                const SizedBox(height: 16),

                /// IMAGE + SOUND
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    WiggleOnTap(
                      onTap: () {
                        TapSound.play();
                        _playIntroSequence();
                      },
                      child: Image.asset(data.imagePath, height: 200),
                    ),
                    const SizedBox(width: 12),
                    WiggleOnTap(
                      onTap: () {
                        TapSound.play();
                        _play(_kenaliAudio('intro.mp3'));
                      },
                      child: Image.asset(
                        'assets/images/button/sound.png',
                        height: 46,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 14),

                /// 🔤 SYLLABLES (FIXED)
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    WiggleOnTap(
                      onTap: () {
                        TapSound.play();
                        _play(_kenaliAudio('part1.mp3'));
                      },
                      child: _letterBox(
                        data.syllable1,
                        color: Colors.redAccent,
                      ),
                    ),
                    const SizedBox(width: 10),
                    WiggleOnTap(
                      onTap: () {
                        TapSound.play();
                        _play(_kenaliAudio('part2.mp3'));
                      },
                      child: _letterBox(data.syllable2),
                    ),
                  ],
                ),

                const SizedBox(height: 8),

                WiggleOnTap(
                  onTap: () {
                    TapSound.play();
                    _play(_kenaliAudio('word.mp3'));
                  },
                  child: _wordBox(data.word),
                ),

                const SizedBox(height: 22),

                /// ⭐ SLOTS
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
                                width: boxSize,
                              ),
                              if (slots[i] != null)
                                Text(
                                  slots[i]!,
                                  style: GoogleFonts.baloo2(
                                    fontSize: fontSize,
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

                const SizedBox(height: 8),

                WiggleOnTap(
                  onTap: _reset,
                  child:
                      Image.asset('assets/images/ui/Semula.png', height: 50),
                ),

                const SizedBox(height: 22),

                Wrap(
                  spacing: 14,
                  children: List.generate(dragLetters.length, (i) {
                    final used = usedDragIndexes.contains(i);
                    final letter = dragLetters[i];

                    return Draggable<Map<String, dynamic>>(
                      data: {'letter': letter, 'index': i},
                      onDragStarted: () =>
                          _play('audio/audiohuruf/$letter.mp3'),
                      feedback: _dragBox(letter),
                      childWhenDragging:
                          Opacity(opacity: 0.3, child: _dragBox(letter)),
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
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (_) => const KenaliHome()),
                (route) => false,
              );
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

  Widget _letterBox(String text, {Color color = const Color(0xFF6B3A00)}) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Image.asset('assets/images/ui/letter.png', width: 115),
        Text(
          text,
          style: GoogleFonts.baloo2(
            fontSize: 36,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
      ],
    );
  }

  Widget _wordBox(String text) {
    final int n = data.highlightCount;

    return Stack(
      alignment: Alignment.center,
      children: [
        Image.asset('assets/images/ui/word.png', width: 260),
        RichText(
          text: TextSpan(
            style: GoogleFonts.baloo2(
              fontSize: 36,
              fontWeight: FontWeight.bold,
            ),
            children: [
              TextSpan(
                text: text.substring(0, n),
                style: const TextStyle(color: Colors.redAccent),
              ),
              TextSpan(
                text: text.substring(n),
                style: const TextStyle(color: Color(0xFF6B3A00)),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _dragBox(String letter) {
    final boxSize = _slotBoxSize();
    final fontSize = _slotFontSize();

    return Stack(
      alignment: Alignment.center,
      children: [
        Image.asset('assets/images/ui/Drag_box.png', width: boxSize),
        Text(
          letter,
          style: GoogleFonts.baloo2(
            fontSize: fontSize,
            fontWeight: FontWeight.bold,
            color: const Color(0xFF6B3A00),
          ),
        ),
      ],
    );
  }
}
