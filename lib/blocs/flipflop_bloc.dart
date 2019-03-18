import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flipflop/models/word_view_model.dart';
import 'package:flipflop/repo/firestore_repository.dart';
import 'package:rxdart/rxdart.dart';

class FlipFlopBloc {

  final FirestoreRepository _firestoreRepository;

  BehaviorSubject<String> _category = BehaviorSubject<String>(seedValue: 'animal');

  Sink<String> get category => _category;

  Stream<QuerySnapshot> _cards = Stream.empty();

  Stream<QuerySnapshot> get cards => _cards;

  Stream<QuerySnapshot> _categories = Stream.empty();

  Stream<QuerySnapshot> get categories => _categories;

  FlipFlopBloc(this._firestoreRepository) {
   _cards = _category
       .distinct()
       .asyncMap((category) {
         return _firestoreRepository.readByFilter("cards", "category:$category")
             .elementAt(0);
       });

    _categories = _firestoreRepository.read("categories").distinct();
  }

  void dispose() {
    print("Dispose of flipflop bloc.");
    _category.close();
  }
}