import 'dart:math';
import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive/hive.dart';
import 'package:foni_jomeja/core/audio/tap_sound.dart';

import 'data/kenali_letters.dart';
import 'kenalihome.dart';
import 'package:foni_jomeja/core/rewards/success_dialog.dart';

/// =======================
/// ⬆️⬇️ BOUNCE ON TAP
/// =======================
class BounceOnTap extends StatefulWidget {
  final Widget child;
  final VoidCallback onTap;

  const BounceOnTap({
    super.key,
    required this.child,
    required this.onTap,
  });

  @override
  State<BounceOnTap> createState() => _BounceOnTapState();
}

class _BounceOnTapState extends State<BounceOnTap>
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
      TweenSequenceItem(tween: Tween(begin: 0, end: -14), weight: 1),
      TweenSequenceItem(tween: Tween(begin: -14, end: 4), weight: 1),
      TweenSequenceItem(tween: Tween(begin: 4, end: 0), weight: 1),
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
            offset: Offset(0, _anim.value),
            child: child,
          );
        },
        child: widget.child,
      ),
    );
  }
}

/// =======================
/// 📘 KENALI CONFUSE PAGE
/// =======================
class KenaliConfusePage extends StatefulWidget {
  final int letterIndex;

  const KenaliConfusePage({super.key, required this.letterIndex});

  @override
  State<KenaliConfusePage> createState() => _KenaliConfusePageState();
}

class _KenaliConfusePageState extends State<KenaliConfusePage>
    with TickerProviderStateMixin {
  late KenaliLetterData data;
  final AudioPlayer _player = AudioPlayer();
  final Random _random = Random();

  late List<String?> slots;
  late List<String> dragLetters;
  final Set<int> usedDragIndexes = {};

  bool isChecked = false;
  bool isCorrect = false;
  int stars = 0;

  /// ❌ SHAKE (WRONG)
  late AnimationController _shakeCtrl;
  late Animation<double> _shakeAnim;

  @override
  void initState() {
    super.initState();

    data = kenaliLetters[widget.letterIndex];
    stars = Hive.box('scores').get('stars', defaultValue: 0);
    _initDrag();
    _initShake();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _playWord();
    });
  }

  void _initShake() {
    _shakeCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );

    _shakeAnim = TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: 0, end: -12), weight: 1),
      TweenSequenceItem(tween: Tween(begin: -12, end: 12), weight: 2),
      TweenSequenceItem(tween: Tween(begin: 12, end: -12), weight: 2),
      TweenSequenceItem(tween: Tween(begin: -12, end: 0), weight: 1),
    ]).animate(CurvedAnimation(parent: _shakeCtrl, curve: Curves.easeOut));
  }

  void _initDrag() {
    slots = List.filled(data.correctLetters.length, null);
    dragLetters = List.from(data.confuseLetters)..shuffle(_random);
    usedDragIndexes.clear();
    isChecked = false;
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

  Future<void> _playWord() async {
    await _play(_kenaliAudio('word.mp3'));
  }

  // =======================
  // 🧠 CHECK ANSWER
  // =======================
  Future<void> _checkAnswer() async {
    final user = slots.join();
    final correct = data.correctLetters.join();

    setState(() {
      isChecked = true;
      isCorrect = user == correct;
    });

    if (isCorrect) {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) => SuccessDialog(
          rewardStars: 1,
          onAgain: () {
            Navigator.pop(context);
            _reset();
          },
          onNext: () {
            Navigator.pop(context);
            _unlockNext();
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (_) => const KenaliHome()),
              (route) => false,
            );
          },
          onHome: () {
            Navigator.pop(context);
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (_) => const KenaliHome()),
              (route) => false,
            );
          },
        ),
      );
    } else {
      await _play('audio/wrong_chime.wav');
      _shakeCtrl.forward(from: 0);
    }
  }

  void _unlockNext() {
    final progressBox = Hive.box('progress');
    final unlocked =
        progressBox.get('kenali_unlocked_index', defaultValue: 0);

    if (widget.letterIndex >= unlocked) {
      progressBox.put('kenali_unlocked_index', widget.letterIndex + 1);
    }

    Hive.box('scores').put(
      'stars',
      Hive.box('scores').get('stars', defaultValue: 0) + 1,
    );
  }

  void _reset() {
    TapSound.play();
    setState(() => _initDrag());
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
                const SizedBox(height: 10),

                // 🔤 BIG LETTER
                Text(
                  data.letter,
                  style: GoogleFonts.baloo2(
                    fontSize: 96,
                    fontWeight: FontWeight.w900,
                    color: Colors.redAccent,
                  ),
                ),

                const SizedBox(height: 6),

                // 🐔 IMAGE + SOUND (INDEPENDENT BOUNCE)
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    BounceOnTap(
                      onTap: () {
                        TapSound.play();
                        _playWord();
                      },
                      child: Image.asset(
                        data.imagePath,
                        height: 220,
                      ),
                    ),
                    const SizedBox(width: 12),
                    BounceOnTap(
                      onTap: () {
                        TapSound.play();
                        _playWord();
                      },
                      child: Image.asset(
                        'assets/images/button/sound.png',
                        height: 48,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 22),

                // ❌ SHAKE SLOTS
                AnimatedBuilder(
                  animation: _shakeAnim,
                  builder: (_, child) {
                    return Transform.translate(
                      offset: Offset(_shakeAnim.value, 0),
                      child: child,
                    );
                  },
                  child: Wrap(
                    alignment: WrapAlignment.center,
                    children: List.generate(slots.length, (i) {
                      final filled = slots[i] != null;

                      return Padding(
                        padding: const EdgeInsets.all(6),
                        child: DragTarget<Map<String, dynamic>>(
                          onAccept: (payload) {
                            setState(() {
                              slots[i] = payload['letter'];
                              usedDragIndexes.add(payload['index']);
                              if (!slots.contains(null)) _checkAnswer();
                            });
                          },
                          builder: (_, __, ___) {
                            return Stack(
                              alignment: Alignment.center,
                              children: [
                                Image.asset(
                                  isChecked
                                      ? isCorrect
                                          ? 'assets/images/ui/Correct_box.png'
                                          : 'assets/images/ui/Wrong_box.png'
                                      : filled
                                          ? 'assets/images/ui/Drag_box.png'
                                          : 'assets/images/ui/Blank_box.png',
                                  width: 64,
                                ),
                                if (filled)
                                  Text(
                                    slots[i]!,
                                    style: GoogleFonts.baloo2(
                                      fontSize: 28,
                                      fontWeight: FontWeight.bold,
                                      color: const Color(0xFF6B3A00),
                                    ),
                                  ),
                              ],
                            );
                          },
                        ),
                      );
                    }),
                  ),
                ),

                const SizedBox(height: 10),

                // 🔄 SEMULA (OWN BOUNCE)
                BounceOnTap(
                  onTap: _reset,
                  child: Image.asset(
                    'assets/images/ui/Semula.png',
                    height: 48,
                  ),
                ),

                const SizedBox(height: 20),

                // 🔠 DRAG LETTERS
                Wrap(
                  spacing: 12,
                  runSpacing: 12,
                  children: List.generate(dragLetters.length, (i) {
                    final letter = dragLetters[i];
                    final used = usedDragIndexes.contains(i);

                    return Draggable<Map<String, dynamic>>(
                      data: {'letter': letter, 'index': i},
                      onDragStarted: () {
                        _play('audio/audiohuruf/$letter.mp3');
                      },
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

  Widget _dragBox(String letter) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Image.asset('assets/images/ui/Drag_box.png', width: 64),
        Text(
          letter,
          style: GoogleFonts.baloo2(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: const Color(0xFF6B3A00),
          ),
        ),
      ],
    );
  }
}
