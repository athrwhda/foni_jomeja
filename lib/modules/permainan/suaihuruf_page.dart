import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive/hive.dart';

import 'package:foni_jomeja/core/audio/tap_sound.dart';
import 'permainan_music.dart';

class SuaiHurufPage extends StatefulWidget {
  const SuaiHurufPage({super.key});

  @override
  State<SuaiHurufPage> createState() => _SuaiHurufPageState();
}

class _SuaiHurufPageState extends State<SuaiHurufPage> {
  @override
  void initState() {
    super.initState();
    PermainanMusic().init();
  }
  @override
  Widget build(BuildContext context) {
    final int stars =
        Hive.box('scores').get('stars', defaultValue: 0);

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
                _buildTopBar(context, stars),
                const SizedBox(height: 40),

                Text(
                  'Suai Huruf',
                  style: GoogleFonts.baloo2(
                    fontSize: 34,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF6B3A00),
                  ),
                ),

                const Expanded(
                  child: Center(
                    child: Text(
                      'Dummy Suai Huruf Game',
                      style: TextStyle(fontSize: 22),
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

  Widget _buildTopBar(BuildContext context, int stars) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          // 🍔 BACK
          GestureDetector(
            onTap: () {
              TapSound.play();
              Navigator.pop(context);
            },
            child: Image.asset(
              'assets/images/button/hamburger.png',
              height: 44,
            ),
          ),

          const Spacer(),

          // 🎵 MUSIC TOGGLE
          GestureDetector(
            onTap: () async {
              TapSound.play();
              await PermainanMusic().toggle();
              (context as Element).markNeedsBuild();
            },
            child: Image.asset(
              PermainanMusic().isMuted
                  ? 'assets/images/button/no_music.png'
                  : 'assets/images/button/music.png',
              height: 40,
            ),
          ),

          const SizedBox(width: 10),

          // ⭐ STARS
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
}
