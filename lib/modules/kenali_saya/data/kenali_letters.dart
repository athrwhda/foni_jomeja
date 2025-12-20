class KenaliLetterData {
  final String letter;            // A
  final String syllable1;
  final String syllable2;         // YAM
  final String word;              // AYAM

  final String imagePath;         // assets/images/kenali/A.png

  // Audio (stage-specific)
  final String introAudio;        // "A"
  final String part1Audio;        // "Ini ayam"
  final String part2Audio;        // "A untuk ayam"
  final String wordAudio;         // "Ayam"

  // Drag & drop
  final List<String> correctLetters;   // [A, Y, A, M]
  final List<String> confuseLetters;   // for Screen 2

  //for character to highlight
  final int highlightCount;

  const KenaliLetterData({
    required this.letter,
    required this.syllable1,
    required this.syllable2,
    required this.word,
    required this.imagePath,
    required this.introAudio,
    required this.part1Audio,
    required this.part2Audio,
    required this.wordAudio,
    required this.correctLetters,
    required this.confuseLetters,
    required this.highlightCount,
  });
}

/// 🔤 ALL KENALI LETTER DATA

final List<KenaliLetterData> kenaliLetters = [
/// A 
  KenaliLetterData(
    letter: 'A',
    syllable1: 'A',
    syllable2: 'YAM',
    word: 'AYAM',

    imagePath: 'assets/images/kenali/A.png',

    // Audio (corrected structure)
    introAudio: 'assets/audio/kenali/A/intro.mp3',
    part1Audio: 'assets/audio/kenali/A/part1.mp3',
    part2Audio: 'assets/audio/kenali/A/part2.mp3',
    wordAudio: 'assets/audio/kenali/A/word.mp3',

    // Drag letters
    correctLetters: ['A', 'Y', 'A', 'M'],

    // Extra letters for confuse page (Screen 2)
    confuseLetters: ['A', 'Y', 'A', 'M', 'K', 'L', 'R', 'U', 'T', 'N'],

    highlightCount: 1,
  ),

  /// B 
  KenaliLetterData(
    letter: 'B',
    syllable1: 'BO',
    syllable2: 'LA',
    word: 'BOLA',

    imagePath: 'assets/images/kenali/B.png',

    // Audio (corrected structure)
    introAudio: 'assets/audio/kenali/B/intro.mp3',
    part1Audio: 'assets/audio/kenali/B/part1.mp3',
    part2Audio: 'assets/audio/kenali/B/part2.mp3',
    wordAudio: 'assets/audio/kenali/B/word.mp3',

    // Drag letters
    correctLetters: ['B', 'O', 'L', 'A'],
    // Extra letters for confuse page (Screen 2)
    confuseLetters: ['B', 'O', 'L', 'A', 'O', 'U', 'K', 'R', 'M', 'P'],

    highlightCount: 2,
  ),

  /// C
  KenaliLetterData(
    letter: 'C',
    syllable1: 'CA',
    syllable2: 'WAN',
    word: 'CAWAN',

    imagePath: 'assets/images/kenali/C.png',

    // Audio (corrected structure)
    introAudio: 'assets/audio/kenali/C/intro.mp3',
    part1Audio: 'assets/audio/kenali/C/part1.mp3',
    part2Audio: 'assets/audio/kenali/C/part2.mp3',
    wordAudio: 'assets/audio/kenali/C/word.mp3',

    // Drag letters
    correctLetters: ['C', 'A', 'W', 'A', 'N'],
    // Extra letters for confuse page (Screen 2)
    confuseLetters: ['C', 'A', 'W', 'A', 'N', 'B', 'D', 'R', 'Y', 'M'],

    highlightCount: 2,
  ),

  /// D
  KenaliLetterData(
    letter: 'D',
    syllable1: 'DA',
    syllable2: 'DU',
    word: 'DADU',

    imagePath: 'assets/images/kenali/D.png',

    // Audio (corrected structure)
    introAudio: 'assets/audio/kenali/D/intro.mp3',
    part1Audio: 'assets/audio/kenali/D/part1.mp3',
    part2Audio: 'assets/audio/kenali/D/part2.mp3',
    wordAudio: 'assets/audio/kenali/D/word.mp3',

    // Drag letters
    correctLetters: ['D', 'A', 'D', 'U'],
    // Extra letters for confuse page (Screen 2)
    confuseLetters: ['D', 'A', 'D', 'U', 'B', 'E', 'R', 'J', 'M', 'P'],

    highlightCount: 2,
  ),

  /// E
  KenaliLetterData(
    letter: 'E',
    syllable1: 'E',
    syllable2: 'PAL',
    word: 'EPAL',

    imagePath: 'assets/images/kenali/E.png',

    // Audio (corrected structure)
    introAudio: 'assets/audio/kenali/E/intro.mp3',
    part1Audio: 'assets/audio/kenali/E/part1.mp3',
    part2Audio: 'assets/audio/kenali/E/part2.mp3',
    wordAudio: 'assets/audio/kenali/E/word.mp3',

    // Drag letters
    correctLetters: ['E', 'P', 'A', 'L'],
    // Extra letters for confuse page (Screen 2)
    confuseLetters: ['E', 'P', 'A', 'L', 'A', 'D', 'O', 'J', 'M', 'P'],

    highlightCount: 2,
  ),

  /// F
  KenaliLetterData(
    letter: 'F',
    syllable1: 'FE',
    syllable2: 'RI',
    word: 'FERI',

    imagePath: 'assets/images/kenali/F.png',

    // Audio (corrected structure)
    introAudio: 'assets/audio/kenali/F/intro.mp3',
    part1Audio: 'assets/audio/kenali/F/part1.mp3',
    part2Audio: 'assets/audio/kenali/F/part2.mp3',
    wordAudio: 'assets/audio/kenali/F/word.mp3',

    // Drag letters
    correctLetters: ['F', 'E', 'R', 'I'],
    // Extra letters for confuse page (Screen 2)
    confuseLetters: ['F', 'E', 'R', 'I', 'A', 'D', 'U', 'L', 'E', 'W'],

    highlightCount: 2,
  ),

  /// G
  KenaliLetterData(
    letter: 'G',
    syllable1: 'GI',
    syllable2: 'GI',
    word: 'GIGI',

    imagePath: 'assets/images/kenali/G.png',

    // Audio (corrected structure)
    introAudio: 'assets/audio/kenali/G/intro.mp3',
    part1Audio: 'assets/audio/kenali/G/part1.mp3',
    part2Audio: 'assets/audio/kenali/G/part2.mp3',
    wordAudio: 'assets/audio/kenali/G/word.mp3',

    // Drag letters
    correctLetters: ['G', 'I', 'G', 'I'],
    // Extra letters for confuse page (Screen 2)
    confuseLetters: ['G', 'I', 'G', 'I', 'A', 'J', 'R', 'I', 'M', 'A'],

    highlightCount: 2,
  ),

];
