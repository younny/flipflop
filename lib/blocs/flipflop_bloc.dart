import 'package:flipflop/models/flipflop_api.dart';
import 'package:flipflop/models/word_view_model.dart';

class FlipFlopBloc {

  final FlipFlopApi api;

  Stream<List<WordViewModel>> _cards = Stream.empty();

  Stream<List<WordViewModel>> get cards => _cards;

  FlipFlopBloc(this.api) {

  }

  void dispose() {

  }
}