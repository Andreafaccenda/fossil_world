import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_mapbox_navigation/flutter_mapbox_navigation.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import '../../main.dart';
import '../../widgets/costanti.dart';
import '../../widgets/endpoint_card.dart';
import '../../widgets/search_listview.dart';

class PrepareRide extends StatefulWidget {
  const PrepareRide({Key? key}) : super(key: key);

  @override
  State<PrepareRide> createState() => _PrepareRideState();

  // Declare a static function to reference setters from children
  static _PrepareRideState? of(BuildContext context) =>
      context.findAncestorStateOfType<_PrepareRideState>();
}

class _PrepareRideState extends State<PrepareRide> {
  bool isLoading = false;
  bool isEmptyResponse = true;
  bool hasResponded = false;
  bool isResponseForDestination = false;

  String noRequest = 'Please enter an address, a place or a location to search';
  String noResponse = 'No results found for the search';

  TextEditingController sourceController = TextEditingController();
  TextEditingController destinationController = TextEditingController();

  MapBoxNavigationViewController? _controller;
  late MapBoxOptions _navigationOption;
  String? currentAddress = "";

  @override
  void initState() {
    super.initState();
    initialize();
    _useCurrentAddress();
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  // Define setters to be used by children widgets
  set responsesState(List responses) {
    setState(() {
      hasResponded = true;
      isEmptyResponse = responses.isEmpty;
    });
    Future.delayed(
      const Duration(milliseconds: 500),
          () => setState(() {
        isLoading = false;
      }),
    );
  }

  set isLoadingState(bool isLoading) {
    setState(() {
      this.isLoading = isLoading;
    });
  }

  set isResponseForDestinationState(bool isResponseForDestination) {
    setState(() {
      this.isResponseForDestination = isResponseForDestination;
    });
  }
  Future<void> initialize() async {
    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    _navigationOption = MapBoxNavigation.instance.getDefaultOptions();
    _navigationOption.simulateRoute = true;


  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      appBar: AppBar(
        leading: IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.arrow_back)),
        backgroundColor: const Color.fromRGBO(210, 180, 140, 1),
        title: const Text("Navigazione", style: TextStyle(color: secondaryColor5LightTheme),),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const ScrollPhysics(),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: endpointsCard(sourceController, destinationController),
              ),
              Container(),
              searchListView( isResponseForDestination,
                  destinationController, sourceController),
            ],
          ),
        ),
      ),
    floatingActionButton: FloatingActionButton.extended(
        backgroundColor: Colors.white,
        icon: const Icon(Icons.local_taxi,color:Color.fromRGBO(210, 180, 140, 1)),
        onPressed: () async {
          var wayPoints = <WayPoint>[];

          for(int i = 0;i < fossili.length;i++){
            if(sourceController.text.toString() == fossili[i].indirizzo){
              final _start = WayPoint(
                  name: fossili[i].nome.toString(),
                  latitude: double.parse(fossili[i].latitudine.toString()),
                  longitude: double.parse(fossili[i].longitudine.toString()),
                  isSilent: false);
                  wayPoints.add(_start);}
          }
          if(sourceController.text.toString() == currentAddress){
            Position currentPosition = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
            final _start = WayPoint(
                name: 'location',
                latitude: currentPosition.latitude,
                longitude: currentPosition.longitude,
                isSilent: false);
            wayPoints.add(_start);}

        for(int i = 0;i < fossili.length;i++) {
          if (destinationController.text.toString() == fossili[i].indirizzo) {
            final _destination = WayPoint(
                name: fossili[i].nome.toString(),
                latitude: double.parse(fossili[i].latitudine.toString()),
                longitude: double.parse(fossili[i].longitudine.toString()),
                isSilent: false);
                wayPoints.add(_destination);}
    }

          await MapBoxNavigation.instance
              .startNavigation(wayPoints: wayPoints);

        },
        label: const Text('Vai alla navigazione',style: TextStyle(color: Color.fromRGBO(210, 180, 140, 1)),)),
    );
  }
  _useCurrentAddress() async{
    Position currentPosition = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
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
}
