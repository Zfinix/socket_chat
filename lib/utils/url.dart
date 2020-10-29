import 'package:flutter_google_maps/flutter_google_maps.dart';
import 'package:socket_chat/config/config_loader.dart';

class API {
  static String getPlaceDetailByLatLng(GeoCoord latLng) =>
      'https://maps.googleapis.com/maps/api/geocode/json?latlng=${latLng.latitude},${latLng.longitude}&key=${ConfigLoader.gApiKey}';
}
