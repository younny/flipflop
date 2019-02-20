class WordViewModel {
  final String word;
  final String meaning;
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
    meaning = json['meaning'],
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

final List<WordViewModel> mockCards = [
  WordViewModel(
    category: 'fruit',
    created: '14 Feb 2019',
    word: '사과',
    meaning: 'Apple',
    pronunciation: 'sa-g-wa',
    lang: 'ko'
  ),
  WordViewModel(
      category: 'fruit',
      created: '14 Feb 2019',
      word: '멜론',
      meaning: 'Melon',
      pronunciation: 'mael-ron',
      lang: 'ko'
  ),
  WordViewModel(
      category: 'fruit',
      created: '14 Feb 2019',
      word: '바나나',
      meaning: 'Banana',
      pronunciation: 'ba-na-na',
      lang: 'ko'
  ),
  WordViewModel(
      category: 'fruit',
      created: '14 Feb 2019',
      word: '키위',
      meaning: 'Kiwi',
      pronunciation: 'ki-wi',
      lang: 'ko'
  ),
  WordViewModel(
      category: 'fruit',
      created: '14 Feb 2019',
      word: '수박',
      meaning: 'Watermelon',
      pronunciation: 'soo-bak',
      lang: 'ko'
  ),
  WordViewModel(
      category: 'fruit',
      created: '14 Feb 2019',
      word: '포도',
      meaning: 'Grape',
      pronunciation: 'po-do',
      lang: 'ko'
  ),
  WordViewModel(
      category: 'fruit',
      created: '14 Feb 2019',
      word: '체리',
      meaning: 'Cherry',
      pronunciation: 'chae-lee',
      lang: 'ko'
  ),
  WordViewModel(
      category: 'fruit',
      created: '14 Feb 2019',
      word: '귤',
      meaning: 'Tangerin',
      pronunciation: 'gyu-eul',
      lang: 'ko'
  ),
  WordViewModel(
      category: 'fruit',
      created: '14 Feb 2019',
      word: '망고',
      meaning: 'Mango',
      pronunciation: 'mang-go',
      lang: 'ko'
  ),
  WordViewModel(
      category: 'fruit',
      created: '14 Feb 2019',
      word: '배',
      meaning: 'Pear',
      pronunciation: 'bae',
      lang: 'ko'
  )
];