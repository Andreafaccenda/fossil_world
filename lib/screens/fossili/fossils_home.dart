import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_map_location_marker/flutter_map_location_marker.dart';
import 'package:geocoding/geocoding.dart';
import 'package:get/get.dart';
import 'package:mapbox_navigator/main.dart';
import 'package:mapbox_navigator/screens/navigation/fossil_navigator.dart';
import '../../widgets/custom_dialog.dart';
import '../../widgets/flutter_map.dart';
import '../ar_flutter/onBording.dart';
import 'fossil_view_model.dart';
class FossilHome extends StatefulWidget {
  const FossilHome({super.key});


  @override
  State<FossilHome> createState() => _FossilHomeState();
}

class _FossilHomeState extends State<FossilHome> {
  final viewModel = FossilViewModel();
  late FollowOnLocationUpdate _followOnLocationUpdate;
  late StreamController<double?> _followCurrentLocationStreamController;
  bool accessed = false;

  @override
  void initState() {
    super.initState();
    for(int i = 0;i<fossili.length;i++){
      _getPlace(double.parse(fossili[i].latitudine.toString()),double.parse(fossili[i].longitudine.toString()),i);
    }
    _followOnLocationUpdate = FollowOnLocationUpdate.always;
    _followCurrentLocationStreamController = StreamController<double?>();
  }

  @override
  void dispose() {
    _followCurrentLocationStreamController.close();
    super.dispose();
  }


  void _getPlace(double latitudine,double longitudine,int index) async {
    List<Placemark> newPlace = await placemarkFromCoordinates(latitudine,longitudine);

    // this is all you need
    Placemark placeMark  = newPlace[0];
    String? address = "${placeMark.street}, ${placeMark.locality}, "
        "${placeMark.administrativeArea} ${placeMark.postalCode}, ${placeMark.country}";
    fossili[index].indirizzo=address;
    viewmodel.updateFossil(fossili[index]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:  SafeArea(
        child: WillPopScope(onWillPop: showExitDialog,
          child:  Stack(
            children: [
              SizedBox(
                height:double.infinity,
                child: Mappa(followOnLocationUpdate: _followOnLocationUpdate,followCurrentLocationStreamController: _followCurrentLocationStreamController ,),
              ),
            ],),),),
      floatingActionButton:  Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          const SizedBox(height: 70,),
          FloatingActionButton(
            onPressed: () {
              // Follow the location marker on the map when location updated until user interact with the map.
              setState(
                    () => _followOnLocationUpdate = FollowOnLocationUpdate.always,);
              // Follow the location marker on the map and zoom the map to level 18.
              _followCurrentLocationStreamController.add(15);},
            backgroundColor: const Color.fromRGBO(210, 180, 140, 1),
            child: const Icon(Icons.my_location,color: Colors.white,), ),
          const SizedBox(height: 10,),
          FloatingActionButton(
              heroTag:'fab1',
              onPressed: (){
                Get.to( Onbording());
              },backgroundColor: const Color.fromRGBO(210, 180, 140, 1),
              child:  Image.asset('assets/image/icon_cattura.png',height: 30,)
          ),
          const SizedBox(height: 10,),
          FloatingActionButton(
              heroTag: 'default FloatingActionButton tag',
              onPressed: (){Get.to(const NavigationFossils());},
              backgroundColor: const Color.fromRGBO(210, 180, 140, 1),
              child:  Image.asset('assets/image/icon_navigazione.png',height: 30,)
          ),
        ],),
    );
  }
  Future<bool> showExitDialog()async {
    return await showDialog(barrierDismissible: false,context: context, builder: (context)=>
       customAlertDialog(context),);
  }
}