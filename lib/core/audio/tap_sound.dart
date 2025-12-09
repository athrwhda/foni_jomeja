import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/services.dart';

class TapSound {
  static final AudioPlayer _player = AudioPlayer()
    ..setReleaseMode(ReleaseMode.stop);

  static Future<void> preload() async {
    // Preload for instant playback
    await _player.setSource(AssetSource("audio/ball_tap.wav"));
  }

  static Future<void> play() async {
    try {
      HapticFeedback.lightImpact();

      // Restart from start every tap
      await _player.stop();
      await _player.resume();
    } catch (e) {
      print("Tap sound error: $e");
    }
  }
}
