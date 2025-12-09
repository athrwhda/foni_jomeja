import 'package:flutter/material.dart';

class Splash1 extends StatefulWidget {
  const Splash1({super.key});

  @override
  State<Splash1> createState() => _Splash1State();
}

class _Splash1State extends State<Splash1> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeOut;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1), // fade duration
    );

    _fadeOut = Tween<double>(begin: 1.0, end: 0.0).animate(_controller);

    // Delay before starting fade
    Future.delayed(const Duration(seconds: 1), () {
      _controller.forward(); // start fade out
    });

    // Navigate after fade completes
    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        Navigator.pushReplacementNamed(context, '/splash2');
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double imageSize = 350; // 🟢 adjust freely anytime

    return Scaffold(
      backgroundColor: const Color(0xFFF8FFE5),
      body: Center(
        child: FadeTransition(
          opacity: _fadeOut,
          child: SizedBox(
            width: imageSize,
            height: imageSize,
            child: Image.asset(
              'assets/images/splash1.png',
              fit: BoxFit.contain,
            ),
          ),
        ),
      ),
    );
  }
}
