abstract class Failure {}

// General failures
class ServerFailure extends Failure {
  final String message;
  final int code;

  ServerFailure({this.message = "", this.code = -1});
  @override
  String toString() {
    return '${this.runtimeType}(message:$message, code:$code)';
  }
}

class LocalCacheFailure extends Failure {}

class DeviceOfflineFailure extends Failure {

  @override
  String toString() {
    return 'Your Device might be offline';
  }

}
