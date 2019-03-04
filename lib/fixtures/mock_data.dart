import 'package:flipflop/models/category_view_model.dart';
import 'package:flipflop/models/word_view_model.dart';

final mockCards = <WordViewModel>[
  WordViewModel(
      word: '사과',
      meaning: 'Apple',
      pronunciation: 'sa-g-wa',
      created: '27 Feb 2019',
      category: 'fruit'
  ),
  WordViewModel(
      word: '포도',
      meaning: 'Grape',
      pronunciation: 'po-do',
      created: '27 Feb 2019',
      category: 'fruit'
  ),
  WordViewModel(
      word: '수박',
      meaning: 'Watermelon',
      pronunciation: 'soo-bak',
      created: '27 Feb 2019',
      category: 'fruit'
  )
];

final categories = [
  Category(
    name: 'fruit',
    created: '27 Feb 2019'
  )
];