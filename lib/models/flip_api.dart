import 'dart:async';
import 'dart:convert';
import 'package:flip/models/model.dart';
import 'package:http/http.dart';

class FlipApi {
  static const String _baseUrl = 'https://';

  final Client _client = Client();

  Future<List<Category>> getCategories() async {
    List<Category> categories = [];

    await _client.get(Uri.parse(_baseUrl))
        .then((response) => response.body)
        .then(json.decode)
        .then((json) => json.forEach((categoryJson) {
          Category category = Category.fromJson(categoryJson);
          categories.add(category);
    }));

    return categories;
  }

  Future<List<WordViewModel>> getCards({
    String category = "celabrity",
    String filterBy = "popular"
  }) async {
    List<WordViewModel> cards = [];

    await _client.get(Uri.parse(_baseUrl))
    .then((response) => response.body)
    .then(json.decode)
    .then((json) => json.forEach((cardJson) {
      WordViewModel card = WordViewModel.fromJson(cardJson);

      cards.add(card);
    }));

    return cards;
  }
}