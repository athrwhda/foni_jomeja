// lib/profile_setup/avatar.dart
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive/hive.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:foni_jomeja/core/audio/tap_sound.dart';

class AvatarPage extends StatefulWidget {
  const AvatarPage({super.key});

  @override
  State<AvatarPage> createState() => _AvatarPageState();
}

class _AvatarPageState extends State<AvatarPage> with TickerProviderStateMixin {
  int _selectedIndex = -1; // -1 = none selected

  // voice audio
  final AudioPlayer _voicePlayer = AudioPlayer();

  // ========= Layout knobs (change these to adjust look) =========
  double titleTop = 50;
  double titleFont = 45;

  double gridTop = 200;      // move up/down the whole avatar grid
  double avatarSize = 150;   // diameter of each avatar circle (increased)
  double avatarSpacing = 10; // spacing between avatars

  double charPadding = 1;   // how much inner padding around character inside circle

  double buttonBottom = 60;
  double buttonWidth = 300;
  double buttonHeight = 72;
  // =============================================================

  // gradients for each avatar (index 0..5)
  final List<Gradient> _gradients = [
    const LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [Color(0xFFFF9869), Color(0xFFFFD2B2)],
    ),
    const LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [Color(0xFF84A9FF), Color(0xFFF5F8FF)],
    ),
    const LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [Color(0xFF7CCE6B), Color(0xFFD8FFD0)],
    ),
    const LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [Color(0xFFFFDA6A), Color(0xFFFFF7DE)],
    ),
    const LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [Color(0xFFF093FF), Color(0xFFFDF1FF)],
    ),
    const LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [Color(0xFFFFDA6A), Color(0xFFFFF7DE)],
    ),
  ];

  final List<Color> _glowColors = [
    const Color(0xFFFFB35C),
    const Color(0xFF7FA9FF),
    const Color(0xFF8EE07C),
    const Color(0xFFFFCF5A),
    const Color(0xFFEA9EFF),
    const Color(0xFFFFCF5A),
  ];

  // ANIMATIONS
  late AnimationController _staggerController; // pop-in
  late List<Animation<double>> _popInScales;

  late AnimationController _breathController; // continuous breathing for unselected
  // breath will be read via controller value + per-item phase

  late AnimationController _bounceController; // one-time bounce when select
  late Animation<double> _bounceAnim;

  late AnimationController _danceController; // global clock for dance sine offsets
  final List<double> _phases = List.generate(6, (i) => (i * 0.73) + 0.2); // per-item phases

  @override
  void initState() {
    super.initState();

    // play voice line on entry
    _voicePlayer.play(
      AssetSource("audio/A.mp3"),
      mode: PlayerMode.lowLatency,
    );

    // -------------------
    // STAGGERED POP-IN (tweaked to be "cantik")
    // -------------------
   // replace your existing stagger block with this:

_staggerController = AnimationController(
  vsync: this,
  duration: const Duration(milliseconds: 900), // longer overall so each pop is visible
);

// How stagger works:
// - staggerStep = how far apart each item's animation starts (0.0..1.0)
// - itemSpan   = how long each item's interval is (0.0..1.0)
// The controller runs from 0.0 -> 1.0; Interval(start, end) maps a slice of that range to each item.
final double staggerStep = 0.12; // increase to make items pop more spaced out
final double itemSpan = 0.60;

_popInScales = List.generate(6, (i) {
  final double start = (i * staggerStep).clamp(0.0, 1.0);
  final double end = (start + itemSpan).clamp(0.0, 1.0);

  // start from 0.0 (hidden) to 1.0 (final). Using elasticOut for a cute pop.
  return Tween<double>(begin: 0.0, end: 1.0).animate(
    CurvedAnimation(
      parent: _staggerController,
      curve: Interval(start, end, curve: Curves.elasticOut),
    ),
  );
});


    // kick the pop-in
    _staggerController.forward();

    // -------------------
    // BREATH: subtle scale pulse for unselected items (continuous)
    // -------------------
    _breathController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    )..repeat();

    // -------------------
    // BOUNCE (when selecting)
    // -------------------
    _bounceController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 320),
    );

    _bounceAnim = Tween<double>(begin: 1.0, end: 1.14)
        .chain(CurveTween(curve: Curves.easeOutBack))
        .animate(_bounceController);

    // -------------------
    // DANCE clock (sine-based offsets)
    // -------------------
    _danceController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    )..repeat();

    // (phases generated above)
  }

  @override
  void dispose() {
    _staggerController.dispose();
    _breathController.dispose();
    _bounceController.dispose();
    _danceController.dispose();
    _voicePlayer.dispose();
    super.dispose();
  }

  void _onAvatarTap(int index) {
    TapSound.play();

    // if tap the same -> unselect, keep breathing alive
    if (_selectedIndex == index) {
      setState(() {
        _selectedIndex = -1;
      });

      // stop bounce and keep dance controller running only when selected (we'll ignore it if not selected)
      _bounceController.reset();
      Hive.box('child').delete('avatar');
      return;
    }

    // selecting new avatar
    setState(() {
      _selectedIndex = index;
    });

    // bounce once
    _bounceController.forward(from: 0);

    // save selection
    Hive.box('child').put('avatar', 'char${index + 1}');
  }

  void _handleNext() {
    if (_selectedIndex == -1) {
      TapSound.play();
      return;
    }
    TapSound.play();
    Navigator.pushNamed(context, '/home');
  }

  Widget _buildAvatarItem(int index, double size) {
    final bool selected = _selectedIndex == index;

    // stronger glow + border when selected
    final List<BoxShadow> shadows = [
      if (selected)
        BoxShadow(
          color: _glowColors[index].withOpacity(0.42),
          blurRadius: 26,
          spreadRadius: 6,
        ),
      BoxShadow(
        color: Colors.white.withOpacity(selected ? 0.65 : 0.32),
        blurRadius: selected ? 22 : 10,
        spreadRadius: selected ? 4 : 2,
      ),
      BoxShadow(
        color: Colors.black.withOpacity(0.12),
        offset: const Offset(2, 4),
        blurRadius: 6,
      ),
    ];

    // parameters to tweak
    const double breathMin = 0.985;
    const double breathMax = 1.015;
    const double danceAmplitude = 8.0; // px
    final double phase = _phases[index];

    return AnimatedBuilder(
      animation: Listenable.merge([_staggerController, _breathController, _bounceController, _danceController]),
      builder: (context, child) {
        // pop-in scale (driven by stagger controller)
        final double popScale = _popInScales[index].value;

        // breathing scale (for unselected items) — use sine with per-item phase so they breathe slightly out-of-phase
        final double breathT = _breathController.value; // 0..1
        final double breathSin = math.sin((breathT * 2 * math.pi) + phase);
        final double breathScale = breathMin + ( (breathSin + 1) / 2 ) * (breathMax - breathMin);

        // bounce scale (applied only when selected)
        final double bounceScale = selected ? _bounceAnim.value : 1.0;

        // dance offset — sine with per-item phase for less uniform movement; only visually used when selected
        final double danceT = _danceController.value;
        final double danceOffset = selected ? math.sin((danceT * 2 * math.pi) + phase) * danceAmplitude : 0.0;

        // final scale: pop-in * (if selected bounce else breathing)
        final double finalScale = popScale * (selected ? bounceScale : breathScale);

        // Keep each item the same physical layout size to avoid reflow: wrap with SizedBox fixed to avatarSize
        return Transform.translate(
          offset: Offset(danceOffset, 0),
          child: Transform.scale(
            scale: finalScale,
            child: GestureDetector(
              onTap: () => _onAvatarTap(index),
              child: SizedBox(
                width: size,
                height: size,
                child: Container(
                  margin: EdgeInsets.all(avatarSpacing / 2),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: _gradients[index],
                    boxShadow: shadows,
                    border: selected
                        ? Border.all(
                            color: _glowColors[index].withOpacity(0.95),
                            width: 4,
                          )
                        : null,
                  ),
                  child: ClipOval(
                    child: Padding(
                      padding: EdgeInsets.all(charPadding),
                      child: Image.asset(
                        'assets/images/charbody/char${index + 1}.png',
                        fit: BoxFit.contain,
                      ),
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

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    final double calcAvatarSize = avatarSize;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // Background (same as other screens)
          Positioned.fill(
            child: Image.asset(
              "assets/images/bg/bg.png",
              fit: BoxFit.cover,
            ),
          ),

          SafeArea(
            child: Stack(
              children: [
                // Title
                Positioned(
                  top: titleTop,
                  left: 0,
                  right: 0,
                  child: Center(
                    child: Text(
                      "Pilih avatar untuk\nsi comel",
                      textAlign: TextAlign.center,
                      style: GoogleFonts.baloo2(
                        fontSize: titleFont,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFF6B3A00),
                      ),
                    ),
                  ),
                ),

                // Avatar grid: using Wrap so it adapts nicely
                Positioned(
                  top: gridTop,
                  left: 0,
                  right: 0,
                  child: Center(
                    child: SizedBox(
                      width: w * 0.86,
                      child: Wrap(
                        alignment: WrapAlignment.center,
                        runSpacing: avatarSpacing,
                        spacing: avatarSpacing,
                        children: List.generate(
                          6,
                          (i) => _buildAvatarItem(i, calcAvatarSize),
                        ),
                      ),
                    ),
                  ),
                ),

                // Seterusnya button (same style as others)
                Positioned(
                  bottom: buttonBottom,
                  left: (w - buttonWidth) / 2,
                  child: GestureDetector(
                    onTap: _handleNext,
                    child: Opacity(
                      opacity: _selectedIndex == -1 ? 0.6 : 1.0,
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
              ],
            ),
          ),
        ],
      ),
    );
  }
}
