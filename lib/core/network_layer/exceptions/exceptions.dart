class ServerException implements Exception {
  final String message;
  final int code;

  ServerException({this.message = "", this.code = -1});
 
  @override
  String toString() {
    return '${this.runtimeType}(message:$message, code:$code)';
  }
}

class CacheException implements Exception {}

class FetchDataException extends ServerException {
  FetchDataException([String message])
      : super(message: "Error During Communication: ");
}

class BadRequestException extends ServerException {
  BadRequestException([message]) : super(message: "Invalid Request: ");
}

class UnauthorisedException extends ServerException {
  UnauthorisedException([message]) : super(message: "Unauthorised: ");
}

class InvalidInputException extends ServerException {
  InvalidInputException([String message]) : super(message: "Invalid Input: ");
}
