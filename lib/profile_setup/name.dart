import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:foni_jomeja/core/audio/tap_sound.dart';
import 'package:flutter/services.dart';
import 'package:hive/hive.dart';

class NameScreen extends StatefulWidget {
  const NameScreen({super.key});

  @override
  State<NameScreen> createState() => _NameScreenState();
}

class _NameScreenState extends State<NameScreen>
    with TickerProviderStateMixin {

  final TextEditingController _nameController = TextEditingController();

  // Voice line audio
  final AudioPlayer _voicePlayer = AudioPlayer();

  // =========================
  // Layout controls
  // =========================
  double titleTop = 50;
  double titleFont = 45;

  double inputTop = 200;
  double inputWidthFactor = 0.92;
  double inputHeight = 72;

  double characterCenterY = 0.48;
  double characterScale = 0.78;

  double buttonBottom = 55;
  double buttonWidth = 300;
  double buttonHeight = 72;

  // =========================
  // Animations
  // =========================
  late AnimationController _shakeController;
  late Animation<Offset> _shakeAnim;

  late AnimationController _bounceController;
  late Animation<double> _bounceAnim;

  @override
  void initState() {
    super.initState();

    /// 🔊 Play narrator voice line
    _voicePlayer.play(
      AssetSource("audio/A.mp3"),
    );

    /// ❗ SHAKE ANIMATION
    _shakeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 350),
    );

    _shakeAnim = TweenSequence([
      TweenSequenceItem(
          weight: 1,
          tween: Tween(begin: Offset.zero, end: const Offset(-0.06, 0))),
      TweenSequenceItem(
          weight: 2,
          tween: Tween(begin: const Offset(-0.06, 0), end: const Offset(0.06, 0))),
      TweenSequenceItem(
          weight: 1,
          tween: Tween(begin: const Offset(0.06, 0), end: Offset.zero)),
    ]).animate(CurvedAnimation(
      parent: _shakeController,
      curve: Curves.easeInOut,
    ));

    /// 💥 BOUNCE ANIMATION
    _bounceController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 260),
    );

    _bounceAnim = Tween(begin: 1.0, end: 1.14)
        .chain(CurveTween(curve: Curves.easeOutBack))
        .animate(_bounceController);
  }

  @override
  void dispose() {
    _voicePlayer.dispose();
    _shakeController.dispose();
    _bounceController.dispose();
    super.dispose();
  }

  // =========================
  // Next button logic
  // =========================
  void _handleNext() {
    final name = _nameController.text.trim();

    if (name.isEmpty) {
      TapSound.play();
      _shakeController.forward(from: 0);
      return;
    }

    TapSound.play();
    _bounceController.forward(from: 0).then((_) {
      Hive.box('child').put("name", name);
      Navigator.pushNamed(context, '/age');
    });
  }

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    final h = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [

          /// BACKGROUND
          Positioned.fill(
            child: Image.asset(
              'assets/images/bg/bg.png',
              fit: BoxFit.cover,
            ),
          ),

          SafeArea(
            child: SizedBox.expand(
              child: Stack(
                children: [

                  /// TITLE
                  Positioned(
                    top: titleTop,
                    left: 0,
                    right: 0,
                    child: Center(
                      child: Text(
                        "Apakah nama\nsi comel anda?",
                        textAlign: TextAlign.center,
                        style: GoogleFonts.baloo2(
                          fontSize: titleFont,
                          fontWeight: FontWeight.w700,
                          color: const Color(0xFF6B3A00),
                        ),
                      ),
                    ),
                  ),

                  /// INPUT FIELD (tap enabled)
                  Positioned(
                    top: inputTop,
                    left: w * (1 - inputWidthFactor) / 2,
                    width: w * inputWidthFactor,
                    child: GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap: () {
                        TapSound.play();
                        FocusScope.of(context).requestFocus(FocusNode());
                      },
                      child: Container(
                        height: inputHeight,
                        padding: const EdgeInsets.symmetric(horizontal: 24),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF6E7B4),
                          borderRadius: BorderRadius.circular(36),
                          boxShadow: const [
                            BoxShadow(
                              color: Color(0xFFFFF2CE),
                              offset: Offset(-4, -4),
                              blurRadius: 6,
                            ),
                            BoxShadow(
                              color: Color(0xFFE0C48A),
                              offset: Offset(5, 5),
                              blurRadius: 12,
                            ),
                          ],
                        ),
                        child: TextField(
                          controller: _nameController,
                          onTap: () => TapSound.play(),
                          style: GoogleFonts.baloo2(
                            fontSize: 30,
                            color: const Color(0xFF6B3A00),
                          ),
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: "Nama",
                            contentPadding: const EdgeInsets.only(bottom: -20),
                            hintStyle: GoogleFonts.baloo2(
                              fontSize: 28,
                              color: const Color(0xFF9C8B6A),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),

                  /// CHARACTER IMAGE
                  Positioned(
                    top: h * (characterCenterY - 0.10),
                    left: 0,
                    right: 0,
                    child: Center(
                      child: SizedBox(
                        width: w * characterScale,
                        child: Image.asset('assets/images/foniname.png'),
                      ),
                    ),
                  ),

                  /// BUTTON WITH ANIMATIONS
                  Positioned(
                    bottom: buttonBottom,
                    left: (w - buttonWidth) / 2,
                    child: SlideTransition(
                      position: _shakeAnim,
                      child: ScaleTransition(
                        scale: _bounceAnim,
                        child: GestureDetector(
                          onTap: () {
                            TapSound.play();
                            _handleNext();
                          },
                          child: Container(
                            width: buttonWidth,
                            height: buttonHeight,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: const Color(0xFFFFC25A),
                              borderRadius: BorderRadius.circular(40),
                              boxShadow: const [
                                BoxShadow(
                                  color: Color(0xFFFFE6A9),
                                  offset: Offset(-4, -4),
                                  blurRadius: 6,
                                ),
                                BoxShadow(
                                  color: Color(0xFFE6A640),
                                  offset: Offset(6, 6),
                                  blurRadius: 14,
                                ),
                                BoxShadow(
                                  color: Colors.black26,
                                  offset: Offset(2, 2),
                                  blurRadius: 6,
                                ),
                              ],
                            ),
                            child: Text(
                              "Seterusnya",
                              style: GoogleFonts.baloo2(
                                fontSize: 30,
                                fontWeight: FontWeight.w700,
                                color: const Color(0xFF6B3A00),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),

                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
