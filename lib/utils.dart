import 'package:flip/models/word_view_model.dart';

List<WordViewModel> applyFilter(String filter, List<WordViewModel> cards) {

  if(filter != 'all') {
    return cards.where((card) => card.category == filter).toList();
  }

  return cards;
}

