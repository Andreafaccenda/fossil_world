import 'dart:convert';

import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:mapbox_gl/mapbox_gl.dart';
import 'package:mapbox_navigator/screens/auth/login_view.dart';
import '../helpers/directions_handler.dart';
import '../main.dart';
import '../screens/auth/auth_view_model.dart';

class Splash extends StatefulWidget {
  const Splash({Key? key}) : super(key: key);

  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> {

  final viewModel = AuthViewModel();
  var disabilita = false;

  @override
  void initState() {
    super.initState();
    autoLogin();
    initializeLocationAndSave();
  }

  autoLogin() async {
    var prefId = await viewModel.getIdSession();
    if (prefId != "") {
      setState(() {
        disabilita=true;
      });
      var user = await viewModel.getUserFormId(prefId);
      if (user != null) {
        viewModel.email= user.email!;
        viewModel.password = user.password!;
        viewModel.signInWithEmailAndPassword(false);
      }
    }
  }
  /// Determine the current position of the device.
  ///
  /// When the location services are not enabled or permissions
  /// are denied the `Future` will return an error.
  Future<void> initializeLocationAndSave() async {
   Location location = Location();
    bool? serviceEnabled;
    PermissionStatus? permissionGranted;

    serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
    }

    permissionGranted = await location.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await location.requestPermission();
    }

    // Get capture the current user location
    LocationData locationData = await location.getLocation();
    // Get capture the current user location
    /*bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }
    Position position = await Geolocator.getCurrentPosition();*/
    LatLng currentLatLng =
    LatLng(locationData.latitude!, locationData.longitude!);
    //Store the user location in sharedPreferences
    sharedPreferences.setDouble('latitude', locationData.latitude!);
    sharedPreferences.setDouble('longitude', locationData.longitude!);

    // Get and store the directions API response in sharedPreferences
    for (int i = 0; i < fossili.length; i++) {
      Map modifiedResponse = await getDirectionsAPIResponse(currentLatLng, i);
      saveDirectionsAPIResponse(i, json.encode(modifiedResponse));
    }

    // ignore: use_build_context_synchronously
    if(!disabilita){Get.offAll(LoginView());}
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
            color: Colors.grey[300]),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(height: 250, width: 250, padding: const EdgeInsets.all(35), decoration: BoxDecoration(border: Border.all(color: Colors.white), shape: BoxShape.circle, color: const Color.fromRGBO(210, 180, 140, 1),),
              child: Image.asset('assets/image/logo.png', height: 35, width: 35,),),
            const SizedBox(height: 20,),
            const SpinKitCircle(color: Color.fromRGBO(210, 180, 140, 1), size: 50.0,),
          ],
        ),
      ),
    );
  }
}