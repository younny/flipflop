import 'package:flip/models/model.dart';

List<WordViewModel> applyFilter(String filter, List<WordViewModel> cards) {

  if(filter != 'all') {
    return cards.where((card) => card.category == filter).toList();
  }

  return cards;
}

String meaningFormatter(String meaning) => ': $meaning';