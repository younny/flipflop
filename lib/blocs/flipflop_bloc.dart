import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flipflop/models/SharedPrefItem.dart';
import 'package:flipflop/models/language_view_model.dart';
import 'package:flipflop/models/level_view_model.dart';
import 'package:flipflop/models/word_view_model.dart';
import 'package:flipflop/repo/firestore_repository.dart';
import 'package:flipflop/utils/view_model_converter.dart';
import 'package:rxdart/rxdart.dart';

class FlipFlopBloc {
  static final defaultLevel = Level(level: '0');

  static final defaultLanguage = Language(code: 'de', label: 'German');

  final FirestoreRepository _firestoreRepository;

  BehaviorSubject<Level> _level = BehaviorSubject<Level>(seedValue: defaultLevel);

  Sink<Level> get inLevel => _level;

  Stream<Level> get outLevel => _level.stream;

  BehaviorSubject<Language> _lang = BehaviorSubject<Language>(seedValue: defaultLanguage);

  Sink<Language> get inLang => _lang;

  Stream<Language> get outLang => _lang.stream;

  Sink<SharedPrefItem> either(Type T) => T == Level ? _level : _lang;

  BehaviorSubject<String> _category = BehaviorSubject<String>(seedValue: 'expression');

  Sink<String> get inCategory => _category;

  Stream<List<WordViewModel>> _cards = Stream.empty();

  Stream<List<WordViewModel>> get cards => _cards;

  Stream<List<String>> _categories = Stream.empty();

  Stream<List<String>> get categories => _categories;

  Stream<List<Language>> _languages = Stream.empty();

  Stream<List<Language>> get languages => _languages;

  Stream<List<Level>> _levels = Stream.empty();

  Stream<List<Level>> get levels => _levels;

  FlipFlopBloc(this._firestoreRepository) {

    _levels = Observable.defer(() =>
        Observable.fromFuture(_firestoreRepository
            .read("levels")
            .then((QuerySnapshot snapshot) =>
              snapshot
                .documents.map((doc) => Level.fromJson(doc.data))
                .toList()
            )).asBroadcastStream(),
        reusable: true
    );

    _languages = Observable.defer(() =>
        Observable.fromFuture(
        _firestoreRepository
            .read("languages")
            .then((QuerySnapshot snapshot) {
          return snapshot
              .documents.map((doc) {
                return Language.fromJson(doc.data);
          }).toList();
        })).asBroadcastStream(),
        reusable: true
    );

    _cards = _category
        .asyncMap((category) {
          String langCode = _lang.value.code;
          return _firestoreRepository
            .readDeep([langCode, category], ['categories'])
            .then((QuerySnapshot snapshot) {
              return snapshot
                  .documents
                  .map((doc) => convertMapToViewModel(lang: langCode, map: doc.data))
                  .toList();
            })
            .catchError((e) {
              print(e);
            });
        });

    _categories = _lang
        .asyncMap((lang) {
          return _firestoreRepository
              .read(lang.code)
              .then((QuerySnapshot snapshot) {
                return List.of(snapshot.documents[0].data['names'])
                    .map((cat) => cat.toString())
                    .toList();
              })
              .catchError((e) {
                print(e);
              });
        });
  }

  void dispose() {
    print("Dispose of flipflop bloc.");
    _category.close();
    _level.close();
    _lang.close();
  }
}