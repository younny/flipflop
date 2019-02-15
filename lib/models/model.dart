class WordViewModel {
  final String word;
  final String meaning;
  final String category;
  final String created;
  final String locale;

  WordViewModel({
    this.word,
    this.meaning,
    this.category,
    this.created,
    this.locale
  });

  WordViewModel.fromJson(Map json)
  : word = json['word'],
    meaning = json['meaning'],
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
    meaning: 'An apple is a sweet, edible fruit produced by an apple tree. '
        'Apple trees are cultivated woworldwideworldwideworldwideworldwiderldwidewoworldwideworldwideworldwideworldwiderldwidewoworldwideworldwideworldwideworldwiderldwidewoworldwideworldwideworldwideworldwiderldwidewoworldwideworldwideworldwideworldwiderldwidewoworldwideworldwideworldwideworldwiderldwide and are the most widely grown species in the genus Malus. '
        'The tree originated in Central Asia, where its wild ancestor, Malus sieversii, is still found today.',
    locale: 'en'
  ),
  WordViewModel(
      category: 'fruit',
      created: '14 Feb 2019',
      word: 'Melon',
      meaning: 'An apple is a sweet, edible fruit produced by an apple tree. '
          'Apple trees are cultivated worldwide and are the most widely grown species in the genus Malus. '
          'The tree originated in Central Asia, where its wild ancestor, Malus sieversii, is still found today.',
      locale: 'en'
  ),
  WordViewModel(
      category: 'fruit',
      created: '14 Feb 2019',
      word: 'Banana',
      meaning: 'An apple is a sweet, edible fruit produced by an apple tree. '
          'Apple trees are cultivated worldwide and are the most widely grown species in the genus Malus. '
          'The tree originated in Central Asia, where its wild ancestor, Malus sieversii, is still found today.',
      locale: 'en'
  ),
  WordViewModel(
      category: 'fruit',
      created: '14 Feb 2019',
      word: 'Orange',
      meaning: 'An apple is a sweet, edible fruit produced by an apple tree. '
          'Apple trees are cultivated worldwide and are the most widely grown species in the genus Malus. '
          'The tree originated in Central Asia, where its wild ancestor, Malus sieversii, is still found today.',
      locale: 'en'
  ),
  WordViewModel(
      category: 'fruit',
      created: '14 Feb 2019',
      word: 'Kiwi',
      meaning: 'An apple is a sweet, edible fruit produced by an apple tree. '
          'Apple trees are cultivated worldwide and are the most widely grown species in the genus Malus. '
          'The tree originated in Central Asia, where its wild ancestor, Malus sieversii, is still found today.',
      locale: 'en'
  ),
  WordViewModel(
      category: 'fruit',
      created: '14 Feb 2019',
      word: 'Grape',
      meaning: 'An apple is a sweet, edible fruit produced by an apple tree. '
          'Apple trees are cultivated worldwide and are the most widely grown species in the genus Malus. '
          'The tree originated in Central Asia, where its wild ancestor, Malus sieversii, is still found today.',
      locale: 'en'
  )
];