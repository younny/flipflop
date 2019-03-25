
import 'package:flipflop/constant/error.dart';

abstract class FlipFlopException implements Exception {
  FlipFlopException(this._message);

  String _message;

  @override
  String toString() {
    return "FlipFlopException($_message)";
  }

  bool isFireStoreError() {
    if(_message != null) {
      return _message.contains(FFError.FIRESTORE);
    }
    return false;
  }

  bool isSharedPreferencesError() {
    if(_message != null) {
      return _message.contains(FFError.SHARED_PREFERENCES);
    }

    return false;
  }
}

class SharedPreferencesException extends FlipFlopException {
  SharedPreferencesException(String message) : super(message);

  String get message => _message;
}

class FirestoreException extends FlipFlopException {
  FirestoreException(String message) : super(message);

  String get message => _message;
}

class LocalDatabaseException extends FlipFlopException {
  LocalDatabaseException(String message) : super(message);

  bool isDataAlreadyExistsError() {
    if(_message != null) {
      return _message.contains("UNIQUE constraint failed");
    }
    return false;
  }
  String get message => _message;
}

