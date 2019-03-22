import 'package:test/test.dart';
import 'package:flipflop/exception.dart';
import 'package:flipflop/constant/error.dart';

void main() {
  test("isSharedPreferencesError", () async {
    String msg = "${FFError.SHARED_PREFERENCES} Instance is null";
    final FlipFlopException exception = SharedPreferencesException(msg);

    expect(exception.isSharedPreferencesError(), isTrue);
    expect(exception.isFireStoreError(), isFalse);
  });

  test("isFireStoreError", () async {
    String msg = "${FFError.FIRESTORE} error";
    final FlipFlopException exception = FirestoreException(msg);

    expect(exception.isSharedPreferencesError(), isFalse);
    expect(exception.isFireStoreError(), isTrue);
  });
}