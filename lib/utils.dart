import 'package:flip/models/model.dart';

List<WordCard> applyFilter(String filter, List<WordCard> cards) {

  if(filter != 'all') {
    return cards.where((card) => card.category == filter).toList();
  }

  return cards;
}