import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flipflop/models/category_view_model.dart';
import 'package:flipflop/models/word_view_model.dart';
import 'package:flipflop/repo/firestore_repository.dart';
import 'package:rxdart/rxdart.dart';

class FlipFlopBloc {

  final FirestoreRepository _firestoreRepository;

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
         return _firestoreRepository
             .readByFilter("cards", "category:$category")
             .elementAt(0)
             .then((QuerySnapshot snapshot) {
            return snapshot
            .documents.map((doc) => WordViewModel.fromJson(doc.data)).toList();
         });
       });

    _categories = _firestoreRepository
        .read("categories")
        .distinct().asyncMap((QuerySnapshot snapshot) {
          return snapshot
              .documents.map((doc) => Category.fromJson(doc.data))
              .toList();
    });
  }

  void dispose() {
    print("Dispose of flipflop bloc.");
    _category.close();
  }
}