import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flipflop/models/category_view_model.dart';
import 'package:flipflop/models/word_view_model.dart';
import 'package:flipflop/repo/firestore_repository.dart';
import 'package:rxdart/rxdart.dart';

class FlipFlopBloc {

  final FirestoreRepository _firestoreRepository;

  String _level = "0";

  String get level => _level;

  set setLevel(String level) => _level = level;

  String _lang = "ko";

  String get lang => _lang;

  set setLang(String lang) => _lang = lang;

  BehaviorSubject<String> _category = BehaviorSubject<String>(seedValue: 'animal');

  Sink<String> get category => _category;

  Stream<List<WordViewModel>> _cards = Stream.empty();

  Stream<List<WordViewModel>> get cards => _cards;

  Stream<List<Category>> _categories = Stream.empty();

  Stream<List<Category>> get categories => _categories;

  FlipFlopBloc(this._firestoreRepository) {
   _cards = _category
             .distinct()
             .asyncMap((category) {
               List<WordViewModel> results = [];
                return _firestoreRepository
                   .readByFilter("cards", "category:$category:$level:$lang")
                   .first
                   .then((QuerySnapshot snapshot) {
                     results = convert(snapshot.documents);
                     return results;
                  });
              });

    _categories = _firestoreRepository
        .read("categories")
        .distinct()
        .asyncMap((QuerySnapshot snapshot) {
          return snapshot
              .documents.map((doc) =>
                Category.fromJson(doc.data)).toList();
    });
  }

  List<WordViewModel> convert(List<DocumentSnapshot> data) {
    return data.map((doc) =>
        WordViewModel.fromJson(doc.documentID, doc.data)).toList();
  }

  void dispose() {
    print("Dispose of flipflop bloc.");
    _category.close();
  }
}