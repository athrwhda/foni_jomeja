import 'package:flutter/material.dart';

class DrawTestPage extends StatefulWidget {
  const DrawTestPage({super.key});

  @override
  State<DrawTestPage> createState() => _DrawTestPageState();
}

class _DrawTestPageState extends State<DrawTestPage> {
  final List<List<Offset>> strokes = [];
  List<Offset> currentStroke = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFEEF2),
      appBar: AppBar(
        title: const Text("Draw Test"),
        backgroundColor: Colors.pink.shade200,
      ),
      body: Center(
        child: ClipRRect(
          borderRadius: BorderRadius.circular(28),
          child: Container(
            width: 280,
            height: 280,
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: const [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 12,
                  offset: Offset(0, 6),
                ),
              ],
            ),

            // 🔑 VERY IMPORTANT: GestureDetector wraps ONLY canvas
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,

              onPanStart: (details) {
                setState(() {
                  currentStroke = [];
                  currentStroke.add(details.localPosition);
                });
              },

              onPanUpdate: (details) {
                setState(() {
                  currentStroke.add(details.localPosition);
                });
              },

              onPanEnd: (_) {
                setState(() {
                  strokes.add(currentStroke);
                  currentStroke = [];
                });
              },

              child: CustomPaint(
                size: const Size(280, 280),
                painter: StrokePainter(
                  strokes: strokes,
                  currentStroke: currentStroke,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class StrokePainter extends CustomPainter {
  final List<List<Offset>> strokes;
  final List<Offset> currentStroke;

  StrokePainter({
    required this.strokes,
    required this.currentStroke,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.blueAccent
      ..strokeWidth = 8
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    // finished strokes
    for (final stroke in strokes) {
      for (int i = 0; i < stroke.length - 1; i++) {
        canvas.drawLine(stroke[i], stroke[i + 1], paint);
      }
    }

    // current stroke
    for (int i = 0; i < currentStroke.length - 1; i++) {
      canvas.drawLine(
        currentStroke[i],
        currentStroke[i + 1],
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant StrokePainter oldDelegate) {
    return true;
  }
}
