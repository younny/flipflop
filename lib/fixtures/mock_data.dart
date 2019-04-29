import 'package:flipflop/models/korean.dart';
import 'package:flipflop/models/word_view_model.dart';

final mockCards = <WordViewModel>[
  Korean(
      word: '사과',
      meaning: 'Apple',
      created: DateTime.now().toIso8601String(),
  ),
  Korean(
      word: '포도',
      meaning: 'Grape',
      created: DateTime.now().toIso8601String(),
  ),
  Korean(
      word: '수박',
      meaning: 'Watermelon',
      created: DateTime.now().toIso8601String(),
  )
];