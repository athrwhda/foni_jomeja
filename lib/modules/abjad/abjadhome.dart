import 'package:flutter/material.dart';
import 'package:foni_jomeja/modules/abjad/letter/introduce_letter_page.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive/hive.dart';
import 'package:foni_jomeja/core/audio/tap_sound.dart';
import 'widgets/abjad_tile.dart';
import 'package:foni_jomeja/home/home_page.dart';

class AbjadHomePage extends StatelessWidget {
  const AbjadHomePage({super.key});


  @override
  Widget build(BuildContext context) {
    final int stars = Hive.box('scores').get('stars', defaultValue: 0);
    final int unlockedIndex = 
        Hive.box('progress').get('abjad_unlocked_index', defaultValue: 0);


    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // 🌿 Background
          Positioned.fill(
            child: Image.asset(
              "assets/images/bg/bg3.png",
              fit: BoxFit.cover,
            ),
          ),


          SafeArea(
            child: Column(
              children: [
                // 🔝 TOP BAR (MATCH HOME STYLE)
              Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Row(
                     children: [


      // ⬅️ HOME BUTTON (IMAGE)
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
    "assets/images/button/home.png",
    height: 46,
  ),
),


      const Spacer(),


      // ⭐ STAR CONTAINER (SAME AS HOME, BUT RIGHT)
      Stack(
        alignment: Alignment.centerLeft,
        children: [
          Image.asset(
            "assets/images/button/star_container.png",
            height: 56,
          ),


          Positioned(
            right: 43,
            top: 8,
            child: Text(
              "$stars",
              style: GoogleFonts.baloo2(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ),
        ],
      ),
    ],
  ),
),




                const SizedBox(height: 12),


                // 🅰️ TITLE
                Text(
                  "Abjad",
                  style: GoogleFonts.baloo2(
                    fontSize: 36,
                    fontWeight: FontWeight.w800,
                    color: const Color(0xFF6B3A00),
                  ),
                ),


                const SizedBox(height: 16),


                // 🔤 ALPHABET GRID
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 14),
                    child: GridView.builder(
                      physics: const BouncingScrollPhysics(),
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 4,
                        mainAxisSpacing: 14,
                        crossAxisSpacing: 14,
                        childAspectRatio: 1,
                      ),
                      itemCount: 26,
                      itemBuilder: (context, index) {
                        final letter = String.fromCharCode(65 + index);
                        return AbjadTile(
                          letter: letter,
                          isUnlocked: index <= unlockedIndex,
                          onTap: () {
                              // 🚧 later: go to A page
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => IntroduceLetterPage(letter: letter),
                                ),
                              );
                          },
                        );
                      },
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
}


// 🍡 SINGLE JELLY LETTER TILE
class _AbjadTile extends StatefulWidget {
  final String letter;


  const _AbjadTile({required this.letter});


  @override
  State<_AbjadTile> createState() => _AbjadTileState();
}


class _AbjadTileState extends State<_AbjadTile>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scale;


  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 180),
    );
    _scale = Tween(begin: 1.0, end: 0.92).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );
  }


  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }


  Future<void> _onTap() async {
    TapSound.play();
    await _controller.forward();
    _controller.reverse();


    // 🔜 later: Navigator.push to tracing page
  }


  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (_, __) {
        return Transform.scale(
          scale: _scale.value,
          child: GestureDetector(
            onTap: _onTap,
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
        );
      },
    );
  }
}
