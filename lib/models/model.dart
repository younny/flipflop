import 'package:flip/models/meaning.dart';

class WordViewModel {
  final String word;
  final Meaning meaning;
  final String pronunciation;
  final String category;
  final String created;
  final String lang;

  WordViewModel({
    this.word,
    this.meaning,
    this.pronunciation,
    this.category,
    this.created,
    this.lang
  });

  WordViewModel.fromJson(Map json)
  : word = json['word'],
    meaning = Meaning(source: json['meaning']),
    pronunciation = json['pronunciation'],
    category = json['catetory'],
    created = json['created'],
    lang = json['lang'];

}

class Category {
  final String name;
  final String created;

  Category({
    this.name,
    this.created
  });

  Category.fromJson(Map json)
  : name = json['name'],
    created = json['created'];
}

final List<Category> mockCategories = [
  Category(
    name: 'food',
    created: '20 Feb 2019'
  ),
  Category(
    name: 'emotion',
    created: '20 Feb 2019'
  ),
  Category(
    name: 'transportation',
    created: '20 Feb 2019'
  ),
  Category(
    name: 'greetings',
    created: '20 Feb 2019'
  ),
  Category(
    name: 'hipster',
    created: '20 Feb 2019'
  ),
  Category(
    name: 'random',
    created: '20 Feb 2019'
  )
];

final List<WordViewModel> mockCards = [
  WordViewModel(
    category: 'fruit',
    created: '14 Feb 2019',
    word: '사과',
    meaning: Meaning(source: 'Apple'),
    pronunciation: 'sa-g-wa',
    lang: 'ko'
  ),
  WordViewModel(
      category: 'fruit',
      created: '14 Feb 2019',
      word: '멜론',
      meaning: Meaning(source: 'Melon'),
      pronunciation: 'mael-ron',
      lang: 'ko'
  ),
  WordViewModel(
      category: 'fruit',
      created: '14 Feb 2019',
      word: '바나나',
      meaning: Meaning(source: 'Banana'),
      pronunciation: 'ba-na-na',
      lang: 'ko'
  ),
  WordViewModel(
      category: 'fruit',
      created: '14 Feb 2019',
      word: '키위',
      meaning: Meaning(source: 'Kiwi'),
      pronunciation: 'ki-wi',
      lang: 'ko'
  ),
  WordViewModel(
      category: 'fruit',
      created: '14 Feb 2019',
      word: '수박',
      meaning: Meaning(source: 'Watermelon'),
      pronunciation: 'soo-bak',
      lang: 'ko'
  ),
  WordViewModel(
      category: 'fruit',
      created: '14 Feb 2019',
      word: '포도',
      meaning: Meaning(source: 'Grape'),
      pronunciation: 'po-do',
      lang: 'ko'
  ),
  WordViewModel(
      category: 'fruit',
      created: '14 Feb 2019',
      word: '체리',
      meaning: Meaning(source: 'Cherry'),
      pronunciation: 'chae-lee',
      lang: 'ko'
  ),
  WordViewModel(
      category: 'fruit',
      created: '14 Feb 2019',
      word: '귤',
      meaning: Meaning(source: 'Tangerin'),
      pronunciation: 'gyu-eul',
      lang: 'ko'
  ),
  WordViewModel(
      category: 'fruit',
      created: '14 Feb 2019',
      word: '망고',
      meaning: Meaning(source: 'Mango'),
      pronunciation: 'mang-go',
      lang: 'ko'
  ),
  WordViewModel(
      category: 'fruit',
      created: '14 Feb 2019',
      word: '배',
      meaning: Meaning(source: 'Pear'),
      pronunciation: 'bae',
      lang: 'ko'
  )
];