import 'package:flip/utils/string_formatter.dart';
import 'package:meta/meta.dart';

class Meaning extends StringFormatter {
  Meaning({
    @required this.source
  });

  final String source;

  String get _source => source;

  @override
  String format() {
    return ': $_source';
  }

}