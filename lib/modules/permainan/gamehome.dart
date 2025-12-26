import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive/hive.dart';

import 'package:foni_jomeja/core/audio/tap_sound.dart';
import 'package:foni_jomeja/home/home_page.dart';

import 'belonpop_page.dart';
import 'padankad_page.dart';
import 'suaihuruf_page.dart';
import 'permainan_music.dart';

class GameHome extends StatefulWidget {
  const GameHome({super.key});

  @override
  State<GameHome> createState() => _GameHomeState();
}

class _GameHomeState extends State<GameHome>
    with TickerProviderStateMixin {
  late PageController _pageController;
  int _currentIndex = 0;
  int stars = 0;

  /// 🌬️ IDLE BREATHING
  late AnimationController _breathController;
  late Animation<double> _breathScale;

  /// 👆 TAP SQUISH
  late AnimationController _tapController;
  late Animation<double> _tapScale;

  final List<_GameCardData> games = [
    _GameCardData(
      image: 'assets/images/logo/suaihuruf.png',
      routeName: 'suai_huruf',
      gradient: const LinearGradient(
        colors: [Color(0xFFFFF4C8), Color(0xFFDFF2FF)],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      ),
      shadow: const Color(0xFFFFE08A),
    ),
    _GameCardData(
      image: 'assets/images/logo/Belon_pop.png',
      routeName: 'belon_pop',
      gradient: const LinearGradient(
        colors: [Color(0xFFE7F5FF), Color(0xFFBEEBFF)],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      ),
      shadow: const Color(0xFF9FD9FF),
    ),
    _GameCardData(
      image: 'assets/images/logo/padankad.png',
      routeName: 'ingat_cari',
      gradient: const LinearGradient(
        colors: [Color(0xFFE9FFE9), Color(0xFFCCF5E1)],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      ),
      shadow: const Color(0xFF9EE6B8),
    ),
  ];

  @override
  void initState() {
    super.initState();

    _pageController = PageController(viewportFraction: 0.78);
    _loadStars();

    /// 🎵 START PERMAINAN MUSIC (ONCE)
    PermainanMusic().init();

    /// 🌬️ BREATHING
    _breathController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2200),
    )..repeat(reverse: true);

    _breathScale = Tween<double>(begin: 1.0, end: 1.035).animate(
      CurvedAnimation(parent: _breathController, curve: Curves.easeInOut),
    );

    /// 👆 TAP SQUISH
    _tapController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 320),
    );

    _tapScale = TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: 1.0, end: 0.92), weight: 1),
      TweenSequenceItem(
        tween: Tween(begin: 0.92, end: 1.06)
            .chain(CurveTween(curve: Curves.easeOutBack)),
        weight: 2,
      ),
      TweenSequenceItem(tween: Tween(begin: 1.06, end: 1.0), weight: 1),
    ]).animate(_tapController);
  }

  void _loadStars() {
    final scoreBox = Hive.box('scores');
    stars = scoreBox.get('stars', defaultValue: 0);
  }

  Future<void> _toggleMusic() async {
    TapSound.play();
    await PermainanMusic().toggle();
    setState(() {});
  }

  @override
  void dispose() {
    /// 🎵 STOP PERMAINAN MUSIC ONLY WHEN LEAVING MODULE
    _pageController.dispose();
    _breathController.dispose();
    _tapController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

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
                const SizedBox(height: 6),
                Image.asset(
                  'assets/images/logo/permainan.png',
                  height: 80,
                ),
                const SizedBox(height: 32),
                SizedBox(
                  height: screenHeight * 0.60,
                  child: PageView.builder(
                    controller: _pageController,
                    itemCount: games.length,
                    onPageChanged: (i) =>
                        setState(() => _currentIndex = i),
                    itemBuilder: (context, index) {
                      final isActive = index == _currentIndex;
                      return _buildGameCard(games[index], isActive);
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// 🔝 TOP BAR — [ HOME ]   [ 🎵 ] [ ⭐ ]
  Widget _buildTopBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          GestureDetector(
            onTap: () {
              TapSound.play();
              PermainanMusic().dispose();
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (_) => const HomePage()),
                (_) => false,
              );
            },
            child: Image.asset(
              'assets/images/button/home.png',
              height: 46,
            ),
          ),
          const Spacer(),
          GestureDetector(
            onTap: _toggleMusic,
            child: Image.asset(
              PermainanMusic().isMuted
                  ? 'assets/images/button/no_music.png'
                  : 'assets/images/button/music.png',
              height: 40,
            ),
          ),
          const SizedBox(width: 10),
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

  /// 🎴 CARD WITH BREATH + SQUISH
  Widget _buildGameCard(_GameCardData data, bool isActive) {
    return AnimatedBuilder(
      animation: Listenable.merge([_breathController, _tapController]),
      builder: (_, child) {
        double scale = isActive ? _breathScale.value : 0.9;
        if (_tapController.isAnimating && isActive) {
          scale *= _tapScale.value;
        }
        return Transform.scale(scale: scale, child: child);
      },
      child: AnimatedOpacity(
        opacity: isActive ? 1.0 : 0.6,
        duration: const Duration(milliseconds: 260),
        child: GestureDetector(
          onTap: () async {
            if (!isActive) return;

            TapSound.play();
            await _tapController.forward(from: 0);
            if (!context.mounted) return;

            switch (data.routeName) {
              case 'suai_huruf':
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const SuaiHurufPage(),
                  ),
                );
                break;
              case 'belon_pop':
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const BelonPopPage(),
                  ),
                );
                break;
              case 'ingat_cari':
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const PadanKadPage(),
                  ),
                );
                break;
            }
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            child: AspectRatio(
              aspectRatio: 2 / 2.8,
              child: Container(
                decoration: BoxDecoration(
                  gradient: data.gradient,
                  borderRadius: BorderRadius.circular(44),
                  boxShadow: [
                    BoxShadow(
                      color: data.shadow,
                      offset: const Offset(-6, -6),
                      blurRadius: 8,
                    ),
                    BoxShadow(
                      color: data.shadow.withOpacity(0.6),
                      offset: const Offset(8, 8),
                      blurRadius: 16,
                    ),
                  ],
                ),
                child: Center(
                  child: Image.asset(
                    data.image,
                    fit: BoxFit.contain,
                    cacheHeight: 650,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// 📦 MODEL
class _GameCardData {
  final String image;
  final String routeName;
  final Gradient gradient;
  final Color shadow;

  _GameCardData({
    required this.image,
    required this.routeName,
    required this.gradient,
    required this.shadow,
  });
}
