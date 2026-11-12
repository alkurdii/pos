/// The Kurdish (Arabic-script) alphabet, one entry per letter.
class KurdishLetter {
  const KurdishLetter(
    this.char,
    this.latin,
    this.word,
    this.picture, {
    this.joinsNext = true,
  });

  /// The letter itself, e.g. `پ`. `وو` is two characters but one letter.
  final String char;

  /// The matching letter in the Latin (Hawar) Kurdish alphabet.
  final String latin;

  /// An example word that contains the letter.
  final String word;

  /// An emoji that shows what [word] means.
  final String picture;

  /// Whether the letter connects to the letter after it.
  final bool joinsNext;

  /// True when [word] starts with this letter, so it makes a fair quiz question.
  bool get startsWord => word.startsWith(char);

  /// Position of the letter inside [word], or -1.
  int get indexInWord => word.indexOf(char);
}

const String tatweel = 'ـ';

/// One way of writing a letter, with its label in Kurdish.
class LetterForm {
  const LetterForm(this.label, this.text);
  final String label;
  final String text;
}

List<LetterForm> formsOf(KurdishLetter l) {
  final c = l.char;
  if (!l.joinsNext) {
    return [
      LetterForm('ب تنێ', c),
      LetterForm('دوماهی', '$tatweel$c'),
    ];
  }
  return [
    LetterForm('ب تنێ', c),
    LetterForm('دەسپێک', '$c$tatweel'),
    LetterForm('ناڤەراست', '$tatweel$c$tatweel'),
    LetterForm('دوماهی', '$tatweel$c'),
  ];
}

const List<KurdishLetter> kurdishLetters = [
  KurdishLetter('ئ', 'ʼ', 'ئاگر', '🔥'),
  KurdishLetter('ا', 'a', 'دار', '🌳', joinsNext: false),
  KurdishLetter('ب', 'b', 'بەرخ', '🐑'),
  KurdishLetter('پ', 'p', 'پیڤاز', '🧅'),
  KurdishLetter('ت', 't', 'تیر', '🏹'),
  KurdishLetter('ج', 'c', 'جل', '👕'),
  KurdishLetter('چ', 'ç', 'چاڤ', '👁️'),
  KurdishLetter('ح', 'ḧ', 'حەفت', '7️⃣'),
  KurdishLetter('خ', 'x', 'خانی', '🏠'),
  KurdishLetter('د', 'd', 'دەست', '✋', joinsNext: false),
  KurdishLetter('ر', 'r', 'باران', '🌧️', joinsNext: false),
  KurdishLetter('ڕ', 'rr', 'ڕێ', '🛣️', joinsNext: false),
  KurdishLetter('ز', 'z', 'زمان', '👅', joinsNext: false),
  KurdishLetter('ژ', 'j', 'ژن', '👩', joinsNext: false),
  KurdishLetter('س', 's', 'سێڤ', '🍎'),
  KurdishLetter('ش', 'ş', 'شێر', '🦁'),
  KurdishLetter('ع', '‛', 'عەرد', '🌍'),
  KurdishLetter('غ', 'ẍ', 'غەریب', '🧳'),
  KurdishLetter('ف', 'f', 'فیل', '🐘'),
  KurdishLetter('ڤ', 'v', 'ئاڤ', '💧'),
  KurdishLetter('ق', 'q', 'قاز', '🪿'),
  KurdishLetter('ک', 'k', 'کتێب', '📖'),
  KurdishLetter('گ', 'g', 'گول', '🌹'),
  KurdishLetter('ل', 'l', 'لێڤ', '👄'),
  KurdishLetter('ڵ', 'll', 'باڵندە', '🐦'),
  KurdishLetter('م', 'm', 'ماسی', '🐟'),
  KurdishLetter('ن', 'n', 'نان', '🍞'),
  KurdishLetter('و', 'w', 'وێنە', '🖼️', joinsNext: false),
  KurdishLetter('وو', 'û', 'دوو', '2️⃣', joinsNext: false),
  KurdishLetter('ۆ', 'o', 'شۆر', '🧂', joinsNext: false),
  KurdishLetter('ه', 'h', 'هەسپ', '🐎'),
  KurdishLetter('ە', 'e', 'بەفر', '❄️', joinsNext: false),
  KurdishLetter('ی', 'y / î', 'یەک', '1️⃣'),
  KurdishLetter('ێ', 'ê', 'سێ', '3️⃣'),
];

/// Groups of letters that look alike. The quiz uses them as tricky choices.
const List<List<String>> lookalikeGroups = [
  ['ب', 'پ', 'ت'],
  ['ج', 'چ', 'ح', 'خ'],
  ['ر', 'ڕ', 'ز', 'ژ'],
  ['س', 'ش'],
  ['ع', 'غ'],
  ['ف', 'ڤ', 'ق'],
  ['ک', 'گ'],
  ['ل', 'ڵ'],
  ['و', 'ۆ', 'وو'],
  ['ی', 'ێ'],
  ['ه', 'ە'],
];

/// Writes a number with Eastern Arabic digits, as Kurdish text does.
String kurdishDigits(int n) {
  const digits = '٠١٢٣٤٥٦٧٨٩';
  return n
      .toString()
      .split('')
      .map((d) => digits[int.parse(d)])
      .join();
}
