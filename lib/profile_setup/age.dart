import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:hive/hive.dart';
import 'package:foni_jomeja/core/audio/tap_sound.dart';

class AgePage extends StatefulWidget {
  const AgePage({super.key});

  @override
  State<AgePage> createState() => _AgePageState();
}

class _AgePageState extends State<AgePage> with TickerProviderStateMixin {
  int _age = 1;

  final AudioPlayer _voicePlayer = AudioPlayer();

  // ========== Layout Controls ==========
  double titleTop = 50;
  double titleFont = 45;

  double sliderTop = 200;

  double gifTop = 380;   // 🔥 Move GIF up/down here
  double gifWidthFactor = 0.90; // 🔥 Control GIF size here
  // =====================================

  double buttonBottom = 60;
  double buttonWidth = 300;
  double buttonHeight = 72;

  late AnimationController _shakeController;
  late Animation<Offset> _shakeAnim;

  late AnimationController _bounceController;
  late Animation<double> _bounceAnim;

  @override
  void initState() {
    super.initState();

    _voicePlayer.play(
      AssetSource("audio/A.mp3"),
      mode: PlayerMode.lowLatency,
    );

    _shakeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 350),
    );

    _shakeAnim = TweenSequence([
      TweenSequenceItem(
        tween: Tween(begin: Offset.zero, end: const Offset(-0.06, 0)),
        weight: 1,
      ),
      TweenSequenceItem(
        tween: Tween(begin: const Offset(-0.06, 0), end: const Offset(0.06, 0)),
        weight: 2,
      ),
      TweenSequenceItem(
        tween: Tween(begin: const Offset(0.06, 0), end: Offset.zero),
        weight: 1,
      ),
    ]).animate(CurvedAnimation(
      parent: _shakeController,
      curve: Curves.easeInOut,
    ));

    _bounceController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 260),
    );

    _bounceAnim = Tween(begin: 1.0, end: 1.13)
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

  void _handleNext() {
    if (_age < 1 || _age > 10) {
      TapSound.play();
      _shakeController.forward(from: 0);
      return;
    }

    TapSound.play();

    _bounceController.forward(from: 0).then((_) {
      Hive.box('child').put("age", _age);
      Navigator.pushNamed(context, "/avatar");
    });
  }

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [

          // ⭐ BACKGROUND
          Positioned.fill(
            child: Image.asset(
              "assets/images/bg/bg.png",
              fit: BoxFit.cover,
            ),
          ),

          SafeArea(
            child: Stack(
              children: [

                // ⭐ TITLE
                Positioned(
                  top: titleTop,
                  left: 0,
                  right: 0,
                  child: Center(
                    child: Text(
                      "Berapa umur\nsi comel ini?",
                      textAlign: TextAlign.center,
                      style: GoogleFonts.baloo2(
                        fontSize: titleFont,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFF6B3A00),
                      ),
                    ),
                  ),
                ),

                // ⭐ AGE DISPLAY + SLIDER
                Positioned(
                  top: sliderTop,
                  left: 0,
                  right: 0,
                  child: Column(
                    children: [

                      // AGE BUBBLE
                      Container(
                        padding: const EdgeInsets.symmetric(
                          vertical: 10,
                          horizontal: 25,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF6E7B4),
                          borderRadius: BorderRadius.circular(40),
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
                        child: Text(
                          "$_age Tahun",
                          style: GoogleFonts.baloo2(
                            fontSize: 34,
                            color: const Color.fromARGB(255, 146, 81, 1),
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),

                      const SizedBox(height: 30),

                      // SLIDER
                      SliderTheme(
                        data: SliderTheme.of(context).copyWith(
                          activeTrackColor: const Color(0xFFE6A640),
                          inactiveTrackColor: const Color(0xFFF6E7B4),
                          thumbColor: const Color(0xFFE6A640),
                          trackHeight: 20,
                          overlayShape: SliderComponentShape.noOverlay,
                          thumbShape: const RoundSliderThumbShape(
                            enabledThumbRadius: 20,
                          ),
                        ),
                        child: Slider(
                          value: _age.toDouble(),
                          min: 1,
                          max: 10,
                          divisions: 9,
                          onChanged: (v) {
                            setState(() {
                              _age = v.toInt();
                            });
                            TapSound.play();
                          },
                        ),
                      ),
                    ],
                  ),
                ),

                // ⭐ GIF (cropped & centered)
                Positioned(
                  top: gifTop,
                  left: 0,
                  right: 0,
                  child: Center(
                    child: SizedBox(
                      width: w * gifWidthFactor, // 🔥 control GIF size
                      child: ClipRect(
                        child: Align(
                          alignment: Alignment.topCenter,
                          heightFactor: 0.90, // 🔥 crop 10% bottom watermark
                          child: Image.asset(
                            "assets/video/umur.gif",
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),

                // ⭐ NEXT BUTTON
                Positioned(
                  bottom: buttonBottom,
                  left: (w - buttonWidth) / 2,
                  child: SlideTransition(
                    position: _shakeAnim,
                    child: ScaleTransition(
                      scale: _bounceAnim,
                      child: GestureDetector(
                        onTap: _handleNext,
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
        ],
      ),
    );
  }
}
