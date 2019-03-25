import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flipflop/models/SharedPrefItem.dart';
import 'package:flipflop/models/category_view_model.dart';
import 'package:flipflop/models/language_view_model.dart';
import 'package:flipflop/models/level_view_model.dart';
import 'package:flipflop/models/word_view_model.dart';
import 'package:flipflop/repo/firestore_repository.dart';
import 'package:rxdart/rxdart.dart';

class FlipFlopBloc {
  static final defaultLevel = Level(level: '0');
  static final defaultLanguage = Language(code: 'ko', label: 'Korean');

  final FirestoreRepository _firestoreRepository;

  Observable<Level> selectedLevel = Observable.just(defaultLevel);

  Observable<Language> selectedLang = Observable.just(defaultLanguage);

  BehaviorSubject<Level> _level = BehaviorSubject<Level>(seedValue: defaultLevel);

  Sink<Level> get level => _level;

  BehaviorSubject<Language> _lang = BehaviorSubject<Language>(seedValue: defaultLanguage);

  Sink<Language> get lang => _lang;

  Sink<SharedPrefItem> either(Type T) => T == Level ? _level : _lang;

  BehaviorSubject<String> _category = BehaviorSubject<String>(seedValue: 'animal');

  Sink<String> get category => _category;

  Stream<List<WordViewModel>> _cards = Stream.empty();

  Stream<List<WordViewModel>> get cards => _cards;

  Stream<List<Category>> _categories = Stream.empty();

  Stream<List<Category>> get categories => _categories;

  Stream<List<Language>> _languages = Stream.empty();

  Stream<List<Language>> get languages => _languages;

  Stream<List<Level>> _levels = Stream.empty();

  Stream<List<Level>> get levels => _levels;

  FlipFlopBloc(this._firestoreRepository) {
    _levels = _firestoreRepository
        .read("levels")
        .distinct()
        .asyncMap((QuerySnapshot snapshot) {
          return snapshot
            .documents.map((doc) => Level.fromJson(doc.data)).toList();
        })
        .handleError((e) {
          print(e.toString());
        });

    _languages = _firestoreRepository
        .read("languages")
        .distinct()
        .asyncMap((QuerySnapshot snapshot) {
          return snapshot
              .documents.map((doc) => Language.fromJson(doc.data)).toList();
        })
        .handleError((e) {
          print(e.toString());
        });

    selectedLevel = _level
        .distinct()
        .asyncMap((level) => level)
        .handleError((e) {
          print(e.toString());
        });

    selectedLang = _lang
        .distinct()
        .asyncMap((lang) => lang)
        .handleError((e) {
          print(e.toString());
        });

    _cards = _category
             .distinct()
             .asyncMap((category) {
               List<WordViewModel> results = [];
               final String level = _level.value.level;
               final String lang = _lang.value.code;
               //print("Get cards: (level:$level/lang:$lang)");
                return _firestoreRepository
                   .readByFilter("cards", "category:$category:$level:$lang")
                   .first
                   .then((QuerySnapshot snapshot) {
                     results = convert(snapshot.documents);
                     return results;
                  });
              }).handleError((e) {
                e.toString();
              });

    _categories = _firestoreRepository
        .read("categories")
        .distinct()
        .asyncMap((QuerySnapshot snapshot) {
          return snapshot
              .documents.map((doc) =>
                Category.fromJson(doc.data)).toList();
        }).handleError((e) {
            e.toString();
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