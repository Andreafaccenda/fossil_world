import 'dart:convert';

import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import 'package:location/location.dart';
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
      var user = (await viewModel.getUserFormId(prefId))!;
      if (user != null) {
        viewModel.email= user.email!;
        viewModel.password = user.password!;
        viewModel.signInWithEmailAndPassword(false);
      }
    }
    if(!disabilita){Get.offAll(LoginView());}
  }
  void initializeLocationAndSave() async {
    // Ensure all permissions are collected for Locations
    Location _location = Location();
    bool? _serviceEnabled;
    PermissionStatus? _permissionGranted;

    _serviceEnabled = await _location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await _location.requestService();
    }

    _permissionGranted = await _location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await _location.requestPermission();
    }

    // Get capture the current user location
    LocationData _locationData = await _location.getLocation();
    LatLng currentLatLng = LatLng(_locationData.latitude!, _locationData.longitude!);

    // Store the user location in sharedPreferences
    sharedPreferences.setDouble('latitude', _locationData.latitude!);
    sharedPreferences.setDouble('longitude', _locationData.longitude!);

    // Get and store the directions API response in sharedPreferences
    for (int i = 0; i < fossili.length; i++) {
      Map modifiedResponse = await getDirectionsAPIResponse(currentLatLng, i);
      saveDirectionsAPIResponse(i, json.encode(modifiedResponse));
    }
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