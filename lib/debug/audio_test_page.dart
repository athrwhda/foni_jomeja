import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';

class AudioTestPage extends StatelessWidget {
  final AudioPlayer player = AudioPlayer();

  AudioTestPage({super.key});

  Future<void> playTest() async {
    await player.stop();
    await player.play(
      AssetSource('audio/kenali/A/intro.mp3'),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ElevatedButton(
          onPressed: playTest,
          child: const Text('PLAY INTRO A'),
        ),
      ),
    );
  }
}
