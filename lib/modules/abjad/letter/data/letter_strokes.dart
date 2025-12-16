import 'package:flutter/material.dart';

enum StrokeDir { vertical, horizontal, diagonal }

class LetterStroke {
  final Offset start;
  final Offset end;
  final StrokeDir dir;

  const LetterStroke({
    required this.start,
    required this.end,
    required this.dir,
  });
}

class LetterStrokes {
  /// Normalised to 300x300 canvas
  static const Map<String, List<LetterStroke>> uppercase = {
    "A": [
      LetterStroke(
        start: Offset(150, 30),
        end: Offset(80, 260),
        dir: StrokeDir.diagonal,
      ),
      LetterStroke(
        start: Offset(150, 30),
        end: Offset(220, 260),
        dir: StrokeDir.diagonal,
      ),
      LetterStroke(
        start: Offset(110, 170),
        end: Offset(190, 170),
        dir: StrokeDir.horizontal,
      ),
    ],
    // 🔜 B, C, D... later
  };
}
