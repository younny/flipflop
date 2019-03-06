import 'package:flipflop/models/category_view_model.dart';
import 'package:flipflop/models/flipflop_api.dart';
import 'package:flipflop/models/word_view_model.dart';
import 'package:rxdart/rxdart.dart';

class FlipFlopBloc {

  final FlipFlopApi api;

  BehaviorSubject<String> _category = BehaviorSubject<String>(seedValue: 'random');

  Sink<String> get category => _category;

  Stream<List<WordViewModel>> _cards = Stream.empty();

  Stream<List<WordViewModel>> get cards => _cards;

  Stream<List<Category>> _categories = Stream.empty();

  Stream<List<Category>> get categories => _categories;

  FlipFlopBloc(this.api) {
    _cards = _category
              .asyncMap((cat) => api.getCards(category: cat))
              .asBroadcastStream();

    _categories = Observable.defer(
        () => Observable.fromFuture(api.getCategories()).asBroadcastStream(),
        reusable: true
    );
  }

  void dispose() {
    print("Dispose of flipflop bloc.");
  }
}