import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive/hive.dart';
import 'package:foni_jomeja/core/audio/tap_sound.dart';
import 'package:foni_jomeja/home/home_page.dart';
import 'kenali_stage_page.dart';


class KenaliHome extends StatefulWidget {
  const KenaliHome({super.key});

  @override
  State<KenaliHome> createState() => _KenaliHomeState();
}

class _KenaliHomeState extends State<KenaliHome>
    with TickerProviderStateMixin {
  int unlockedIndex = 0;
  int stars = 0;
  int? _lastUnlockedIndex;

  int? shakingIndex;
  int? jumpingIndex;

  final List<String> letters =
      List.generate(26, (i) => String.fromCharCode(65 + i));

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
    ]).animate(
      CurvedAnimation(parent: _jumpController, curve: Curves.easeOut),
    );

    // ⭐ STAR POP
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

    unlockedIndex = progressBox.get('kenali_unlocked_index', defaultValue: 0);
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
    final bool playStarPop = unlockedIndex > (_lastUnlockedIndex ?? 0);

    if (playStarPop) {
      _lastUnlockedIndex = unlockedIndex;
      _starPopController.forward(from: 0);
    }

    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'assets/images/bg/bg2.png',
              fit: BoxFit.cover,
            ),
          ),
          SafeArea(
            child: Column(
              children: [
                _buildTopBar(),
                const SizedBox(height: 8),
                Text(
                  'Kenali Saya',
                  style: GoogleFonts.baloo2(
                    fontSize: 36,
                    fontWeight: FontWeight.w800,
                    color: const Color(0xFF6B3A00),
                  ),
                ),
                const SizedBox(height: 12),

                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.only(top: 20, bottom: 60),
                    child: Column(
                      children: List.generate(letters.length, (index) {
                        return Column(
                          children: [
                            SizedBox(
                              height: 120,
                              width: 240,
                              child: Align(
                                alignment:
                                    Alignment(_getXAlignment(index), 0),
                                child: _buildTrailNode(
                                  letter: letters[index],
                                  index: index,
                                ),
                              ),
                            ),

                            // ⭐ STAR INDICATOR
                            if (index < letters.length - 1)
                              SizedBox(
                                height: 40,
                                child: AnimatedBuilder(
                                  animation: _starPopController,
                                  builder: (_, __) {
                                    final isCompleted =
                                        index < unlockedIndex;

                                    return Opacity(
                                      opacity: isCompleted &&
                                              index == unlockedIndex - 1
                                          ? _starOpacity.value
                                          : 1,
                                      child: Transform.scale(
                                        scale: isCompleted &&
                                                index == unlockedIndex - 1
                                            ? _starScale.value
                                            : 1,
                                        child: Image.asset(
                                          isCompleted
                                              ? 'assets/images/home/star.png'
                                              : 'assets/images/home/greystar.png',
                                          height: 28,
                                        ),
                                      ),
                                    );
                                  },
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
            child: Image.asset(
              'assets/images/button/home.png',
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

  Widget _buildTrailNode({
    required String letter,
    required int index,
  }) {
    final bool isCurrent = index == unlockedIndex;
    final bool isLocked = index > unlockedIndex;

    final decoration = BoxDecoration(
      shape: BoxShape.circle,
      gradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
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
        BoxShadow(
          color: Colors.white.withOpacity(0.7),
          offset: const Offset(-4, -4),
          blurRadius: 8,
        ),
      ],
    );

    Widget circle = Container(
      width: 76,
      height: 76,
      decoration: decoration,
      alignment: Alignment.center,
      child: Text(
        letter,
        style: GoogleFonts.baloo2(
          fontSize: 34,
          fontWeight: FontWeight.bold,
          color: isLocked ? Colors.grey : const Color(0xFF6B3A00),
        ),
      ),
    );

    if (isCurrent && jumpingIndex == null) {
      circle = ScaleTransition(scale: _pulseAnimation, child: circle);
    }

    circle = AnimatedBuilder(
      animation: _jumpAnimation,
      builder: (_, child) {
        return Transform.translate(
          offset:
              Offset(0, jumpingIndex == index ? _jumpAnimation.value : 0),
          child: child,
        );
      },
      child: circle,
    );

    circle = AnimatedBuilder(
      animation: _shakeAnimation,
      builder: (_, child) {
        return Transform.translate(
          offset: Offset(
              isLocked && shakingIndex == index
                  ? _shakeAnimation.value
                  : 0,
              0),
          child: child,
        );
      },
      child: circle,
    );

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
            builder: (_) => KenaliStagePage(letterIndex: index),
          ),
        );
      },
      child: circle,
    );
  }
}
