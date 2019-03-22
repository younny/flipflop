import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flipflop/blocs/flipflop_bloc.dart';
import 'package:flipflop/constant/error.dart';
import 'package:flipflop/exception.dart';
import 'package:flipflop/models/word_view_model.dart';
import 'package:flipflop/repo/firestore_repository.dart';
import 'package:flipflop/utils/shared_prefs_helper.dart';
import 'package:flutter/services.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

class MockFireStore extends Mock implements Firestore {}
class MockSharedPrefHelper extends Mock implements SharedPrefHelper {}
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

  //TODO Complete normal test case.
  group("normal", () {

  });

  group("exception", () {
    FirestoreRepository repository;
    MockFireStore mockFireStore;

    setUp(() {
      mockFireStore = MockFireStore();
      repository = FirestoreRepository.instance;
      repository.withMock(mockFireStore);
    });

    test("incorrect filter format", () async {
      when(mockFireStore.collection("cards"))
          .thenThrow(Error());

      expect(() => repository.readByFilter("cards", "category:test"),
          throwsA(TypeMatcher<FirestoreException>()
              .having((e) => e.message, "message", contains(FFError.FIRESTORE))));

    });

    test("when query collection", () async {
      when(mockFireStore.collection("cards"))
          .thenThrow(Error());

      expect(() => repository.readByFilter("cards", "category:test:0:ko"),
          throwsA(TypeMatcher<FirestoreException>()
          .having((e) => e.message, "message", contains(FFError.FIRESTORE))));

    });
  });
}