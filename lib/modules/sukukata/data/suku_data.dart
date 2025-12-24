// lib/modules/sukukata/data/suku_data.dart

class SukuStage {
  final String id;               // "BA"
  final String display;          // "BA"
  final List<String> letters;    // ["B","A"]
  final String audio;            // assets/audio/suku/ba.mp3
  final String promptAudio;      // assets/audio/suku_prompt/mana_ba.mp3
  final List<String> options;    // ["BA","BI","BU","BE","BO"]

  const SukuStage({
    required this.id,
    required this.display,
    required this.letters,
    required this.audio,
    required this.promptAudio,
    required this.options,
  });
}

/// vowels
const List<String> _vowels = ['a', 'i', 'u', 'e', 'o'];

/// consonants (BA → ZO = 105 stages)
const List<String> _consonants = [
  'b','c','d','f','g','h','j','k','l','m',
  'n','p','q','r','s','t','v','w','x','y','z'
];

/// 🔥 FULLY DYNAMIC STAGE LIST
final List<SukuStage> sukuStages = [
  for (final c in _consonants)
    for (final v in _vowels)
      SukuStage(
        id: (c + v).toUpperCase(),                       // BA
        display: (c + v).toUpperCase(),                  // BA
        letters: [c.toUpperCase(), v.toUpperCase()],     // ["B","A"]
        audio: 'assets/audio/suku/${c + v}.mp3',         // ba.mp3
        promptAudio:
            'assets/audio/suku_prompt/mana_${c + v}.mp3', // mana_ba.mp3
        options: _vowels
            .map((ov) => (c + ov).toUpperCase())
            .toList(),                                   // BA BI BU BE BO
      ),
];
