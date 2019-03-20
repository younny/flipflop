import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flipflop/models/category_view_model.dart';
import 'package:flipflop/models/word_view_model.dart';
import 'package:flipflop/repo/firestore_repository.dart';
import 'package:rxdart/rxdart.dart';

class FlipFlopBloc {

  final FirestoreRepository _firestoreRepository;

  String _selectedLevel;
  String _selectedLang;

  BehaviorSubject<String> _level = BehaviorSubject<String>(seedValue: '0');

  Sink<String> get level => _level;

  set setLevel(String lv) => level.add(lv);

  BehaviorSubject<String> _lang = BehaviorSubject<String>(seedValue: 'ko');

  Sink<String> get lang => _lang;

  set setLang(String lng) => lang.add(lng);

  BehaviorSubject<String> _category = BehaviorSubject<String>(seedValue: 'animal');

  Sink<String> get category => _category;

  Stream<List<WordViewModel>> _cards = Stream.empty();

  Stream<List<WordViewModel>> get cards => _cards;

  Stream<List<Category>> _categories = Stream.empty();

  Stream<List<Category>> get categories => _categories;

  FlipFlopBloc(this._firestoreRepository) {
    _level.listen((level) {
      print("Selected level: $level");
      _selectedLevel = level;
    });

    _lang.listen((lang) {
      print("Selected language: $lang");
      _selectedLang = lang;
    });

   _cards = _category
             .distinct()
             .asyncMap((category) {
               List<WordViewModel> results = [];
                return _firestoreRepository
                   .readByFilter("cards", "category:$category:$_selectedLevel:$_selectedLang")
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
    _level.close();
    _lang.close();
  }
}