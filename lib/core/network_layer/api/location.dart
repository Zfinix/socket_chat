import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_google_maps/flutter_google_maps.dart';
import 'package:socket_chat/core/models/place_by_latlng.dart';
import 'package:socket_chat/core/network_layer/failure/failure.dart';
import 'package:socket_chat/core/network_layer/helper/api_helper.dart';
import 'package:socket_chat/utils/url.dart';

import '../base_repository.dart';

class Location extends BaseRepository {
  final apiHelper = ApiHelper();

  Future<Either<Failure, PlaceByLatLang>> getPlaceDetail({
    @required GeoCoord coord,
  }) async {
    assert(coord != null);
    return await isDeviceOffline()
        ? informDeviceIsOffline()
        : _getPlaceDetail(coord: coord);
  }

  Future<Either<Failure, PlaceByLatLang>> _getPlaceDetail({
    @required GeoCoord coord,
  }) async {
    try {
      final response = await apiHelper.get(
        url: API.getPlaceDetailByLatLng(coord)
      );

      print(response);
      if (response.contains('address_components'))
        return Right(PlaceByLatLang.fromJson(response));
      else
        return Left(ServerFailure(message: 'Could not get data'));
    } catch (e) {
      print(e.toString());
      return Left(ServerFailure(message: 'Server Failure'));
    }
  }
}
