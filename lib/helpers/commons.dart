import 'package:latlong2/latlong.dart';
import 'package:mapbox_navigator/model/fossil.dart';

import '../main.dart';


LatLng getLatLngFromFossilData(int index) {
  return LatLng(double.parse(fossili[index].latitudine.toString()),
      double.parse(fossili[index].longitudine.toString()));
}
LatLng getLatLngFromOneFossilData(FossilModel fossil) {
  return LatLng(double.parse(fossil.latitudine.toString()),
      double.parse(fossil.longitudine.toString()));
}

