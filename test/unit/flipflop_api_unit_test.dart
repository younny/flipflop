import 'package:flipflop/models/flipflop_api.dart';
import 'package:flipflop/models/word_view_model.dart';
import 'package:test/test.dart';

void main() {
  test("load all cards list successfully", () async {

    List<WordViewModel> cards;

    cards = await FlipFlopApi().getCards();

    expect(cards, isNotNull);

    expect(cards, isNotEmpty);
  });
//
//  test("load all cards list failed", () async {
//    List<WordViewModel> cards;
//
//    cards = await FlipApi().getCards();
//
//    expect(cards, isNotNull);
//
//    expect(cards, isEmpty);
//  });
//
//  test("load cards list with certain category only", () async {
//    List<WordViewModel> cards;
//
//    cards = await FlipApi().getCards(category: 'fruit');
//
//    expect(cards, isNotNull);
//
//
//  });
//
//  test("load cards list with certain category only failed", () async {
//    List<WordViewModel> cards;
//
//    cards = await FlipApi().getCards(category: 'fruit');
//
//    expect(cards, isNotNull);
//
//    expect(cards, isEmpty);
//
//  });
//
//  test("load all categories successfully", () async {
//    List<Category> categories;
//
//    categories = await FlipApi().getCategories();
//
//    expect(categories, isNotNull);
//
//  });
//
//  test("load all categories failed", () async {
//    List<Category> categories;
//
//    categories = await FlipApi().getCategories();
//
//    expect(categories, isNotNull);
//
//    expect(categories, isEmpty);
//  });
}