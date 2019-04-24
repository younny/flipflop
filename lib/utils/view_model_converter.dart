import 'package:flipflop/models/german.dart';
import 'package:flipflop/models/korean.dart';
import 'package:flipflop/models/word_view_model.dart';

WordViewModel convertMapToViewModel({
  String lang,
  Map map
}) {
  switch(lang ?? map['lang']) {
    case 'de':
      return German.fromMap(map);
    default:
      return Korean.fromMap(map);
  }
}