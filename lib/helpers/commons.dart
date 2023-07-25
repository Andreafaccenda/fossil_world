import 'package:mapbox_gl/mapbox_gl.dart';
import '../main.dart';

LatLng getLatLngFromRestaurantData(int index) {
  return LatLng(double.parse(fossili[index].latitudine.toString()),
      double.parse(fossili[index].longitudine.toString()));
}
