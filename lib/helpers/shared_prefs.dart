import 'dart:convert';
import 'package:latlong2/latlong.dart';
import 'package:mapbox_navigator/main.dart';

LatLng getLatLngFromSharedPrefs() {
  return LatLng(sharedPreferences.getDouble('latitude')!,
      sharedPreferences.getDouble('longitude')!);
}

