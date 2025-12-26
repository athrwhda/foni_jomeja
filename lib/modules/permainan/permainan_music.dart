import 'package:audioplayers/audioplayers.dart';

class PermainanMusic {
  static final PermainanMusic _instance = PermainanMusic._internal();
  factory PermainanMusic() => _instance;
  PermainanMusic._internal();

  final AudioPlayer _player = AudioPlayer();
  bool _isMuted = false;
  bool _initialized = false;

  bool get isMuted => _isMuted;

  Future<void> init() async {
  await _player.setReleaseMode(ReleaseMode.loop);
  await _player.setVolume(0.6);

  // ▶️ If first time ever
  if (!_initialized) {
    await _player.play(
      AssetSource('audio/sound/bright_adventure.mp3'),
    );
    _initialized = true;
    return;
  }

  // 🔁 If already initialized but NOT muted → resume
  if (!_isMuted) {
    await _player.resume();
  }
}


  Future<void> toggle() async {
    if (_isMuted) {
      await _player.play(
        AssetSource('audio/sound/bright_adventure.mp3'),
        volume: 0.6,
      );
    } else {
      await _player.pause();
    }
    _isMuted = !_isMuted;
  }

  void dispose() {
    _player.stop();
    _player.dispose();
    _initialized = false;
    _isMuted = false;
  }
}
