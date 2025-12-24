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

    highlightCount: 1,
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

  /// H
  KenaliLetterData(
    letter: 'H',
    syllable1: 'HU',
    syllable2: 'TAN',
    word: 'HUTAN',

    imagePath: 'assets/images/kenali/H.png',

    // Audio (corrected structure)
    introAudio: 'assets/audio/kenali/H/intro.mp3',
    part1Audio: 'assets/audio/kenali/H/part1.mp3',
    part2Audio: 'assets/audio/kenali/H/part2.mp3',
    wordAudio: 'assets/audio/kenali/H/word.mp3',

    // Drag letters
    correctLetters: ['H', 'U', 'T', 'A', 'N'],
    // Extra letters for confuse page (Screen 2)
    confuseLetters: ['H', 'U', 'T', 'A', 'N', 'U', 'G', 'F', 'I', 'M', 'A'],

    highlightCount: 2,
  ),

  /// I
  KenaliLetterData(
    letter: 'I',
    syllable1: 'I',
    syllable2: 'TIK',
    word: 'ITIK',

    imagePath: 'assets/images/kenali/I.png',

    // Audio (corrected structure)
    introAudio: 'assets/audio/kenali/I/intro.mp3',
    part1Audio: 'assets/audio/kenali/I/part1.mp3',
    part2Audio: 'assets/audio/kenali/I/part2.mp3',
    wordAudio: 'assets/audio/kenali/I/word.mp3',

    // Drag letters
    correctLetters: ['I', 'T', 'I', 'K'],
    // Extra letters for confuse page (Screen 2)
    confuseLetters: ['I', 'T', 'I', 'K', 'O', 'J', 'P', 'I', 'M', 'A'],

    highlightCount: 1,
  ),
  
  /// J
  KenaliLetterData(
    letter: 'J',
    syllable1: 'JA',
    syllable2: 'RI',
    word: 'JARI',

    imagePath: 'assets/images/kenali/J.png',

    // Audio (corrected structure)
    introAudio: 'assets/audio/kenali/J/intro.mp3',
    part1Audio: 'assets/audio/kenali/J/part1.mp3',
    part2Audio: 'assets/audio/kenali/J/part2.mp3',
    wordAudio: 'assets/audio/kenali/J/word.mp3',

    // Drag letters
    correctLetters: ['J', 'A', 'R', 'I'],
    // Extra letters for confuse page (Screen 2)
    confuseLetters: ['J', 'A', 'R', 'I', 'U', 'E', 'H', 'I', 'M', 'A'],

    highlightCount: 2,
  ),

  /// K
  KenaliLetterData(
    letter: 'K',
    syllable1: 'KA',
    syllable2: 'TAK',
    word: 'KATAK',

    imagePath: 'assets/images/kenali/K.png',

    // Audio (corrected structure)
    introAudio: 'assets/audio/kenali/K/intro.mp3',
    part1Audio: 'assets/audio/kenali/K/part1.mp3',
    part2Audio: 'assets/audio/kenali/K/part2.mp3',
    wordAudio: 'assets/audio/kenali/K/word.mp3',

    // Drag letters
    correctLetters: ['K', 'A', 'T', 'A', 'K'],
    // Extra letters for confuse page (Screen 2)
    confuseLetters: ['K', 'A', 'T', 'A', 'K', 'A', 'B', 'U', 'I', 'M'],

    highlightCount: 2,
  ),

  /// L
  KenaliLetterData(
    letter: 'L',
    syllable1: 'LAM',
    syllable2: 'PU',
    word: 'LAMPU',

    imagePath: 'assets/images/kenali/L.png',

    // Audio (corrected structure)
    introAudio: 'assets/audio/kenali/L/intro.mp3',
    part1Audio: 'assets/audio/kenali/L/part1.mp3',
    part2Audio: 'assets/audio/kenali/L/part2.mp3',
    wordAudio: 'assets/audio/kenali/L/word.mp3',

    // Drag letters
    correctLetters: ['L', 'A', 'M', 'P', 'U'],
    // Extra letters for confuse page (Screen 2)
    confuseLetters: ['L', 'A', 'M', 'P', 'U', 'A', 'T', 'U', 'I', 'C'],

    highlightCount: 3,
  ),

  /// M
  KenaliLetterData(
    letter: 'M',
    syllable1: 'ME',
    syllable2: 'JA',
    word: 'MEJA',

    imagePath: 'assets/images/kenali/M.png',

    // Audio (corrected structure)
    introAudio: 'assets/audio/kenali/M/intro.mp3',
    part1Audio: 'assets/audio/kenali/M/part1.mp3',
    part2Audio: 'assets/audio/kenali/M/part2.mp3',
    wordAudio: 'assets/audio/kenali/M/word.mp3',

    // Drag letters
    correctLetters: ['M', 'E', 'J', 'A'],
    // Extra letters for confuse page (Screen 2)
    confuseLetters: ['M', 'E', 'J', 'A', 'U', 'G', 'I', 'A', 'J', 'R'],

    highlightCount: 2,
  ),

  /// N
  KenaliLetterData(
    letter: 'N',
    syllable1: 'NA',
    syllable2: 'SI',
    word: 'NASI',

    imagePath: 'assets/images/kenali/N.png',

    // Audio (corrected structure)
    introAudio: 'assets/audio/kenali/N/intro.mp3',
    part1Audio: 'assets/audio/kenali/N/part1.mp3',
    part2Audio: 'assets/audio/kenali/N/part2.mp3',
    wordAudio: 'assets/audio/kenali/N/word.mp3',

    // Drag letters
    correctLetters: ['N', 'A', 'S', 'I'],
    // Extra letters for confuse page (Screen 2)
    confuseLetters: ['N', 'A', 'S', 'I', 'U', 'F', 'I', 'A', 'M', 'D'],

    highlightCount: 2,
  ),

  /// O
  KenaliLetterData(
    letter: 'O',
    syllable1: 'O',
    syllable2: 'REN',
    word: 'OREN',

    imagePath: 'assets/images/kenali/O.png',

    // Audio (corrected structure)
    introAudio: 'assets/audio/kenali/O/intro.mp3',
    part1Audio: 'assets/audio/kenali/O/part1.mp3',
    part2Audio: 'assets/audio/kenali/O/part2.mp3',
    wordAudio: 'assets/audio/kenali/O/word.mp3',

    // Drag letters
    correctLetters: ['O', 'R', 'E', 'N'],
    // Extra letters for confuse page (Screen 2)
    confuseLetters: ['O', 'R', 'E', 'N', 'A', 'V', 'W', 'I', 'M', 'A'],

    highlightCount: 1,
  ),

  /// P
  KenaliLetterData(
    letter: 'P',
    syllable1: 'PA',
    syllable2: 'SU',
    word: 'PASU',

    imagePath: 'assets/images/kenali/P.png',

    // Audio (corrected structure)
    introAudio: 'assets/audio/kenali/P/intro.mp3',
    part1Audio: 'assets/audio/kenali/P/part1.mp3',
    part2Audio: 'assets/audio/kenali/P/part2.mp3',
    wordAudio: 'assets/audio/kenali/P/word.mp3',

    // Drag letters
    correctLetters: ['P', 'A', 'S', 'U'],
    // Extra letters for confuse page (Screen 2)
    confuseLetters: ['P', 'A', 'S', 'U', 'A', 'B', 'T', 'I', 'M', 'A'],

    highlightCount: 2,
  ),

  /// Q
  KenaliLetterData(
    letter: 'Q',
    syllable1: 'QU',
    syllable2: 'RAN',
    word: 'QURAN',

    imagePath: 'assets/images/kenali/Q.png',

    // Audio (corrected structure)
    introAudio: 'assets/audio/kenali/Q/intro.mp3',
    part1Audio: 'assets/audio/kenali/Q/part1.mp3',
    part2Audio: 'assets/audio/kenali/Q/part2.mp3',
    wordAudio: 'assets/audio/kenali/Q/word.mp3',

    // Drag letters
    correctLetters: ['Q', 'U', 'R', 'A', 'N'],
    // Extra letters for confuse page (Screen 2)
    confuseLetters: ['Q', 'U', 'R', 'A', 'N', 'O', 'F', 'N', 'I', 'Z'],

    highlightCount: 2,
  ),

  /// R
  KenaliLetterData(
    letter: 'R',
    syllable1: 'RO',
    syllable2: 'TI',
    word: 'ROTI',

    imagePath: 'assets/images/kenali/R.png',

    // Audio (corrected structure)
    introAudio: 'assets/audio/kenali/R/intro.mp3',
    part1Audio: 'assets/audio/kenali/R/part1.mp3',
    part2Audio: 'assets/audio/kenali/R/part2.mp3',
    wordAudio: 'assets/audio/kenali/R/word.mp3',

    // Drag letters
    correctLetters: ['R', 'O', 'T', 'I'],
    // Extra letters for confuse page (Screen 2)
    confuseLetters: ['R', 'O', 'T', 'I', 'A', 'X', 'E', 'I', 'M', 'K'],

    highlightCount: 2,
  ),

  /// S
  KenaliLetterData(
    letter: 'S',
    syllable1: 'SU',
    syllable2: 'SU',
    word: 'SUSU',

    imagePath: 'assets/images/kenali/S.png',

    // Audio (corrected structure)
    introAudio: 'assets/audio/kenali/S/intro.mp3',
    part1Audio: 'assets/audio/kenali/S/part1.mp3',
    part2Audio: 'assets/audio/kenali/S/part2.mp3',
    wordAudio: 'assets/audio/kenali/S/word.mp3',

    // Drag letters
    correctLetters: ['S', 'U', 'S', 'U'],
    // Extra letters for confuse page (Screen 2)
    confuseLetters: ['S', 'U', 'S', 'U', 'O', 'J', 'O', 'I', 'M', 'A'],

    highlightCount: 2,
  ),

  /// T
  KenaliLetterData(
    letter: 'T',
    syllable1: 'TA',
    syllable2: 'LI',
    word: 'TALI',

    imagePath: 'assets/images/kenali/T.png',

    // Audio (corrected structure)
    introAudio: 'assets/audio/kenali/T/intro.mp3',
    part1Audio: 'assets/audio/kenali/T/part1.mp3',
    part2Audio: 'assets/audio/kenali/T/part2.mp3',
    wordAudio: 'assets/audio/kenali/T/word.mp3',

    // Drag letters
    correctLetters: ['T', 'A', 'L', 'I'],
    // Extra letters for confuse page (Screen 2)
    confuseLetters: ['T', 'A', 'L', 'I', 'P', 'J', 'R', 'I', 'M', 'A'],

    highlightCount: 2,
  ),

  /// U
  KenaliLetterData(
    letter: 'U',
    syllable1: 'U',
    syllable2: 'LAR',
    word: 'ULAR',

    imagePath: 'assets/images/kenali/U.png',

    // Audio (corrected structure)
    introAudio: 'assets/audio/kenali/U/intro.mp3',
    part1Audio: 'assets/audio/kenali/U/part1.mp3',
    part2Audio: 'assets/audio/kenali/U/part2.mp3',
    wordAudio: 'assets/audio/kenali/U/word.mp3',

    // Drag letters
    correctLetters: ['U', 'L', 'A', 'R'],
    // Extra letters for confuse page (Screen 2)
    confuseLetters: ['U', 'L', 'A', 'R', 'A', 'J', 'R', 'I', 'M', 'A'],

    highlightCount: 2,
  ),

  /// V
  KenaliLetterData(
    letter: 'V',
    syllable1: 'V',
    syllable2: 'AN',
    word: 'VAN',

    imagePath: 'assets/images/kenali/V.png',

    // Audio (corrected structure)
    introAudio: 'assets/audio/kenali/V/intro.mp3',
    part1Audio: 'assets/audio/kenali/V/part1.mp3',
    part2Audio: 'assets/audio/kenali/V/part2.mp3',
    wordAudio: 'assets/audio/kenali/V/word.mp3',

    // Drag letters
    correctLetters: ['V', 'A', 'N'],
    // Extra letters for confuse page (Screen 2)
    confuseLetters: ['V', 'A', 'N', 'W', 'J', 'Q', 'I', 'M', 'A'],

    highlightCount: 1,
  ),

  /// W
  KenaliLetterData(
    letter: 'W',
    syllable1: 'W',
    syllable2: 'AU',
    word: 'WAU',

    imagePath: 'assets/images/kenali/W.png',

    // Audio (corrected structure)
    introAudio: 'assets/audio/kenali/W/intro.mp3',
    part1Audio: 'assets/audio/kenali/W/part1.mp3',
    part2Audio: 'assets/audio/kenali/W/part2.mp3',
    wordAudio: 'assets/audio/kenali/W/word.mp3',

    // Drag letters
    correctLetters: ['W', 'A', 'U'],
    // Extra letters for confuse page (Screen 2)
    confuseLetters: ['W', 'A', 'U', 'V', 'J', 'J', 'I', 'M', 'A'],

    highlightCount: 1,
  ),

  /// X
  KenaliLetterData(
    letter: 'X',
    syllable1: 'X',
    syllable2: 'RAY',
    word: 'X-RAY',

    imagePath: 'assets/images/kenali/X.png',

    // Audio (corrected structure)
    introAudio: 'assets/audio/kenali/X/intro.mp3',
    part1Audio: 'assets/audio/kenali/X/part1.mp3',
    part2Audio: 'assets/audio/kenali/X/part2.mp3',
    wordAudio: 'assets/audio/kenali/X/word.mp3',

    // Drag letters
    correctLetters: ['X', 'R', 'A', 'Y'],
    // Extra letters for confuse page (Screen 2)
    confuseLetters: ['X', 'R', 'A', 'Y', 'V', 'Z', 'R', 'I', 'M', 'A'],

    highlightCount: 1,
  ),

  /// Y
  KenaliLetterData(
    letter: 'Y',
    syllable1: 'YO',
    syllable2: 'YO',
    word: 'YOYO',

    imagePath: 'assets/images/kenali/Y.png',

    // Audio (corrected structure)
    introAudio: 'assets/audio/kenali/Y/intro.mp3',
    part1Audio: 'assets/audio/kenali/Y/part1.mp3',
    part2Audio: 'assets/audio/kenali/Y/part2.mp3',
    wordAudio: 'assets/audio/kenali/Y/word.mp3',

    // Drag letters
    correctLetters: ['Y', 'O', 'Y', 'O'],
    // Extra letters for confuse page (Screen 2)
    confuseLetters: ['Y', 'O', 'Y', 'O', 'A', 'V', 'R', 'V', 'M', 'A'],

    highlightCount: 2,
  ),

  /// Z
  KenaliLetterData(
    letter: 'Z',
    syllable1: 'ZEB',
    syllable2: 'RA',
    word: 'ZEBRA',

    imagePath: 'assets/images/kenali/Z.png',

    // Audio (corrected structure)
    introAudio: 'assets/audio/kenali/Z/intro.mp3',
    part1Audio: 'assets/audio/kenali/Z/part1.mp3',
    part2Audio: 'assets/audio/kenali/Z/part2.mp3',
    wordAudio: 'assets/audio/kenali/Z/word.mp3',

    // Drag letters
    correctLetters: ['Z', 'E', 'B', 'R', 'A'],
    // Extra letters for confuse page (Screen 2)
    confuseLetters: ['Z', 'E', 'B', 'R', 'A', 'A', 'G', 'F', 'I', 'M', 'A'],

    highlightCount: 3,
  ),
];
