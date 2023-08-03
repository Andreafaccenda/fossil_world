import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_location_marker/flutter_map_location_marker.dart';
import 'package:geocoding/geocoding.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:latlong2/latlong.dart';
import 'package:mapbox_navigator/main.dart';
import 'package:mapbox_navigator/screens/ar_flutter/localAndWebObject.dart';
import 'package:mapbox_navigator/screens/ar_flutter/objectsonplane.dart';
import 'package:mapbox_navigator/screens/navigation/navigation_view.dart';
import '../../widgets/costanti.dart';
import '../../widgets/navbar.dart';
import 'fossil_view_model.dart';

const MAPBOX_ACCESS_TOKEN='pk.eyJ1IjoiZmFjYzAwIiwiYSI6ImNsam9kc3kzbDFtcHMzZXBqdWQ2YjNzeDcifQ.koA0RgNUY0hLmiOT6W1yqg';
class FossilMap extends StatefulWidget {

  @override
  State<FossilMap> createState() => _FossilMapState();
}

class _FossilMapState extends State<FossilMap> {
  final viewModel = FossilViewModel();
  late FollowOnLocationUpdate _followOnLocationUpdate;
  late StreamController<double?> _followCurrentLocationStreamController;
  int pageIndex = 0;
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
      drawer: const NavBar(),
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(210, 180, 140, 1),
        title: const Text("Fossil World", style: TextStyle(color: secondaryColor5LightTheme),),),
      body:  SafeArea(
        child: WillPopScope(onWillPop: showExitDialog,
          child: Stack(
            children: [
              SizedBox(
                height: MediaQuery.of(context).size.height*0.81,
                child: FlutterMap(
                  options: MapOptions(
                    center: const LatLng(0, 0),
                    zoom: 15,
                    minZoom: 5,
                    maxZoom: 20,
                    // Stop following the location marker on the map if user interacted with the map.
                    onPositionChanged: (MapPosition position, bool hasGesture) {
                      if (hasGesture && _followOnLocationUpdate != FollowOnLocationUpdate.never) {
                        setState(
                              () => _followOnLocationUpdate = FollowOnLocationUpdate.never,
                        );
                      }
                    },
                  ),
                  // ignore: sort_child_properties_last
                  children: [
                    TileLayer(
                      urlTemplate: 'https://api.mapbox.com/styles/v1/{id}/tiles/{z}/{x}/{y}?access_token={accessToken}',
                      additionalOptions: const  {
                        'accessToken': MAPBOX_ACCESS_TOKEN,
                        'id': 'mapbox/streets-v12',
                      },
                    ),
                    MarkerLayer(
                      markers: [
                        Marker(point: const LatLng(43.5037378, 13.124937099999986), builder: (context){
                          return Container(
                            child:  Image.asset('assets/icon/fossil_icon.png',scale: 0.4),
                          );
                        }),
                      ],
                    ),
                    CurrentLocationLayer( // disable animation
                      followCurrentLocationStream:
                      _followCurrentLocationStreamController.stream,
                      followOnLocationUpdate: _followOnLocationUpdate,),],),),
            ],),),),
      floatingActionButton:  Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
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
            Get.to( const LocalAndWebObjectsView());
          },backgroundColor: const Color.fromRGBO(210, 180, 140, 1),
              child: const Icon(Icons.search,color: Colors.white,),
          ),
          const SizedBox(height: 10,),
          FloatingActionButton(
            heroTag: 'default FloatingActionButton tag',
            onPressed: (){Get.to(const PrepareRide());},
            backgroundColor: const Color.fromRGBO(210, 180, 140, 1),
            child: const Icon(Icons.navigation_outlined,color: Colors.white,),
          ),


        ],),
    );
  }

  Future<bool> showExitDialog()async {
    return await showDialog(barrierDismissible: false,context: context, builder: (context)=>
        AlertDialog(shape:  RoundedRectangleBorder(borderRadius: BorderRadius.circular(10),),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              const Text('USCITA APP'),
              Container(height: 50, width: 50, padding: const EdgeInsets.all(7), decoration: BoxDecoration(border: Border.all(color: Colors.white), shape: BoxShape.circle, color: const Color.fromRGBO(210, 180, 140, 1),),
                child: Image.asset('assets/image/logo.png', height: 8, width: 8,),),
            ],
          ), content: const Text("Vuoi uscire dall'applicazione ?",),
          actions: [
            ElevatedButton(style: ElevatedButton.styleFrom( backgroundColor: Colors.white), onPressed: (){Navigator.of(context).pop(false);},
              child: const Text("NO",style: TextStyle(color:Color.fromRGBO(210, 180, 140, 1) ),),),
            ElevatedButton(style: ElevatedButton.styleFrom( backgroundColor: const Color.fromRGBO(210, 180, 140, 1)),
                onPressed: (){exit(0);},
                child: const Text("SI",style:TextStyle(color: Colors.white),))],));
  }
}