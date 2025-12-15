import 'package:flutter/material.dart';
import 'package:foni_jomeja/core/audio/tap_sound.dart';

class AbjadTile extends StatefulWidget {
  final String letter;
  final bool isUnlocked;
  final VoidCallback? onTap;

  const AbjadTile({
    super.key,
    required this.letter,
    required this.isUnlocked,
    this.onTap,
  });

  @override
  State<AbjadTile> createState() => _AbjadTileState();
}

class _AbjadTileState extends State<AbjadTile>
    with SingleTickerProviderStateMixin {

  late AnimationController _controller;
  late Animation<double> _scale;
  late Animation<double> _shake;
  late Animation<double> _bounce;


  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 350),
    );

    _scale = Tween(begin: 1.0, end: 0.92).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );

    _bounce = TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: 0, end: -8), weight: 1),
      TweenSequenceItem(tween: Tween(begin: -8, end: 0), weight: 1),
      ]).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );

    _shake = TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: 0, end: -6), weight: 1),
      TweenSequenceItem(tween: Tween(begin: -6, end: 6), weight: 2),
      TweenSequenceItem(tween: Tween(begin: 6, end: -6), weight: 2),
      TweenSequenceItem(tween: Tween(begin: -6, end: 6), weight: 2),
      TweenSequenceItem(tween: Tween(begin: 6, end: 0), weight: 1),
    ]).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _handleTap() async {
  TapSound.play();

  if (!widget.isUnlocked) {
    // 🔒 LOCKED → wiggle only
    await _controller.forward(from: 0);
    _controller.reverse();
    return;
  }

  // ✅ UNLOCKED → bounce
  await _controller.forward(from: 0);
  _controller.reverse();

  widget.onTap?.call();
}


  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (_, __) {
        return Transform.translate(
          offset: widget.isUnlocked
          ? Offset(0, _bounce.value)   // ✅ bounce
           : Offset(_shake.value, 0),   // 🔒 wiggle
           child: Transform.scale(
            scale: widget.isUnlocked ? _scale.value : 1.0,
            child: GestureDetector(
              onTap: _handleTap,
              child: Opacity(
                opacity: widget.isUnlocked ? 1 : 0.35,
                child: Container(
                  decoration: BoxDecoration(
                    color: const Color(0xFFBEEBFF),
                    borderRadius: BorderRadius.circular(22),
                    boxShadow: const [
                      BoxShadow(
                        color: Color(0xFF9ED8F3),
                        offset: Offset(4, 4),
                        blurRadius: 10,
                      ),
                      BoxShadow(
                        color: Colors.white70,
                        offset: Offset(-4, -4),
                        blurRadius: 8,
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: Image.asset(
                      "assets/images/clayabjad/${widget.letter}.png",
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
