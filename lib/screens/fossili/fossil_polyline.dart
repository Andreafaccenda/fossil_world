import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_location_marker/flutter_map_location_marker.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:latlong2/latlong.dart';
import 'package:mapbox_navigator/main.dart';
import '../../helpers/shared_prefs.dart';
import '../../model/fossil.dart';
import '../../navigation/fossil_navigator.dart';
import '../../widgets/costanti.dart';
import '../ar_flutter/guideToCatchFossil.dart';
const MAPBOX_ACCESS_TOKEN='pk.eyJ1IjoiZmFjYzAwIiwiYSI6ImNsam9kc3kzbDFtcHMzZXBqdWQ2YjNzeDcifQ.koA0RgNUY0hLmiOT6W1yqg';
class FossilPolyline extends StatefulWidget {
  FossilModel model;
  FossilPolyline({super.key, required this.model});

  @override
  State<FossilPolyline> createState() => _FossilPolylineState();
}

class _FossilPolylineState extends State<FossilPolyline> {
  late num distance;
  late num duration;
  late FollowOnLocationUpdate _followOnLocationUpdate;
  late StreamController<double?> _followCurrentLocationStreamController;

  // Carousel related
  int pageIndex = 0;
  bool accessed = false;
  late List<Widget> carouselItems;
  List<LatLng> points = [];

  final LocationSettings locationSettings = const LocationSettings(
    accuracy: LocationAccuracy.high,
    distanceFilter: 5,
  );

  @override
  void initState() {
    super.initState();

    Geolocator.getPositionStream(locationSettings: locationSettings)
        .listen((Position? position) async {
          points.clear();
      points.add(LatLng(double.parse(position!.latitude.toString()), double.parse(position!.longitude.toString())));
      points.add(LatLng(double.parse(widget.model.latitudine.toString()), double.parse(widget.model!.longitudine.toString())));
    });
    // Calculate the distance and time from data in SharedPreferences
    for (int index = 0; index < fossili.length; index++) {
      String id = getIdFromSharedPrefs(index);
      if (widget.model.id == id) {
        distance = getDistanceFromSharedPrefs(index) / 1000;
        duration = getDurationFromSharedPrefs(index) / 60;
      }
    }

    _followOnLocationUpdate = FollowOnLocationUpdate.always;
    _followCurrentLocationStreamController = StreamController<double?>();
  }

  @override
  void dispose() {
    _followCurrentLocationStreamController.close();
    super.dispose();
  }

  Widget carouselCard() {
    return Container(
      height: MediaQuery.of(context).size.height * 0.17,
      decoration: BoxDecoration(
        color: marrone,
        border: Border.all(color: Colors.white),
        borderRadius: BorderRadius.circular(15),
        boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.5), spreadRadius: 3, blurRadius: 10, offset: const Offset(0, 3),),],
      ),
      child: Padding(
        padding: const EdgeInsets.only(top: 15,right: 0,left: 10,bottom: 10),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(decoration: BoxDecoration(border: Border.all(color: marrone!),shape: BoxShape.circle),
              child: CircleAvatar(
                backgroundImage: NetworkImage(widget.model.immagine.toString()),
                radius: 25,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.model.nome.toString(),
                    style: const TextStyle(
                      color: white,fontWeight: FontWeight.w800, fontSize: 16),
                  ),
                  const SizedBox(height: 5,),
                  Row(
                    children: [
                      Image.asset('assets/image/icon_location.png',height: 20,color: white,),
                      Text(widget.model.indirizzo.toString(),
                          overflow: TextOverflow.ellipsis,style: const TextStyle(
                            color: white,fontWeight: FontWeight.w500, fontSize: 12),),
                    ],
                  ),
                  const SizedBox(height: 5),
                  Row(
                    children: [
                      Image.asset('assets/image/street.png',height: 20,color: white,),
                      const SizedBox(width: 5,),
                      Text( '${distance.toStringAsFixed(2)} km',
                        overflow: TextOverflow.ellipsis,style: const TextStyle(
                            color: white,fontWeight: FontWeight.w400, fontSize: 12),),
                    ],
                  ),
                  const SizedBox(height: 5,),
                  Row(
                    children: [
                      const Icon(Icons.directions_car,size:20,color: white),
                      const SizedBox(width: 5,),
                      Text( '${duration.toStringAsFixed(2)} min',
                        overflow: TextOverflow.ellipsis,style: const TextStyle(
                            color: white,fontWeight: FontWeight.w400, fontSize: 12),),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            SizedBox(
              height: double.infinity,
              child: FlutterMap(
                options: MapOptions(
                  center: const LatLng(0, 0),
                  zoom: 15,
                  minZoom: 5,
                  maxZoom: 20,
                  // Stop following the location marker on the map if user interacted with the map.
                  onPositionChanged: (MapPosition position, bool hasGesture) {
                    if (hasGesture &&
                        _followOnLocationUpdate != FollowOnLocationUpdate.never) {
                      setState(
                            () =>
                        _followOnLocationUpdate = FollowOnLocationUpdate.never,
                      );
                    }
                  },
                ),
                // ignore: sort_child_properties_last
                children: [
                  TileLayer(
                    urlTemplate: 'https://api.mapbox.com/styles/v1/{id}/tiles/{z}/{x}/{y}?access_token={accessToken}',
                    additionalOptions: const {
                      'accessToken': MAPBOX_ACCESS_TOKEN,
                      'id': 'mapbox/streets-v12',
                    },
                  ),
                  MarkerLayer(
                    markers: [
                      Marker(point: LatLng(double.parse(widget.model.latitudine.toString()),double.parse(widget.model.longitudine.toString())), builder: (context){
                        return Container(
                          child:   Image.asset('assets/icon/icon_fossil.png',scale: 1),
                        );
                      })
                    ],
                  ),
                  PolylineLayer(
                    polylines: [
                      Polyline(points: points,color: Colors.black54, strokeWidth: 2),
                    ],
                  ),
                  CurrentLocationLayer( // disable animation
                    followCurrentLocationStream:
                    _followCurrentLocationStreamController.stream,
                    followOnLocationUpdate: _followOnLocationUpdate,),
                ],),
            ),
            Positioned(
                top: 20,left: 50,right: 50,child: carouselCard()),
          ],
        ),
      ),
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
                Get.to(GuideToCatchFossil(model: widget.model));
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
}