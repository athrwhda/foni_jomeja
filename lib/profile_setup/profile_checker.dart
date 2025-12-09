import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

class ProfileChecker extends StatelessWidget {
  const ProfileChecker({super.key});

  @override
  Widget build(BuildContext context) {
    final childBox = Hive.box('child');

    bool hasProfile =
        childBox.get('name') != null &&
        childBox.get('age') != null &&
        childBox.get('avatar') != null;

    // Automatically redirect:
    Future.microtask(() {
      if (hasProfile) {
        Navigator.pushReplacementNamed(context, '/home');
      } else {
        Navigator.pushReplacementNamed(context, '/name');
      }
    });

    return const Scaffold(
      body: Center(child: CircularProgressIndicator()),
    );
  }
}
