import 'dart:async';
import 'dart:convert';
import 'package:flipflop/models/category_view_model.dart';
import 'package:flipflop/models/word_view_model.dart';
import 'package:http/http.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FlipFlopApi {
  static const String _baseUrl = 'https://';

  final Client _client = Client();

  Future<List<WordViewModel>> getCards({
    String category = "fruit",
    String filterBy = "popular"
  }) async {
    List<WordViewModel> cards = [];

    await Firestore.instance
        .collection('cards')
        .snapshots()
        .first
        .then((snapshot) => snapshot.documents)
        .then((docs) {
          docs.forEach((doc) => cards.add(WordViewModel.fromJson(doc.data)));
        });

    return cards;
  }

  Future<List<Category>> getCategories() async {
    List<Category> categories = [];

    await Firestore.instance
          .collection('category')
          .snapshots()
          .first
          .then((snapshot) => snapshot.documents)
          .then((docs) {
            docs.forEach((doc) => categories.add(Category.fromJson(doc.data)));
          });


    return categories;
  }

}