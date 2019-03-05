import 'dart:async';

import 'package:flipflop/models/category_view_model.dart';
import 'package:flipflop/models/word_view_model.dart';
import 'package:flipflop/repo/fb_db.dart';
import 'package:meta/meta.dart';

class FlipFlopApi {
  final FirebaseDB database;

  FlipFlopApi({
    @required this.database
  });

  Future<List<WordViewModel>> getCards({
    String category = "random",
    String filterBy = "popular"
  }) async {

    return await database
        .readByFilter("cards", "category:$category")
        .then((docs) {
          print("get Cards called");
          return docs.map((doc) => WordViewModel.fromJson(doc.data)).toList();
        });
  }

  Future<List<Category>> getCategories() async {
    return await database
          .read('categories')
          .then((docs) {
            print("get Categories called");
            return docs.map((doc) => Category.fromJson(doc.data)).toList();
          });

  }

}