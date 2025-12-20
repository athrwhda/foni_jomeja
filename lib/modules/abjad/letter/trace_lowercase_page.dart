//import 'dart:math';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive/hive.dart';
import 'package:foni_jomeja/core/audio/tap_sound.dart';
import 'package:foni_jomeja/core/rewards/success_dialog.dart';
import 'package:foni_jomeja/core/rewards/star_overlay.dart';
import 'package:foni_jomeja/modules/abjad/abjadhome.dart';
import 'package:foni_jomeja/home/home_page.dart';
import 'package:foni_jomeja/modules/abjad/letter/introduce_letter_page.dart';

enum TracePhase { intro, tracing, complete }

class TraceLowercasePage extends StatefulWidget {
  final String letter;
  final int stage; // 1,2,3
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

class _TraceLowercasePageState extends State<TraceLowercasePage>
    with TickerProviderStateMixin {
  static const double boxSize = 320;

  int strokeIndex = 0;
  bool isCompleted = false;

  TracePhase _phase = TracePhase.intro;

  List<Offset> currentStroke = [];
  List<List<Offset>> finishedStrokes = [];

  bool get isStage1 => widget.stage == 1;
  bool get isStage2 => widget.stage == 2;
  bool get isStage3 => widget.stage == 3;

  // 🎨 consistent color per letter
  late final Color letterColor;

  // 🎬 animations
  late AnimationController _popCtrl;
  late AnimationController _bounceCtrl;
  late Animation<double> _bounceAnim;

  // =========================
  // STROKES FOR lowercase a
  // =========================
  final List<_StrokeRule> strokes = [
    // circle
    _StrokeRule(
      start: Offset(160, 140),
      end: Offset(160, 140),
      isCircle: true,
    ),
    // stem
    _StrokeRule(
      start: Offset(205, 90),
      end: Offset(205, 260),
    ),
  ];

  @override
  void initState() {
    super.initState();

    const colors = [
      Color(0xFFFFC107),
      Color(0xFF4CAF50),
      Color(0xFF2196F3),
      Color(0xFFF44336),
    ];
    letterColor = colors[widget.letter.codeUnitAt(0) % colors.length];

    _bounceCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _bounceAnim = Tween(begin: 0.9, end: 1.1).animate(
      CurvedAnimation(parent: _bounceCtrl, curve: Curves.easeInOut),
    );

    if (isStage1) {
      Future.delayed(const Duration(seconds: 2), () {
        if (!mounted) return;
        setState(() => _phase = TracePhase.tracing);
      });
    } else {
      _phase = TracePhase.tracing;
    }
  }

  @override
  void dispose() {
    _popCtrl.dispose();
    _bounceCtrl.dispose();
    super.dispose();
  }

  // =========================
  // GEOMETRY
  // =========================
  double _distance(Offset a, Offset b) => (a - b).distance;

  bool _validateAndAddPoint(Offset p) {
    final rule = strokes[strokeIndex];

    if (rule.isCircle) {
      if (currentStroke.isEmpty &&
          _distance(p, rule.start) > 40) return false;

      currentStroke.add(p);
      return true;
    }

    if (currentStroke.isEmpty &&
        _distance(p, rule.start) > 35) return false;

    currentStroke.add(p);
    return true;
  }

  void _endStroke() {
    if (currentStroke.length > 12) {
      finishedStrokes.add(List.from(currentStroke));
      strokeIndex++;

      if (strokeIndex >= strokes.length) {
        isCompleted = true;
        _phase = TracePhase.complete;

        _bounceCtrl.repeat(reverse: true);

        Future.delayed(const Duration(seconds: 3), () {
          if (!mounted) return;
          _bounceCtrl.stop();

          if (widget.stage < 3) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (_) => TraceLowercasePage(
                  letter: widget.letter,
                  stage: widget.stage + 1,
                  expectedStrokes: widget.expectedStrokes,
                ),
              ),
            );
          } else {
            _showSuccess();
          }
        });
      }
    }

    currentStroke.clear();
    setState(() {});
  }

  // =========================
  // SUCCESS (UNCHANGED)
  // =========================
  void _showSuccess() {
    final scoreBox = Hive.box('scores');
    scoreBox.put('stars', scoreBox.get('stars', defaultValue: 0) + 1);

    final progressBox = Hive.box('progress');
    final unlockedIndex =
        progressBox.get('abjad_unlocked_index', defaultValue: 0);

    final letterIndex =
        widget.letter.codeUnitAt(0) - 'A'.codeUnitAt(0);

    if (letterIndex == unlockedIndex) {
      progressBox.put('abjad_unlocked_index', unlockedIndex + 1);
    }

    final overlay = Overlay.of(context);
    final starOverlay = createStarOverlay(context);
    overlay.insert(starOverlay);

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => SuccessDialog(
        onAgain: () {
          starOverlay.remove();
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
              builder: (_) => IntroduceLetterPage(letter: widget.letter),
            ),
            (route) => false,
          );
        },
        onNext: () {
          starOverlay.remove();
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (_) => const AbjadHomePage()),
            (route) => false,
          );
        },
        onHome: () {
          starOverlay.remove();
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (_) => const HomePage()),
            (route) => false,
          );
        },
      ),
    );
  }

  // ========================= UI =========================

  @override
  Widget build(BuildContext context) {
    final stars = Hive.box('scores').get('stars', defaultValue: 0);

    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset("assets/images/bg/bg3.png", fit: BoxFit.cover),
          ),
          SafeArea(
            child: Column(
              children: [
                _buildTopBar(stars),
                const SizedBox(height: 20),
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
                const SizedBox(height: 12),
                Expanded(child: _buildCard()),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTopBar(int stars) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          GestureDetector(
            onTap: () {
              TapSound.play();
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (_) => const AbjadHomePage()),
                (route) => false,
              );
            },
            child: Image.asset("assets/images/button/hamburger.png", height: 46),
          ),
          const Spacer(),
          Stack(
            alignment: Alignment.centerLeft,
            children: [
              Image.asset("assets/images/button/star_container.png", height: 56),
              Positioned(
                right: 43,
                top: 8,
                child: Text(
                  "$stars",
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

  Widget _buildCard() {
    return Center(
      child: Container(
        width: boxSize,
        height: boxSize,
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
        child: GestureDetector(
          onPanUpdate: _phase == TracePhase.tracing && !isCompleted
              ? (d) {
                  if (_validateAndAddPoint(d.localPosition)) {
                    setState(() {});
                  }
                }
              : null,
          onPanEnd:
              _phase == TracePhase.tracing && !isCompleted ? (_) => _endStroke() : null,
          child: Stack(
            children: [
              Center(
                child: ScaleTransition(
                  scale: _phase == TracePhase.tracing
                      ? const AlwaysStoppedAnimation(1)
                      : _bounceAnim,
                  child: Text(
                    widget.letter.toLowerCase(),
                    style: GoogleFonts.baloo2(
                      fontSize: 500,
                      height: 0.5,
                      fontWeight: FontWeight.w900,
                      color: Colors.grey.shade300,
                    ),
                  ),
                ),
              ),
              CustomPaint(
                size: const Size(boxSize, boxSize),
                painter: _StrokePainter(finishedStrokes, currentStroke, letterColor),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// =========================
// MODELS & PAINTER
// =========================

class _StrokeRule {
  final Offset start;
  final Offset end;
  final bool isCircle;

  const _StrokeRule({
    required this.start,
    required this.end,
    this.isCircle = false,
  });
}

class _StrokePainter extends CustomPainter {
  final List<List<Offset>> strokes;
  final List<Offset> current;
  final Color color;

  _StrokePainter(this.strokes, this.current, this.color);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 8
      ..strokeCap = StrokeCap.round;

    for (final s in strokes) {
      for (int i = 0; i < s.length - 1; i++) {
        canvas.drawLine(s[i], s[i + 1], paint);
      }
    }

    for (int i = 0; i < current.length - 1; i++) {
      canvas.drawLine(current[i], current[i + 1], paint);
    }
  }

  @override
  bool shouldRepaint(_) => true;
}
