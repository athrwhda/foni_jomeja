import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive/hive.dart';

import 'package:foni_jomeja/core/audio/tap_sound.dart';
import 'package:foni_jomeja/home/home_page.dart';

import 'data/suku_data.dart';
import 'suku_flow1.dart';

class SukuHome extends StatefulWidget {
  const SukuHome({super.key});

  @override
  State<SukuHome> createState() => _SukuHomeState();
}

class _SukuHomeState extends State<SukuHome> with TickerProviderStateMixin {
  int unlockedIndex = 0;
  int stars = 0;
  int? _lastUnlockedIndex;

  int? shakingIndex;
  int? jumpingIndex;

  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  late AnimationController _shakeController;
  late Animation<double> _shakeAnimation;

  late AnimationController _jumpController;
  late Animation<double> _jumpAnimation;

  late AnimationController _starPopController;
  late Animation<double> _starScale;
  late Animation<double> _starOpacity;

  @override
  void initState() {
    super.initState();
    _loadData();

    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat(reverse: true);

    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.08).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    _shakeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );

    _shakeAnimation = TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: 0, end: -10), weight: 1),
      TweenSequenceItem(tween: Tween(begin: -10, end: 10), weight: 2),
      TweenSequenceItem(tween: Tween(begin: 10, end: -10), weight: 2),
      TweenSequenceItem(tween: Tween(begin: -10, end: 0), weight: 1),
    ]).animate(_shakeController);

    _jumpController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 260),
    );

    _jumpAnimation = TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: 0, end: -18), weight: 1),
      TweenSequenceItem(tween: Tween(begin: -18, end: 6), weight: 1),
      TweenSequenceItem(tween: Tween(begin: 6, end: 0), weight: 1),
    ]).animate(CurvedAnimation(parent: _jumpController, curve: Curves.easeOut));

    _starPopController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );

    _starScale = Tween<double>(begin: 0.4, end: 1.2).animate(
      CurvedAnimation(parent: _starPopController, curve: Curves.elasticOut),
    );

    _starOpacity = Tween<double>(begin: 1, end: 0).animate(
      CurvedAnimation(parent: _starPopController, curve: Curves.easeOut),
    );
  }

  void _loadData() {
    final progressBox = Hive.box('progress');
    final scoreBox = Hive.box('scores');

    unlockedIndex = progressBox.get('suku_unlocked_index', defaultValue: 0);
    stars = scoreBox.get('stars', defaultValue: 0);

    _lastUnlockedIndex ??= unlockedIndex;
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _shakeController.dispose();
    _jumpController.dispose();
    _starPopController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final reversedStages = sukuStages.reversed.toList();

    final bool playStarPop = unlockedIndex > (_lastUnlockedIndex ?? 0);

    if (playStarPop) {
      _lastUnlockedIndex = unlockedIndex;
      _starPopController.forward(from: 0);
    }

    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset('assets/images/bg/bg2.png', fit: BoxFit.cover),
          ),
          SafeArea(
            child: Column(
              children: [
                _buildTopBar(),
                const SizedBox(height: 8),
                Text(
                  'Suku Kata',
                  style: GoogleFonts.baloo2(
                    fontSize: 36,
                    fontWeight: FontWeight.w800,
                    color: const Color(0xFF6B3A00),
                  ),
                ),
                const SizedBox(height: 12),

                Expanded(
                  child: SingleChildScrollView(
                    reverse: true,
                    padding: const EdgeInsets.only(top: 60, bottom: 20),
                    child: Column(
                      children: List.generate(reversedStages.length, (
                        visualIndex,
                      ) {
                        final realIndex = sukuStages.length - 1 - visualIndex;
                        final stage = sukuStages[realIndex];

                        return Column(
                          children: [
                            SizedBox(
                              height: 120,
                              width: 240,
                              child: Align(
                                alignment: Alignment(
                                  _getXAlignment(realIndex),
                                  0,
                                ),
                                child: _buildTrailNode(
                                  label: stage.display,
                                  index: realIndex,
                                ),
                              ),
                            ),

                            /// ⭐ STAR BETWEEN NODES (FIXED LOGIC)
                            if (realIndex > 0)
                              SizedBox(
                                height: 40,
                                child: Center(
                                  child: AnimatedBuilder(
                                    animation: _starPopController,
                                    builder: (_, __) {
                                      final bool isNewUnlock =
                                          realIndex == unlockedIndex &&
                                          unlockedIndex >
                                              (_lastUnlockedIndex ?? 0);

                                      return Transform.scale(
                                        scale: isNewUnlock
                                            ? _starScale.value
                                            : 1,
                                        child: Opacity(
                                          opacity: isNewUnlock
                                              ? _starOpacity.value
                                              : 1,
                                          child: _buildStarIndicator(realIndex),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ),
                          ],
                        );
                      }),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  double _getXAlignment(int index) {
    switch (index % 6) {
      case 1:
        return -0.8;
      case 2:
        return 0.8;
      case 3:
        return -0.5;
      case 4:
        return 0.5;
      default:
        return 0;
    }
  }

  /// ⭐ STAR TYPE DECIDER
  Widget _buildStarIndicator(int realIndex) {
    if (realIndex < unlockedIndex) {
      // ⭐ BIG STAR (clear → clear)
      return Image.asset('assets/images/home/star.png', height: 32);
    }

    if (realIndex == unlockedIndex) {
      // ⭐ SMALL STAR (clear → current)
      return Image.asset('assets/images/home/star.png', height: 20);
    }

    // ⭐ GREY STAR (locked → locked)
    return Image.asset('assets/images/home/greystar.png', height: 20);
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
                MaterialPageRoute(builder: (_) => const HomePage()),
                (route) => false,
              );
            },
            child: Image.asset('assets/images/button/home.png', height: 46),
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

  Widget _buildTrailNode({required String label, required int index}) {
    final bool isCurrent = index == unlockedIndex;
    final bool isLocked = index > unlockedIndex;

    Widget circle = Container(
      width: 76,
      height: 76,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(
          colors: isLocked
              ? [Colors.grey.shade300, Colors.grey.shade400]
              : isCurrent
              ? [const Color(0xFFFFF2B2), const Color(0xFFFFD966)]
              : [const Color(0xFFDCF3FF), const Color(0xFFBEEBFF)],
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.15),
            offset: const Offset(4, 6),
            blurRadius: 10,
          ),
        ],
      ),
      child: Text(
        label,
        style: GoogleFonts.baloo2(
          fontSize: 26,
          fontWeight: FontWeight.bold,
          color: isLocked ? Colors.grey : const Color(0xFF6B3A00),
        ),
      ),
    );

    if (isCurrent && jumpingIndex == null) {
      circle = ScaleTransition(scale: _pulseAnimation, child: circle);
    }

    return GestureDetector(
      onTap: () async {
        TapSound.play();

        if (isLocked) {
          setState(() => shakingIndex = index);
          _shakeController.forward(from: 0);
          return;
        }

        setState(() => jumpingIndex = index);
        await _jumpController.forward(from: 0);
        setState(() => jumpingIndex = null);

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) =>
                SukuFlow1(stage: sukuStages[index], stageIndex: index),
          ),
        );
      },
      child: AnimatedBuilder(
        animation: _shakeAnimation,
        builder: (_, child) {
          return Transform.translate(
            offset: Offset(
              isLocked && shakingIndex == index ? _shakeAnimation.value : 0,
              0,
            ),
            child: child,
          );
        },
        child: circle,
      ),
    );
  }
}
