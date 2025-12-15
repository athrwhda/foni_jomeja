import 'package:just_audio/just_audio.dart';

class BgMusic {
  static final AudioPlayer _player = AudioPlayer();
  static bool _started = false;
  static bool _muted = false;

  static bool get isMuted => _muted;

  static Future<void> start() async {
    if (_started) return;

    await _player.setLoopMode(LoopMode.one);

    await _player.setAsset(
      'assets/audio/sound/playful_learning.mp3',
    );

    await _player.setVolume(0.25);
    await _player.play();

    _started = true;
  }

  /// 🔇 Mute = volume 0 (DO NOT pause)
  static Future<void> mute() async {
    _muted = true;
    await _player.setVolume(0.0);
  }

  /// 🔊 Unmute = restore volume
  static Future<void> unmute() async {
    _muted = false;
    await _player.setVolume(0.25);
  }

  /// Optional (Parent Gate)
  static Future<void> stop() async {
    _started = false;
    await _player.stop();
  }
}
