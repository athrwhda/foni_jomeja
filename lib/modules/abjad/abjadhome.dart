import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AbjadHome extends StatelessWidget {
  const AbjadHome({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Text(
          "Halaman Abjad",
          style: GoogleFonts.baloo2(
            fontSize: 34,
            fontWeight: FontWeight.bold,
            color: Color(0xFF6B3A00),
          ),
        ),
      ),
    );
  }
}
