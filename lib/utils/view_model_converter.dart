import 'package:flipflop/models/german.dart';
import 'package:flipflop/models/korean.dart';
import 'package:flipflop/models/word_view_model.dart';

WordViewModel convertMapToViewModel(String lang, Map data) {
  switch(lang) {
    case 'ko':
      return Korean.fromMap(data);
    case 'de':
      return German.fromMap(data);
    default:
      return null;
  }
}