import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive/hive.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:foni_jomeja/core/audio/tap_sound.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  final AudioPlayer _voicePlayer = AudioPlayer();

  late AnimationController _titleController;
  late Animation<Offset> _titleSlide;

  late AnimationController _foniController;
  late Animation<double> _foniScale;

  late AnimationController _staggerController;
  late List<Animation<double>> _btnScale;
  late List<Animation<double>> _btnOpacity;

  static const int btnCount = 4;

  @override
  void initState() {
    super.initState();

    Future.delayed(const Duration(milliseconds: 300), () {
      _voicePlayer.play(AssetSource("audio/A.mp3"));
    });

    _titleController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );

    _titleSlide = Tween<Offset>(
      begin: const Offset(0, -0.6),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _titleController, curve: Curves.easeOutBack),
    );

    _titleController.forward();

    _foniController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2400),
    );

    _foniScale = Tween<double>(begin: 1.0, end: 1.04).animate(
      CurvedAnimation(parent: _foniController, curve: Curves.easeInOut),
    );

    _foniController.repeat(reverse: true);

    _staggerController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 950),
    );

    _btnScale = List.generate(btnCount, (i) {
      final start = i * 0.12;
      return Tween<double>(begin: 0.7, end: 1.0).animate(
        CurvedAnimation(
          parent: _staggerController,
          curve: Interval(start, start + 0.55, curve: Curves.easeOutBack),
        ),
      );
    });

    _btnOpacity = List.generate(btnCount, (i) {
      final start = i * 0.12;
      return Tween<double>(begin: 0, end: 1).animate(
        CurvedAnimation(
          parent: _staggerController,
          curve: Interval(start, start + 0.45, curve: Curves.easeIn),
        ),
      );
    });

    Future.delayed(const Duration(milliseconds: 420), () {
      if (mounted) _staggerController.forward();
    });
  }

  @override
  void dispose() {
    _voicePlayer.dispose();
    _titleController.dispose();
    _foniController.dispose();
    _staggerController.dispose();
    super.dispose();
  }

  @override
void didChangeDependencies() {
  super.didChangeDependencies();
  setState(() {}); // force refresh when coming back
}


  Widget _wrapButton({required int index, required MenuButton button}) {
    return AnimatedBuilder(
      animation: _staggerController,
      builder: (_, child) {
        return Opacity(
          opacity: _btnOpacity[index].value,
          child: Transform.scale(
            scale: _btnScale[index].value,
            child: child,
          ),
        );
      },
      child: button,
    );
  }

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;

    String avatarName = Hive.box('child').get("avatar", defaultValue: "char1");
    int stars = Hive.box('scores').get("stars", defaultValue: 0);

    String avatarImage = "assets/images/charbody/$avatarName.png";

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset("assets/images/bg/bg3.png", fit: BoxFit.cover),
          ),

          SafeArea(
            child: Stack(
              children: [
                // 🌟 STAR COUNTER WITH GRADIENT BORDER
                Positioned(
                  top: 10,
                  left: 18,
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [
                          Color(0xFFFFE37A),
                          Color(0xFFFFC27A),
                          Color(0xFFFFA85A),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(26),
                    ),
                    padding: const EdgeInsets.all(3),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFF5D7),
                        borderRadius: BorderRadius.circular(22),
                      ),
                      child: Row(
                        children: [
                          Image.asset("assets/images/home/star.png", height: 32),
                          const SizedBox(width: 8),
                          Text(
                            "$stars",
                            style: GoogleFonts.baloo2(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.brown,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                // 🌈 AVATAR WITH RAINBOW BORDER
                Positioned(
                  top: 6,
                  right: 18,
                  child: GestureDetector(
                    onTap: () {
                        TapSound.play(); // 🔊 ball_tap.wav
                        Navigator.pushNamed(context, "/parentGate");
                      },
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [
                            Colors.pink,
                            Colors.orange,
                            Colors.yellow,
                            Colors.green,
                            Colors.blue,
                            Colors.purple,
                          ],
                        ),
                        shape: BoxShape.circle,
                      ),
                      padding: const EdgeInsets.all(3),
                      child: CircleAvatar(
                        radius: 36,
                        backgroundColor: const Color(0xFFFFF5D7),
                        child: ClipOval(
                          child: Image.asset(avatarImage, width: 72, height: 72),
                        ),
                      ),
                    ),
                  ),
                ),

                // FONI breathing
                Positioned(
                  top: 170,
                  left: 0,
                  right: 0,
                  child: Center(
                    child: AnimatedBuilder(
                      animation: _foniController,
                      builder: (_, child) {
                        return Transform.scale(
                          scale: _foniScale.value,
                          child: child,
                        );
                      },
                      child: Image.asset("assets/images/home/foni.png", width: w * 0.58),
                    ),
                  ),
                ),

                // TITLE slide
                Positioned(
                  top: 80,
                  left: 0,
                  right: 0,
                  child: Center(
                    child: SlideTransition(
                      position: _titleSlide,
                      child: Image.asset(
                        "assets/images/home/title.png",
                        width: w * 0.75,
                      ),
                    ),
                  ),
                ),

                // MENU BUTTONS
                Positioned(
                  bottom: 130,
                  left: 0,
                  right: 0,
                  child: Center(
                    child: Wrap(
                      spacing: 16,
                      runSpacing: 16,
                      children: [
                        _wrapButton(
                          index: 0,
                          button: const MenuButton(
                            color: Color(0xFFBFECAC),
                            shadow: Color(0xFFA0DE85),
                            label: "Abjad",
                            asset: "assets/images/home/abjad.png",
                            page: "abjad",
                          ),
                        ),
                        _wrapButton(
                          index: 1,
                          button: const MenuButton(
                            color: Color(0xFFFFC2C2),
                            shadow: Color(0xFFFF9999),
                            label: "Suku Kata",
                            asset: "assets/images/home/dice.png",
                            page: "suku",
                          ),
                        ),
                        _wrapButton(
                          index: 2,
                          button: const MenuButton(
                            color: Color(0xFFE2CBF6),
                            shadow: Color(0xFFCEA8F0),
                            label: "Kenali Saya",
                            asset: "assets/images/home/kenali.png",
                            page: "kenali",
                          ),
                        ),
                        _wrapButton(
                          index: 3,
                          button: const MenuButton(
                            color: Color(0xFF99F0FF),
                            shadow: Color(0xFF7AD0D8),
                            label: "Permainan",
                            asset: "assets/images/home/game.png",
                            page: "main",
                          ),
                        ),
                      ],
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

// 🌟 MENU BUTTON CLASS (unchanged)
class MenuButton extends StatefulWidget {
  final Color color;
  final Color shadow;
  final String label;
  final String asset;
  final String page;

  const MenuButton({
    super.key,
    required this.color,
    required this.shadow,
    required this.label,
    required this.asset,
    required this.page,
  });

  @override
  State<MenuButton> createState() => _MenuButtonState();
}

class _MenuButtonState extends State<MenuButton>
    with TickerProviderStateMixin {
  late AnimationController _tapController;
  late Animation<double> _scaleAnim;
  late Animation<double> _wiggleAnim;

  @override
  void initState() {
    super.initState();

    _tapController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 350),
    );

    _scaleAnim = Tween<double>(begin: 1.0, end: 1.09).animate(
      CurvedAnimation(parent: _tapController, curve: Curves.easeOutBack),
    );

    _wiggleAnim = Tween<double>(begin: -4, end: 4).animate(
      CurvedAnimation(parent: _tapController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _tapController.dispose();
    super.dispose();
  }

  Future<void> _handleTap() async {
    TapSound.play();

    await _tapController.forward(from: 0);
    _tapController.reverse();

    final chime = AudioPlayer()..setReleaseMode(ReleaseMode.stop);
    chime.play(AssetSource("audio/win_chimes.wav"));

    await Future.delayed(const Duration(milliseconds: 180));
    if (!mounted) return;

    Navigator.pushNamed(context, "/${widget.page}");
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _tapController,
      builder: (_, child) {
        return Transform.translate(
          offset: Offset(_wiggleAnim.value, 0),
          child: Transform.scale(scale: _scaleAnim.value, child: child),
        );
      },
      child: GestureDetector(
        onTap: _handleTap,
        child: Container(
          width: 160,
          height: 135,
          decoration: BoxDecoration(
            color: widget.color,
            borderRadius: BorderRadius.circular(26),
            boxShadow: [
              BoxShadow(color: widget.shadow, offset: const Offset(-4, -4), blurRadius: 6),
              BoxShadow(color: widget.shadow.withOpacity(0.5), offset: const Offset(6, 6), blurRadius: 12),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(widget.asset, height: 60),
              const SizedBox(height: 8),
              Text(
                widget.label,
                style: GoogleFonts.baloo2(
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFF6B3A00),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
