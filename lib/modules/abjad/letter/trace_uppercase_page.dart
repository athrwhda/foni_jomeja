import 'dart:math';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive/hive.dart';
import 'package:foni_jomeja/core/audio/tap_sound.dart';
import 'package:foni_jomeja/home/home_page.dart';
import 'package:foni_jomeja/modules/abjad/letter/trace_lowercase_page.dart';

enum TracePhase { intro, tracing, complete }

class TraceUppercasePage extends StatefulWidget {
  final String letter;
  final int stage; // 1, 2, 3

  const TraceUppercasePage({
    super.key,
    required this.letter,
    required this.stage,
  });

  @override
  State<TraceUppercasePage> createState() => _TraceUppercasePageState();
}

class _TraceUppercasePageState extends State<TraceUppercasePage>
    with TickerProviderStateMixin {
  static const double boxSize = 320;

  int strokeIndex = 0;
  bool isCompleted = false;

  TracePhase _phase = TracePhase.intro;

  bool get isStage1 => widget.stage == 1;
  bool get isStage2 => widget.stage == 2;
  bool get isStage3 => widget.stage == 3;

  List<Offset> currentStroke = [];
  List<List<Offset>> finishedStrokes = [];

  // 🎨 LETTER COLOR
  late final Color letterColor;

  // 🎬 ANIMATIONS
  late AnimationController _popCtrl;
  late Animation<double> _popAnim;

  late AnimationController _bounceCtrl;
  late Animation<double> _bounceAnim;

  // =========================
  // STROKES FOR LETTER A
  // =========================
  final List<_StrokeRule> strokes = const [
    _StrokeRule(start: Offset(165, 45), end: Offset(73, 265)),
    _StrokeRule(start: Offset(165, 45), end: Offset(255, 265)),
    _StrokeRule(start: Offset(105, 200), end: Offset(225, 200)),
  ];

  @override
  void initState() {
    super.initState();

    const colors = [
      Color(0xFFFFC107), // yellow
      Color(0xFF4CAF50), // green
      Color(0xFF2196F3), // blue
      Color(0xFFF44336), // red
    ];
    letterColor = colors[widget.letter.codeUnitAt(0) % colors.length];

    // INTRO POP
    _popCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _popAnim = Tween(begin: 0.0, end: 1.1).animate(
      CurvedAnimation(parent: _popCtrl, curve: Curves.easeOutBack),
    );
    _popCtrl.forward();

    // COMPLETE BOUNCE
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
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        setState(() => _phase = TracePhase.tracing);
      });
    }
  }

  @override
  void dispose() {
    _popCtrl.dispose();
    _bounceCtrl.dispose();
    super.dispose();
  }

  // =========================
  // COLOR HELPERS
  // =========================
  Color _lighten(Color c) {
    final hsl = HSLColor.fromColor(c);
    return hsl.withLightness((hsl.lightness + 0.35).clamp(0, 1)).toColor();
  }

  Color _darken(Color c) {
    final hsl = HSLColor.fromColor(c);
    return hsl.withLightness((hsl.lightness - 0.35).clamp(0, 1)).toColor();
  }

  // =========================
  // GEOMETRY
  // =========================
  double _distanceToLine(Offset p, Offset a, Offset b) {
    final num = ((b.dy - a.dy) * p.dx -
            (b.dx - a.dx) * p.dy +
            b.dx * a.dy -
            b.dy * a.dx)
        .abs();
    return num / (b - a).distance;
  }

  double _progressOnLine(Offset p, Offset a, Offset b) {
    final ap = p - a;
    final ab = b - a;
    final t =
        (ap.dx * ab.dx + ap.dy * ab.dy) / (ab.dx * ab.dx + ab.dy * ab.dy);
    return t.clamp(0.0, 1.0);
  }

  // =========================
  // VALIDATION
  // =========================
  bool _validateAndAddPoint(Offset p) {
    final rule = strokes[strokeIndex];

    if (currentStroke.isEmpty && (p - rule.start).distance > 35) return false;
    if (_distanceToLine(p, rule.start, rule.end) > 30) return false;

    final t = _progressOnLine(p, rule.start, rule.end);

    if (currentStroke.isNotEmpty) {
      final lastT =
          _progressOnLine(currentStroke.last, rule.start, rule.end);
      if (t < lastT) return false;
    }

    currentStroke.add(
      Offset(
        rule.start.dx + (rule.end.dx - rule.start.dx) * t,
        rule.start.dy + (rule.end.dy - rule.start.dy) * t,
      ),
    );
    return true;
  }

  void _endStroke() {
    final rule = strokes[strokeIndex];
    final last = currentStroke.isNotEmpty ? currentStroke.last : null;

    if (last != null &&
        (last - rule.end).distance < 40 &&
        currentStroke.length > 12) {
      finishedStrokes.add(List.from(currentStroke));
      strokeIndex++;

      if (strokeIndex >= strokes.length) {
        isCompleted = true;
        setState(() => _phase = TracePhase.complete);

        _bounceCtrl.repeat(reverse: true);
        Future.delayed(const Duration(seconds: 3), () {
          if (!mounted) return;
          _bounceCtrl.stop();

          if (widget.stage < 3) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (_) => TraceUppercasePage(
                  letter: widget.letter,
                  stage: widget.stage + 1,
                ),
              ),
            );
          }
          else {
            // ✅ AFTER STAGE 3 → LOWERCASE
            Navigator.pushReplacement(
            context,
              MaterialPageRoute(
                  builder: (_) => TraceLowercasePage(
                    letter: widget.letter,
                    stage: 1,
                    expectedStrokes: strokes.length,
                  ),
                ),
              );
            }
         });
      }
    }

    currentStroke.clear();
    setState(() {});
  }

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
                const SizedBox(height: 8),
                _buildTitle(),
                _buildProgress(),
                const SizedBox(height: 16),
                Expanded(child: _buildCard()),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ========================= UI =========================

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
                MaterialPageRoute(builder: (_) => const HomePage()),
                (route) => false,
              );
            },
            child: Image.asset("assets/images/button/home.png", height: 46),
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

  Widget _buildTitle() => Text(
        "Jejak Huruf Besar",
        style: GoogleFonts.baloo2(
          fontSize: 40,
          fontWeight: FontWeight.w800,
          color: const Color(0xFF6B3A00),
        ),
      );

  Widget _buildProgress() => Text(
        "Garisan ${min(strokeIndex + 1, 3)}/3",
        style: GoogleFonts.baloo2(fontSize: 25, color: Colors.brown),
      );

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
          onPanUpdate:
              _phase == TracePhase.tracing && !isCompleted
                  ? (d) {
                      if (_validateAndAddPoint(d.localPosition)) {
                        setState(() {});
                      }
                    }
                  : null,
          onPanEnd:
              _phase == TracePhase.tracing && !isCompleted
                  ? (_) => _endStroke()
                  : null,
          child: Stack(
            children: [
              _buildLetter(),

              if (isStage1 &&
                  _phase == TracePhase.tracing &&
                  currentStroke.isEmpty)
                StrokeHandGuide(
                  start: strokes[strokeIndex].start,
                  end: strokes[strokeIndex].end,
                  size: boxSize,
                  color: letterColor,
                ),

              if (isStage2 &&
                  _phase == TracePhase.tracing &&
                  !isCompleted)
                CustomPaint(
                  size: const Size(boxSize, boxSize),
                  painter: _GuideLinePainter(
                    strokes[strokeIndex].start,
                    strokes[strokeIndex].end,
                    letterColor,
                  ),
                ),

              if (_phase == TracePhase.tracing)
                CustomPaint(
                  size: const Size(boxSize, boxSize),
                  painter: StrokePainter(
                    finishedStrokes,
                    currentStroke,
                    letterColor,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLetter() {
    return Center(
      child: Transform.translate(
        offset: const Offset(0, 10),
        child: _phase == TracePhase.tracing
            ? Text(
                widget.letter,
                style: GoogleFonts.baloo2(
                  fontSize: 500,
                  height: 0.5,
                  fontWeight: FontWeight.w900,
                  color: Colors.grey.shade300,
                ),
              )
            : ScaleTransition(
                scale: _phase == TracePhase.intro ? _popAnim : _bounceAnim,
                child: OutlinedLetter(
                  letter: widget.letter,
                  fill: _lighten(letterColor),
                  outline: _darken(letterColor),
                ),
              ),
      ),
    );
  }
}

// ========================= MODELS & PAINTERS =========================

class _StrokeRule {
  final Offset start;
  final Offset end;
  const _StrokeRule({required this.start, required this.end});
}

class OutlinedLetter extends StatelessWidget {
  final String letter;
  final Color fill;
  final Color outline;

  const OutlinedLetter({
    super.key,
    required this.letter,
    required this.fill,
    required this.outline,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Text(
          letter,
          style: GoogleFonts.baloo2(
            fontSize: 500,
            height: 0.5,
            fontWeight: FontWeight.w900,
            foreground: Paint()
              ..style = PaintingStyle.stroke
              ..strokeWidth = 14
              ..color = outline,
          ),
        ),
        Text(
          letter,
          style: GoogleFonts.baloo2(
            fontSize: 500,
            height: 0.5,
            fontWeight: FontWeight.w900,
            color: fill,
          ),
        ),
      ],
    );
  }
}

class StrokeHandGuide extends StatefulWidget {
  final Offset start;
  final Offset end;
  final double size;
  final Color color;

  const StrokeHandGuide({
    super.key,
    required this.start,
    required this.end,
    required this.size,
    required this.color,
  });

  @override
  State<StrokeHandGuide> createState() => _StrokeHandGuideState();
}

class _StrokeHandGuideState extends State<StrokeHandGuide>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    )..repeat();
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  Offset _lerp(double t) => Offset(
        widget.start.dx + (widget.end.dx - widget.start.dx) * t,
        widget.start.dy + (widget.end.dy - widget.start.dy) * t,
      );

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _ctrl,
      builder: (_, __) {
        final p = _lerp(Curves.easeInOut.transform(_ctrl.value));
        return Stack(
          children: [
            CustomPaint(
              size: Size(widget.size, widget.size),
              painter: _GuideLinePainter(widget.start, p, widget.color),
            ),
            Positioned(
              left: p.dx - 18,
              top: p.dy - 18,
              child: Image.asset(
                "assets/images/button/foni_hi.png",
                width: 36,
              ),
            ),
          ],
        );
      },
    );
  }
}

class _GuideLinePainter extends CustomPainter {
  final Offset start;
  final Offset end;
  final Color color;

  _GuideLinePainter(this.start, this.end, this.color);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color.withOpacity(0.8)
      ..strokeWidth = 6
      ..strokeCap = StrokeCap.round;
    canvas.drawLine(start, end, paint);
  }

  @override
  bool shouldRepaint(_) => true;
}

class StrokePainter extends CustomPainter {
  final List<List<Offset>> strokes;
  final List<Offset> current;
  final Color color;

  StrokePainter(this.strokes, this.current, this.color);

  @override
  void paint(Canvas canvas, Size size) {
    final glow = Paint()
      ..color = color.withOpacity(0.25)
      ..strokeWidth = 18
      ..strokeCap = StrokeCap.round;

    final mid = Paint()
      ..color = color.withOpacity(0.6)
      ..strokeWidth = 12
      ..strokeCap = StrokeCap.round;

    final main = Paint()
      ..color = color
      ..strokeWidth = 8
      ..strokeCap = StrokeCap.round;

    void draw(List<Offset> pts) {
      for (int i = 0; i < pts.length - 1; i++) {
        canvas.drawLine(pts[i], pts[i + 1], glow);
        canvas.drawLine(pts[i], pts[i + 1], mid);
        canvas.drawLine(pts[i], pts[i + 1], main);
      }
    }

    for (final s in strokes) draw(s);
    draw(current);
  }

  @override
  bool shouldRepaint(_) => true;
}
