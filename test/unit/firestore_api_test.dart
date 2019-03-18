import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flipflop/models/word_view_model.dart';
import 'package:flipflop/repo/firestore_repository.dart';
import 'package:flutter/services.dart';
import 'package:test/test.dart';

void main() {
  const MethodChannel channel = MethodChannel('plugins.flutter.io/cloud_firestore');
  final List<MethodCall> log = <MethodCall>[];
  const Map<String, dynamic> kMockDocumentSnapshotData = <String, dynamic>{
    'word': 'TEST',
    'category': 'test'
  };

  int mockHandleId = 0;
  setUp(() async {
    channel.setMockMethodCallHandler((MethodCall methodCall) async {
      String method = methodCall.method;
      log.add(methodCall);
      print(methodCall);
      if(method == 'Query#addSnapshotListener') {
        final int handle = mockHandleId++;
        Future<void>.delayed(Duration.zero).then<void>((_) {
          BinaryMessages.handlePlatformMessage(
            'plugins.flutter.io/cloud_firestore',
            channel.codec.encodeMethodCall(
              MethodCall('QuerySnapshot', <String, dynamic>{
                'app': 'DEFAULT',
                'handle': handle,
                'paths': <String>["${methodCall.arguments['path']}/0"],
                'documents': <dynamic>[kMockDocumentSnapshotData],
                'documentChanges': <dynamic>[
                  <String, dynamic>{
                    'oldIndex': -1,
                    'newIndex': 0,
                    'type': 'DocumentChangeType.added',
                    'document': kMockDocumentSnapshotData,
                  },
                ],
              }),
            ),
                (_) {},
          );
        });
        return handle;
      }
    });
  });

  test("load card list succssfully", () async {

    Stream<QuerySnapshot> snapshot;
    FirestoreRepository repository = FirestoreRepository.instance;
    snapshot = repository.readByFilter("cards", "category:test");

    snapshot.listen((QuerySnapshot snapshot) {
      expect(snapshot.documents.length, 1);

      WordViewModel word = WordViewModel.fromJson("test", snapshot.documents[0].data);
      expect(word, equals("TEST"));
    });

  });
//
//  test("load all cards list failed", () async {
//    List<WordViewModel> cards;
//
//    cards = await FlipApi().getCards();
//
//    expect(cards, isNotNull);
//
//    expect(cards, isEmpty);
//  });
//
//  test("load cards list with certain category only", () async {
//    List<WordViewModel> cards;
//
//    cards = await FlipApi().getCards(category: 'fruit');
//
//    expect(cards, isNotNull);
//
//
//  });
//
//  test("load cards list with certain category only failed", () async {
//    List<WordViewModel> cards;
//
//    cards = await FlipApi().getCards(category: 'fruit');
//
//    expect(cards, isNotNull);
//
//    expect(cards, isEmpty);
//
//  });
//
//  test("load all categories successfully", () async {
//    List<Category> categories;
//
//    categories = await FlipApi().getCategories();
//
//    expect(categories, isNotNull);
//
//  });
//
//  test("load all categories failed", () async {
//    List<Category> categories;
//
//    categories = await FlipApi().getCategories();
//
//    expect(categories, isNotNull);
//
//    expect(categories, isEmpty);
//  });
}