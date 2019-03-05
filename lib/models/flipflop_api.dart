import 'dart:async';
import 'package:flipflop/models/category_view_model.dart';
import 'package:flipflop/models/word_view_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FlipFlopApi {

  Future<List<WordViewModel>> getCards({
    String category = "random",
    String filterBy = "popular"
  }) async {

    return await Firestore.instance
        .collection('cards')
        .where("category", isEqualTo: category)
        .snapshots()
        .first
        .then((snapshot) => snapshot.documents)
        .then((docs) {
          print("get Cards called");
          return docs.map((doc) => WordViewModel.fromJson(doc.data)).toList();
        }).catchError((error) {
          print(error);
        });
  }

  Future<List<Category>> getCategories() async {

    return await Firestore.instance
          .collection('categories')
          .snapshots()
          .first
          .then((snapshot) => snapshot.documents)
          .then((docs) {
            print("get Categories called");
            return docs.map((doc) => Category.fromJson(doc.data)).toList();
          }).catchError((error) {
            print(error);
          });

  }

}