import 'package:dartz/dartz.dart';

import 'failure/failure.dart';
import 'network/network_info.dart';

class BaseRepository {
  final NetworkInfo networkInfo = NetworkInfoImpl();


  // * Helper Functions
  Future<bool> isDeviceOffline() async {
    return !(await networkInfo.isConnected);
  }

  Future<Either<Failure, T>> informDeviceIsOffline<T>() async {
    return Left<Failure, T>(DeviceOfflineFailure());
  }

  // ! TODO: Log error on analytics
  Either<Failure, T> informServerFailure<T>({
    int code = -1,
    String message = '',
  }) {
    return Left<Failure, T>(
      ServerFailure(code: code, message: message),
    );
  }

  // ! TODO: Log error on analytics
  Either<Failure, T> informLocalCacheFailure<T>() {
    return Left<Failure, T>(LocalCacheFailure());
  }
}
