import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mapbox_navigator/widgets/costanti.dart';
import 'package:mapbox_navigator/widgets/endpoint_card.dart';
import '../../main.dart';
import 'package:flutter_mapbox_navigation/flutter_mapbox_navigation.dart';

import '../widgets/location_field.dart';
import '../widgets/search_listview.dart';

class SampleNavigationApp extends StatefulWidget {
  const SampleNavigationApp({super.key});

  @override
  State<SampleNavigationApp> createState() => _SampleNavigationAppState();
}

class _SampleNavigationAppState extends State<SampleNavigationApp> {
  String? _instruction;
  TextEditingController _controllerDestination = new TextEditingController();
  Timer? searchOnStoppedTyping;
  String query = '';

  bool _isMultipleStop = false;
  double? _distanceRemaining, _durationRemaining;
  MapBoxNavigationViewController? _controller;
  bool _routeBuilt = false;
  bool _isNavigating = false;
  bool _inFreeDrive = false;
  String currentAddress = "";
  String latitudine_destination = "";
  String longitudine_destination = "";
  late Position currentPosition ;
  late MapBoxOptions _navigationOption;

  @override
  void initState() {
    super.initState();
    _useCurrentAddress();
    initialize();
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initialize() async {
    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    _navigationOption = MapBoxNavigation.instance.getDefaultOptions();
    _navigationOption.simulateRoute = true;
    //_navigationOption.initialLatitude = 36.1175275;
    //_navigationOption.initialLongitude = -115.1839524;
    MapBoxNavigation.instance.registerRouteEventListener(_onEmbeddedRouteEvent);
    MapBoxNavigation.instance.setDefaultOptions(_navigationOption);

  }


  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      backgroundColor: grey300,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
               SizedBox(height: MediaQuery.of(context).size.height * .33,
                    child: Card(
                      color: const Color.fromRGBO(210, 180, 140, 1),
                      elevation: 5,
                      clipBehavior: Clip.antiAlias,
                      margin: const EdgeInsets.all(0),
                      child: Column(
                        children: [
                          Container(
                            padding: const EdgeInsets.only(left: 20,right: 20,top: 45,bottom: 20),
                            child: Row(
                              children: [
                                Column(
                                  children: [
                                    const Icon(Icons.directions_car, size: 20),
                                    Container(
                                      margin: const EdgeInsets.only(top: 3),
                                      color: Colors.white,
                                      width: 3,
                                      height: 40,
                                    ),
                                    const SizedBox(height: 10,),
                                    const Icon(Icons.location_on, size: 20),
                                  ],
                                ),
                                const SizedBox(width: 10,),
                                Expanded(
                                  child: Column(
                                    children: [
                                   Container(
                                            decoration:  const BoxDecoration(
                                              color: Colors.white,
                                              borderRadius: BorderRadius.all(Radius.circular(5)),
                                            ),
                                            child: SizedBox(
                                              height:53,
                                              width: 300,
                                              child: Padding(
                                                padding: const EdgeInsets.all(17.0),
                                                child: Text(currentAddress,style: TextStyle(color: Colors.grey[500],fontWeight: FontWeight.w300,fontSize: 14),),
                                              ),
                                            ),
                                          ),
                                      const SizedBox(height: 20,),
                                      TextFormField(style: TextStyle(color: Colors.grey[500],fontWeight: FontWeight.w300,fontSize: 14),controller: _controllerDestination , decoration: InputDecoration(enabledBorder:   OutlineInputBorder(borderSide: BorderSide(color: Colors.grey.shade300),), focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.grey.shade400),), fillColor: Colors.white, filled: true, hintText: 'Seleziona un fossile per avviare la navigazione', hintStyle: TextStyle(color: Colors.grey[500])),),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 150),
                            child: ElevatedButton.icon(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30.0),),
                                elevation: 5,
                                shadowColor: Colors.grey[400],
                              ),
                              label: const Text('Inizia la navigazione',style: TextStyle(color: Color.fromRGBO(210, 180, 140, 1),fontWeight: FontWeight.w300),),
                              icon: const Icon(Icons.directions_car,size: 20,color: Color.fromRGBO(210, 180, 140, 1),),
                              onPressed: () async {
                                var wayPoints = <WayPoint>[];
                                final _source = WayPoint(
                                    name: "Partenza",
                                    latitude: currentPosition.latitude,
                                    longitude: currentPosition.longitude,
                                    isSilent: false);

                                final _destination = WayPoint(
                                    name: "Destinazione",
                                    latitude: double.parse(latitudine_destination),
                                    longitude: double.parse(longitudine_destination),
                                    isSilent: false);
                                wayPoints.add(_source);
                                wayPoints.add(_destination);

                                await MapBoxNavigation.instance
                                    .startNavigation(wayPoints: wayPoints,
                                    options: MapBoxOptions(
                                        mode: MapBoxNavigationMode.driving,
                                        simulateRoute: true,
                                        language: "it",
                                        allowsUTurnAtWayPoints: true,
                                        units: VoiceUnits.metric));
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
              const SizedBox(height: 20,),
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: fossili.length,
                itemBuilder: (BuildContext context, int index) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 5),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.grey[400],),
                      child: Column(
                        children: [
                          ListTile(
                            onTap: () {
                              String text = fossili[index].indirizzo.toString();
                              _controllerDestination.text=text;
                              setState(() {
                                latitudine_destination= fossili[index].latitudine.toString();
                                longitudine_destination= fossili[index].longitudine.toString();
                              });

                            },

                            leading:  SizedBox(
                              height: double.infinity,
                              child: CircleAvatar(backgroundColor:Colors.white,
                                child: Image.asset('assets/icon/icon_fossil.png',height: 35,width: 35),),
                            ),
                            title: Text(fossili[index].nome.toString(),
                                style: const TextStyle(fontWeight: FontWeight.bold,color: Colors.black54)),
                            subtitle: Text(fossili[index].indirizzo.toString(),
                              overflow: TextOverflow.ellipsis,style: const TextStyle(color: Colors.black54),),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
  _useCurrentAddress() async{
    currentPosition = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    await placemarkFromCoordinates(
        currentPosition!.latitude, currentPosition!.longitude)
        .then((List<Placemark> placemarks) {
      Placemark place = placemarks[0];
      setState(() {
        currentAddress =
        '${place.street}, ${place.subLocality},${place.subAdministrativeArea}, ${place.postalCode}';
      });
    }).catchError((e) {
      debugPrint(e);
    });
  }
  Future<void> _onEmbeddedRouteEvent(e) async {
    _distanceRemaining = await MapBoxNavigation.instance.getDistanceRemaining();
    _durationRemaining = await MapBoxNavigation.instance.getDurationRemaining();

    switch (e.eventType) {
      case MapBoxEvent.progress_change:
        var progressEvent = e.data as RouteProgressEvent;
        if (progressEvent.currentStepInstruction != null) {
          _instruction = progressEvent.currentStepInstruction;
        }
        break;
      case MapBoxEvent.route_building:
      case MapBoxEvent.route_built:
        setState(() {
          _routeBuilt = true;
        });
        break;
      case MapBoxEvent.route_build_failed:
        setState(() {
          _routeBuilt = false;
        });
        break;
      case MapBoxEvent.navigation_running:
        setState(() {
          _isNavigating = true;
        });
        break;
      case MapBoxEvent.on_arrival:
        if (!_isMultipleStop) {
          await Future.delayed(const Duration(seconds: 3));
          await _controller?.finishNavigation();
        } else {}
        break;
      case MapBoxEvent.navigation_finished:
      case MapBoxEvent.navigation_cancelled:
        setState(() {
          _routeBuilt = false;
          _isNavigating = false;
        });
        break;
      default:
        break;
    }
    setState(() {});
  }
}

