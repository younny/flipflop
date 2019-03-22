import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flipflop/models/category_view_model.dart';
import 'package:flipflop/models/language_view_model.dart';
import 'package:flipflop/models/level_view_model.dart';
import 'package:flipflop/models/word_view_model.dart';
import 'package:flipflop/repo/firestore_repository.dart';
import 'package:flipflop/utils/shared_prefs_helper.dart';
import 'package:rxdart/rxdart.dart';

class FlipFlopBloc {
  static final defaultLevel = Level(level: '0');
  static final defaultLanguage = Language(code: 'ko', label: 'Korean');

  final FirestoreRepository _firestoreRepository;

  final SharedPrefHelper _sharedPrefHelper = SharedPrefHelper();

  Observable<Level> selectedLevel = Observable.just(defaultLevel);

  Observable<Language> selectedLang = Observable.just(defaultLanguage);

  BehaviorSubject<Level> _level = BehaviorSubject<Level>(seedValue: defaultLevel);

  Sink<Level> get level => _level;

  set setLevel(Level lv) => level.add(lv);

  Sink<Language> get lang => _lang;

  BehaviorSubject<Language> _lang = BehaviorSubject<Language>(seedValue: defaultLanguage);

  set setLang(Language lng) => lang.add(lng);

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
    _sharedPrefHelper.pref()
      .then((pref) async {
        String storedLang = await _sharedPrefHelper.get('lang');
        String storedLevel = await _sharedPrefHelper.get('level');
        print("Stored language : $storedLang");
        print("Stored level : $storedLevel");
        String lang = storedLang ?? "ko-Korean";
        String level = storedLevel ?? "0";

        selectedLang = Observable.just(Language.fromPrefs(lang.split('-')));
        selectedLevel = Observable.just(Level.fromPrefs(level));
    });

    _levels = _firestoreRepository
        .read("levels")
        .distinct()
        .asyncMap((QuerySnapshot snapshot) {
          return snapshot
            .documents.map((doc) => Level.fromJson(doc.data)).toList();
    });

    _languages = _firestoreRepository
        .read("languages")
        .distinct()
        .asyncMap((QuerySnapshot snapshot) {
          return snapshot
              .documents.map((doc) => Language.fromJson(doc.data)).toList();
        });

    selectedLevel = _level
        .distinct()
        .asyncMap((level) {
          _sharedPrefHelper.set<String>("level", level.level)
              .then((success) =>
                      success
                      ? print("Updated level: $selectedLevel")
                      : print("Failed to update."));
          return level;
        });

    selectedLang = _lang
        .distinct()
        .asyncMap((lang) {
          _sharedPrefHelper.set<String>("lang", "${lang.code}-${lang.label}")
              .then((success) =>
                        success
                        ? print("Updated Language: $selectedLang")
                        : print("Failed to update."));
          return lang;
    });

   _cards = _category
             .distinct()
             .asyncMap((category) {
               List<WordViewModel> results = [];
               final String level = _level.value.level;
               final String lang = _lang.value.label;
               print("Get cards: (level:$level/lang:$lang)");
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
    _level.close();
    _lang.close();
  }
}