import 'package:audioplayers/audioplayers.dart';

enum SoundType {
  pronounceUpper,
  pronounceLower,
  strokeCorrect,
  strokeWrong,
  letterSuccess,
}

class SoundPlayer {
  static final AudioPlayer _player = AudioPlayer();

  static Future<void> play({
    required SoundType type,
    String? letter,
  }) async {
    String path;

    switch (type) {
      case SoundType.pronounceUpper:
        path = "audio/letters/upper/$letter.mp3";
        break;
      case SoundType.pronounceLower:
        path = "audio/letters/lower/$letter.mp3";
        break;
      case SoundType.strokeCorrect:
        path = "audio/tracing/correct.mp3";
        break;
      case SoundType.strokeWrong:
        path = "audio/tracing/wrong.mp3";
        break;
      case SoundType.letterSuccess:
        path = "audio/tracing/success.mp3";
        break;
    }

    await _player.stop();
    await _player.play(AssetSource(path));
  }
}
