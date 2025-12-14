import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive/hive.dart';
import 'package:foni_jomeja/core/audio/tap_sound.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final box = Hive.box('child');

    final String name = box.get('name', defaultValue: 'Si Comel');
    final int age = box.get('age', defaultValue: 0);
    final String avatar = box.get('avatar', defaultValue: 'char1');

    final String avatarPath = 'assets/images/charbody/$avatar.png';

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // 🌤 BACKGROUND
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
                child: Column(
                  children: [
                    const SizedBox(height: 40),

                    // 🟤 TITLE
                    Text(
                      "Profil Si Comel",
                      style: GoogleFonts.baloo2(
                        fontSize: 36,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFF6B3A00),
                      ),
                    ),

                    const SizedBox(height: 30),

                    // 🌈 AVATAR WITH RAINBOW BORDER
                    Container(
                      padding: const EdgeInsets.all(4),
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: LinearGradient(
                          colors: [
                            Colors.pink,
                            Colors.orange,
                            Colors.yellow,
                            Colors.green,
                            Colors.blue,
                            Colors.purple,
                          ],
                        ),
                      ),
                      child: CircleAvatar(
                        radius: 60,
                        backgroundColor: const Color(0xFFFFF5D7),
                        child: ClipOval(
                          child: Image.asset(
                            avatarPath,
                            width: 110,
                            height: 110,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 20),

                    // 👶 NAME
                    Text(
                      name,
                      style: GoogleFonts.baloo2(
                        fontSize: 28,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFF6B3A00),
                      ),
                    ),

                    const SizedBox(height: 6),

                    // 🎂 AGE
                    Text(
                      "$age Tahun",
                      style: GoogleFonts.baloo2(
                        fontSize: 18,
                        color: Colors.brown.withOpacity(0.7),
                      ),
                    ),

                    const Spacer(),

                    // ✅ TAMBAH / EDIT PROFIL
                    SizedBox(
                      width: 260,
                      height: 58,
                      child: GestureDetector(
                        onTap: () {
                          TapSound.play();

                          // ✅ IMPORTANT FIX
                          // DO NOT remove routes
                          Navigator.pushNamed(context, "/name");
                        },
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
                            "Tambah / Edit Profil",
                            style: GoogleFonts.baloo2(
                              fontSize: 20,
                              fontWeight: FontWeight.w700,
                              color: const Color(0xFF2E6B1F),
                            ),
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 16),

                    // ❌ PADAM PROFIL
                    SizedBox(
                      width: 260,
                      height: 58,
                      child: GestureDetector(
                        onTap: () {
                          TapSound.play();
                          _confirmDelete(context);
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
                            "Padam Profil",
                            style: GoogleFonts.baloo2(
                              fontSize: 20,
                              fontWeight: FontWeight.w700,
                              color: Colors.red.shade700,
                            ),
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ⚠️ CONFIRM DELETE DIALOG
  void _confirmDelete(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Padam Profil?"),
        content: const Text("Adakah anda pasti mahu padam profil ini?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Batal"),
          ),
          TextButton(
            onPressed: () {
              Hive.box('child').clear();

              // After delete, go to setup
              Navigator.pushNamedAndRemoveUntil(
                context,
                "/name",
                (route) => false,
              );
            },
            child: const Text(
              "Padam",
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }
}
