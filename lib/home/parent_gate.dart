import 'dart:math';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:foni_jomeja/core/audio/tap_sound.dart';

class ParentGatePage extends StatefulWidget {
  const ParentGatePage({super.key});

  @override
  State<ParentGatePage> createState() => _ParentGatePageState();
}

class _ParentGatePageState extends State<ParentGatePage> {
  final TextEditingController _controller = TextEditingController();

  List<int> _numbers = [];
  String _answer = "";
  String? _errorText;

  final Map<int, String> nomborMalay = {
    1: "SATU",
    2: "DUA",
    3: "TIGA",
    4: "EMPAT",
    5: "LIMA",
    6: "ENAM",
    7: "TUJUH",
    8: "LAPAN",
    9: "SEMBILAN",
  };

  @override
  void initState() {
    super.initState();
    _generateQuestion();
  }

  void _generateQuestion({bool clearError = true}) {
    final rand = Random();

    _numbers = List.generate(4, (_) => rand.nextInt(9) + 1);
    _answer = _numbers.join();

    _controller.clear();
    if (clearError) _errorText = null;

    setState(() {});
  }

  void _checkAnswer() {
    TapSound.play();

    if (_controller.text.trim() == _answer) {
      Navigator.pushReplacementNamed(context, "/profiles");
    } else {
      setState(() {
        _errorText = "Jawapan tidak betul. Cuba lagi 😊";
      });

      // reshuffle BUT keep error visible
      _generateQuestion(clearError: false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // 🌤 Background
          Positioned.fill(
            child: Image.asset(
              "assets/images/bg/bg3.png",
              fit: BoxFit.cover,
            ),
          ),

          SafeArea(
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 420),
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Untuk Ibu Bapa",
                        style: GoogleFonts.baloo2(
                          fontSize: 34,
                          fontWeight: FontWeight.w700,
                          color: const Color(0xFF6B3A00),
                        ),
                      ),

                      const SizedBox(height: 16),

                      Text(
                        "Sila taip nombor berikut:",
                        style: GoogleFonts.baloo2(
                          fontSize: 20,
                          color: Colors.brown,
                        ),
                      ),

                      const SizedBox(height: 16),

                      // 🔢 NUMBERS (ALLOW 2 LINES SAFELY)
                      Wrap(
                        alignment: WrapAlignment.center,
                        spacing: 10,
                        runSpacing: 10,
                        children: _numbers.map((n) {
                          return Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 14,
                              vertical: 10,
                            ),
                            decoration: BoxDecoration(
                              color: const Color(0xFFFFF5D7),
                              borderRadius: BorderRadius.circular(22),
                            ),
                            child: Text(
                              nomborMalay[n]!,
                              style: GoogleFonts.baloo2(
                                fontSize: 22,
                                fontWeight: FontWeight.w800,
                                color: const Color(0xFF6B3A00),
                              ),
                            ),
                          );
                        }).toList(),
                      ),

                      const SizedBox(height: 26),

                      // ⌨ INPUT FIELD
                      Container(
                        width: 220,
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFFF5D7),
                          borderRadius: BorderRadius.circular(26),
                          boxShadow: const [
                            BoxShadow(
                              color: Color(0xFFEAD9A8),
                              offset: Offset(4, 4),
                              blurRadius: 10,
                            ),
                          ],
                        ),
                        child: TextField(
                          controller: _controller,
                          keyboardType: TextInputType.number,
                          maxLength: 4,
                          textAlign: TextAlign.center,
                          style: GoogleFonts.baloo2(
                            fontSize: 30,
                            fontWeight: FontWeight.w700,
                            color: Colors.black,
                          ),
                          onChanged: (_) {
                            if (_errorText != null) {
                              setState(() => _errorText = null);
                            }
                          },
                          decoration: InputDecoration(
                            counterText: "",
                            hintText: "Contoh: 2517",
                            hintStyle: GoogleFonts.baloo2(
                              fontSize: 24,
                              color: Colors.grey,
                            ),
                            errorText: _errorText,
                            border: InputBorder.none,
                          ),
                        ),
                      ),

                      const SizedBox(height: 28),

                      // ✅ SAHKAN
                      SizedBox(
                        width: 240,
                        height: 56,
                        child: GestureDetector(
                          onTap: _checkAnswer,
                          child: Container(
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: const Color(0xFFB9F1A1),
                              borderRadius: BorderRadius.circular(40),
                              boxShadow: const [
                                BoxShadow(
                                  color: Color(0xFF9EDC87),
                                  offset: Offset(4, 4),
                                  blurRadius: 12,
                                ),
                              ],
                            ),
                            child: Text(
                              "Sahkan",
                              style: GoogleFonts.baloo2(
                                fontSize: 22,
                                fontWeight: FontWeight.w700,
                                color: const Color(0xFF2E6B1F),
                              ),
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 14),

                      // ❌ BATAL
                      SizedBox(
                        width: 240,
                        height: 56,
                        child: GestureDetector(
                          onTap: () {
                            TapSound.play();
                            Navigator.pop(context);
                          },
                          child: Container(
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: const Color(0xFFFFC2C2),
                              borderRadius: BorderRadius.circular(40),
                              boxShadow: const [
                                BoxShadow(
                                  color: Color(0xFFFF9A9A),
                                  offset: Offset(4, 4),
                                  blurRadius: 12,
                                ),
                              ],
                            ),
                            child: Text(
                              "Batal",
                              style: GoogleFonts.baloo2(
                                fontSize: 22,
                                fontWeight: FontWeight.w700,
                                color: Colors.red.shade700,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
