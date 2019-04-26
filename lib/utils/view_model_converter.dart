import 'package:flipflop/constant/lang.dart';
import 'package:flipflop/models/db_columns.dart';
import 'package:flipflop/models/german.dart';
import 'package:flipflop/models/korean.dart';
import 'package:flipflop/models/word_view_model.dart';

WordViewModel convertMapToViewModel({
  String lang,
  Map map
}) {
  switch(lang ?? map[columnLang]) {
    case LangCode.GERMAN:
      return German.fromMap(map);
    default:
      return Korean.fromMap(map);
  }
}