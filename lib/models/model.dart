class WordViewModel {
  final String word;
  final String category;
  final String created;
  final String locale;

  WordViewModel({
    this.word,
    this.category,
    this.created,
    this.locale
  });

  WordViewModel.fromJson(Map json)
  : word = json['word'],
    category = json['catetory'],
    created = json['created'],
    locale = json['locale'];

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
    word: 'Apple',
    locale: 'en'
  ),
  WordViewModel(
      category: 'fruit',
      created: '14 Feb 2019',
      word: 'Melon',
      locale: 'en'
  ),
  WordViewModel(
      category: 'fruit',
      created: '14 Feb 2019',
      word: 'Banana',
      locale: 'en'
  ),
  WordViewModel(
      category: 'fruit',
      created: '14 Feb 2019',
      word: 'Orange',
      locale: 'en'
  ),
  WordViewModel(
      category: 'fruit',
      created: '14 Feb 2019',
      word: 'Kiwi',
      locale: 'en'
  ),
  WordViewModel(
      category: 'fruit',
      created: '14 Feb 2019',
      word: 'Grape',
      locale: 'en'
  )
];