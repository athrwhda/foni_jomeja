import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:foni_jomeja/core/audio/tap_sound.dart';

// Onboarding
import 'onboarding/splash1.dart';
import 'onboarding/splash2.dart';

// Profile setup
import 'profile_setup/profile_checker.dart';
import 'profile_setup/name.dart';
import 'profile_setup/age.dart';
import 'profile_setup/avatar.dart';

// Home
import 'home/home_page.dart';
import 'home/profile_page.dart';
import 'home/parent_gate.dart';


// Modules
import 'modules/abjad/abjadhome.dart';
import 'modules/kenali_saya/kenalihome.dart';
import 'modules/sukukata/sukuhome.dart';
import 'modules/permainan/gamehome.dart';

// Debug
import 'package:foni_jomeja/debug/audio_test_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await TapSound.preload();
  await Hive.initFlutter();

  // Create and open all boxes
  await Hive.openBox('child');
  await Hive.openBox('settings');
  await Hive.openBox('progress');
  await Hive.openBox('scores');

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,

      // First screen ALWAYS → splash1
      initialRoute: '/splash1', //debug

      routes: {
        //Debug
        '/debug' : (_) => AudioTestPage(),

        // Onboarding
        '/splash1': (_) => const Splash1(),
        '/splash2': (_) => const Splash2(),

        // Profile checking screen
        '/profileCheck': (_) => const ProfileChecker(),

        // Profile setup screens
        '/name': (_) => const NameScreen(),
        '/age': (_) => const AgePage(),
        '/avatar': (_) => const AvatarPage(),

        // Home
        '/home': (_) => const HomePage(),
        '/parentGate': (_) => const ParentGatePage(),
        '/profiles': (_) => const ProfilePage(),


        // Modules
        "/abjad": (context) => const AbjadHomePage(),
        "/kenali": (context) => const KenaliHome(),
        "/suku": (context) => const SukuHome(),
        "/main": (context) => const GameHome(),
      },
    );
  }
}
