import 'package:latlong2/latlong.dart';
import '../main.dart';
import '../requests/mapbox_requests.dart';

Future<Map> getDirectionsAPIResponse(LatLng currentLatLng, int index) async {
  final response = await getDrivingRouteUsingMapbox(
      currentLatLng,
      LatLng(double.parse(fossili[index].latitudine.toString()),
          double.parse(fossili[index].longitudine.toString())));
  Map geometry = response['routes'][0]['geometry'];
  num duration = response['routes'][0]['duration'];
  num distance = response['routes'][0]['distance'];
  Map modifiedResponse = {
    "geometry": geometry,
    "duration": duration,
    "distance": distance,
    "id": fossili[index].id,
  };
  return modifiedResponse;
}

void saveDirectionsAPIResponse(int index, String response) {
  sharedPreferences.setString('fossile--$index', response);
}
