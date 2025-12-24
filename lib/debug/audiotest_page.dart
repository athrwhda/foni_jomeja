import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';

class AudioTestPage2 extends StatefulWidget {
  const AudioTestPage2({super.key});

  @override
  State<AudioTestPage2> createState() => _AudioTestPage2State();
}

class _AudioTestPage2State extends State<AudioTestPage2> {
  late final AudioPlayer _player;

  @override
  void initState() {
    super.initState();
    _player = AudioPlayer();
  }

  @override
  void dispose() {
    _player.dispose();
    super.dispose();
  }

  Future<void> _playA() async {
    try {
      await _player.stop();
      await _player.play(
        AssetSource('audio/audiohuruf/A.mp3'),
      );
    } catch (e) {
      debugPrint('PLAY ERROR: $e');
    }
  }

  Future<void> _playBA() async {
    try {
      await _player.stop();
      await _player.play(
        AssetSource('audio/suku_prompt/mana_ba.mp3'),
      );
    } catch (e) {
      debugPrint('PLAY ERROR: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Audio Test'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: _playA,
              child: const Text('Play A (audiohuruf)'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _playBA,
              child: const Text('Play BA (suku_prompt)'),
            ),
          ],
        ),
      ),
    );
  }
}
