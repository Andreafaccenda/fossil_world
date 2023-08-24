import 'dart:async';
import 'dart:io';
import 'dart:ui';
import 'package:ar_flutter_plugin/managers/ar_location_manager.dart';
import 'package:ar_flutter_plugin/managers/ar_session_manager.dart';
import 'package:ar_flutter_plugin/managers/ar_object_manager.dart';
import 'package:ar_flutter_plugin/managers/ar_anchor_manager.dart';
import 'package:ar_flutter_plugin/models/ar_anchor.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:ar_flutter_plugin/ar_flutter_plugin.dart';
import 'package:ar_flutter_plugin/datatypes/config_planedetection.dart';
import 'package:ar_flutter_plugin/datatypes/node_types.dart';
import 'package:ar_flutter_plugin/datatypes/hittest_result_types.dart';
import 'package:ar_flutter_plugin/models/ar_node.dart';
import 'package:ar_flutter_plugin/models/ar_hittest_result.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_location_marker/flutter_map_location_marker.dart';
import 'package:geocoding/geocoding.dart';
import 'package:latlong2/latlong.dart';
import 'package:mapbox_navigator/screens/fossili/home_management.dart';
import 'package:path_provider/path_provider.dart';
import 'package:vector_math/vector_math_64.dart';
import 'package:geolocator/geolocator.dart';
import '../../widgets/costanti.dart';
const MAPBOX_ACCESS_TOKEN='pk.eyJ1IjoiZmFjYzAwIiwiYSI6ImNsam9kc3kzbDFtcHMzZXBqdWQ2YjNzeDcifQ.koA0RgNUY0hLmiOT6W1yqg';

class CloudAnchorWidget extends StatefulWidget {
  CloudAnchorWidget({Key? key}) : super(key: key);
  @override
  _CloudAnchorWidgetState createState() => _CloudAnchorWidgetState();
}

class _CloudAnchorWidgetState extends State<CloudAnchorWidget> {

  ARSessionManager? arSessionManager;
  ARObjectManager? arObjectManager;
  ARAnchorManager? arAnchorManager;
  ARLocationManager? arLocationManager;
  HttpClient? httpClient;
  late FollowOnLocationUpdate _followOnLocationUpdate;
  late StreamController<double?> _followCurrentLocationStreamController;

  List<ARNode> nodes = [];
  List<ARAnchor> anchors = [];
  String latitudine = "";
  String longitudine = "";
  String location = "";
  String distance = "5.00";
  late var webAnchors;
  bool readyToMap = false;
  bool readyToCatch = false;
  bool readyToInfo = false;
  List<dynamic> lista = [];

  final LocationSettings locationSettings = const LocationSettings(
    accuracy: LocationAccuracy.high,
    distanceFilter: 100,
  );
  @override
  void initState() {
    super.initState();
    _followOnLocationUpdate = FollowOnLocationUpdate.always;
    _followCurrentLocationStreamController = StreamController<double?>();
    StreamSubscription<Position> positionStream =
    Geolocator.getPositionStream(locationSettings: locationSettings)
        .listen((Position? position) async {
          latitudine = position!.latitude.toString();
          longitudine= position!.longitude.toString();
      List<Placemark> newPlace = await placemarkFromCoordinates(position!.latitude,position!.longitude);

      // this is all you need
      Placemark placeMark  = newPlace[0];
      String? address = "${placeMark.street}, ${placeMark.locality}, "
          " ${placeMark.administrativeArea}  ${placeMark.postalCode}, ${placeMark.country}";
      setState(() {
        location="  ${address.toString()}";
      });
    });

  }

  @override
  void dispose() {
    super.dispose();
    arSessionManager!.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: grey300,
      appBar: AppBar(
        backgroundColor:  const Color.fromRGBO(210, 180, 140, 1),
        leading: Padding(
          padding: const EdgeInsets.only(left: 10,top: 7,bottom: 7),
          child: CircleAvatar(
            backgroundColor: secondaryColor10LightTheme,
            child: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: const Icon(Icons.arrow_back_ios_new_sharp, color: Color.fromRGBO(210, 180, 140, 1),size: 20,),
            ),
          ),
        ),
        centerTitle: true,
        title: const Text('Elenco fossili',style: TextStyle(color: form,fontWeight: FontWeight.w300),),
        actions: [
          CircleAvatar(
            backgroundColor: grey300,
            child: Image.asset('assets/icon/icon_fossil.png',height: 35,width: 35),
          ),
          const SizedBox(width: defaultPadding)
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
        child: SingleChildScrollView(
          physics: const ScrollPhysics(),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
               Padding(padding: const EdgeInsets.only(left: 150),
                child: ElevatedButton.icon(
                  label: Text('Hai bisogno di aiuto? ',style: TextStyle(color: black54,fontWeight: FontWeight.w300,fontSize: 12),),
                  icon: Icon(Icons.info,color: black54, ),
                  onPressed: () {
                    //some function
                  },
                style: ElevatedButton.styleFrom(backgroundColor: grey300, elevation: 0,),),),
              SizedBox(
                height: MediaQuery
                    .of(context)
                    .size
                    .height * .67,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(22),
                  child: ARView(
                    onARViewCreated: onARViewCreated,
                    planeDetectionConfig: PlaneDetectionConfig.horizontal,),),),
              const SizedBox(height: 20,),
              Row(mainAxisAlignment: MainAxisAlignment.center,
                children:  [
                  GestureDetector(onTap: () {setState(() {
                    readyToMap=true;
                    readyToCatch=false;
                    readyToInfo=false;
                  });},
                    child: Container(padding: const EdgeInsets.all(10), decoration: BoxDecoration(border: Border.all(color: secondaryColor5LightTheme), borderRadius: BorderRadius.circular(16), color: const Color.fromRGBO(210, 180, 140, 1),),
                      child:  Column(
                        children: [
                          Image.asset('assets/image/icon_mappa.png',height: 30,),
                          const SizedBox(height: 5,),
                          const Text('Mappa',style: TextStyle(color: form,fontSize: 10,fontWeight: FontWeight.w300),),
                        ],
                      ),),),
                  const SizedBox(width: 25),
                  GestureDetector(onTap: () {setState(() {
                    readyToMap=false;
                    readyToCatch=true;
                    readyToInfo=false;});
                    getDistance();
                    },
                    child: Container(padding: const EdgeInsets.all(10), decoration: BoxDecoration(border: Border.all(color: secondaryColor5LightTheme), borderRadius: BorderRadius.circular(16), color: const Color.fromRGBO(210, 180, 140, 1),),
                      child:  Column(
                        children: [
                          Image.asset('assets/image/icon_cattura.png',height: 30,),
                          const SizedBox(height: 5,),
                          const Text('Cattura',style: TextStyle(color: form,fontSize: 10,fontWeight: FontWeight.w300),),
                        ],
                      ),),),
                  const SizedBox(width: 25),
                  GestureDetector(onTap: () {setState(() {
                    readyToMap=false;
                    readyToCatch=false;
                    readyToInfo=true;
                  });},
                    child: Container(padding: const EdgeInsets.all(10), decoration: BoxDecoration(border: Border.all(color: secondaryColor5LightTheme), borderRadius: BorderRadius.circular(16), color: const Color.fromRGBO(210, 180, 140, 1),),
                      child:  Column(
                        children: [
                          Image.asset('assets/image/icon_informazioni.png',height: 30,),
                          const SizedBox(height: 5,),
                          const Text('Legenda',style: TextStyle(color: form,fontSize: 10,fontWeight: FontWeight.w300),),
                        ],
                      ),),),],),
                 const SizedBox(height: 20,),
                 Visibility(
                            visible: readyToMap,
                              child: Container(padding: const EdgeInsets.all(5), decoration: BoxDecoration(border: Border.all(color: secondaryColor5LightTheme), borderRadius: BorderRadius.circular(16),color: const Color.fromRGBO(210, 180, 140, 1), ),
                                child: Column(
                                  children: [
                                    const SizedBox(height: 10,),
                                     Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 20),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        children: [
                                           Icon(Icons.location_on,color: black54,),
                                          Text(location,style:  TextStyle(color: black54,fontWeight: FontWeight.w300,fontSize: 12),),
                                        ],
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(20),
                                      child: SizedBox(
                                          height: 500,
                                          child: FlutterMap(
                                            options: MapOptions(
                                              center: const LatLng(0, 0),
                                              zoom: 15,
                                              minZoom: 5,
                                              maxZoom: 20,
                                              // Stop following the location marker on the map if user interacted with the map.
                                              onPositionChanged: (MapPosition position, bool hasGesture) {
                                                if (hasGesture && _followOnLocationUpdate != FollowOnLocationUpdate.never) {
                                                  setState(() => _followOnLocationUpdate = FollowOnLocationUpdate.never,);}},),
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
                                                  _getMarker(),
                                                ],
                                              ),
                                              CurrentLocationLayer( // disable animation
                                                followCurrentLocationStream:
                                                _followCurrentLocationStreamController.stream,
                                                followOnLocationUpdate: _followOnLocationUpdate,),],),),
                                      ),
                                  ],
                                ),
                              ),
                            ),
                 Visibility(
                  visible: readyToInfo,
                  child:  Container(padding: const EdgeInsets.all(5), decoration: BoxDecoration(border: Border.all(color: secondaryColor5LightTheme),
                          borderRadius: BorderRadius.circular(16),color: const Color.fromRGBO(210, 180, 140, 1), ),
                      child:  Column(
                              children: [
                                const SizedBox(height: 10,),
                                const Text('LEGENDA:',style: TextStyle(color: form,fontWeight: FontWeight.w900),),
                                Padding(padding: const EdgeInsets.all(20),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Container( padding: const EdgeInsets.all(5), decoration: BoxDecoration(border: Border.all(color: secondaryColor5LightTheme), borderRadius: BorderRadius.circular(16),color: grey300, ),
                                      child: Image.asset('assets/image/icon_star.png',height: 20,),
                                    ),
                                    const SizedBox(width: 10,),
                                    const Text('Fossile già catturato',style: TextStyle(color: form,fontWeight: FontWeight.w300),)
                                  ],
                                ),
                                ),
                              ],),),
              ),
            ],
          ),
        ),
      ),
    );
  }
  Marker _getMarker(){
    return Marker(point: const LatLng(43.5037378, 13.124937099999986), builder: (context){
      return Image.asset('assets/icon/icon_fossil.png',scale: 0.4);
    });
  }

  void onARViewCreated(
      ARSessionManager arSessionManager,
      ARObjectManager arObjectManager,
      ARAnchorManager arAnchorManager,
      ARLocationManager arLocationManager) {
    this.arSessionManager = arSessionManager;
    this.arObjectManager = arObjectManager;
    this.arAnchorManager = arAnchorManager;
    this.arLocationManager = arLocationManager;

    this.arSessionManager!.onInitialize(
      showFeaturePoints: false,
      showPlanes: true,
      customPlaneTexturePath: "Images/triangle.png",
      showWorldOrigin: false,
      showAnimatedGuide: false
    );
    this.arObjectManager!.onInitialize();

    this.arSessionManager!.onPlaneOrPointTap = onPlaneOrPointTapped;
    this.arObjectManager!.onNodeTap = onNodeTapped;
    httpClient = HttpClient();
    _downloadFile(
        "https://github.com/Andreafaccenda/fossil_world/blob/master/ammonite_science_zone_uk.glb?raw=true",
        "ammonite_science_zone_uk.glb");
    _downloadFile("https://github.com/Andreafaccenda/fossil_world/blob/master/gold_star.glb?raw=true",
        "gold_star.glb");
  }


  Future<void> onNodeTapped(List<String> nodeNames) async {
    var foregroundNode =
    nodes.firstWhere((element) => element.name == nodeNames.first);
    arSessionManager!.onError(foregroundNode.data!["onTapText"]);
  }
  Future<void> onRemoveEverything() async {
    /*nodes.forEach((node) {
      this.arObjectManager.removeNode(node);
    });*/
    for (var anchor in anchors) {
      arAnchorManager!.removeAnchor(anchor);
    }
    anchors = [];
  }

  Future<void> onPlaneOrPointTapped(
      List<ARHitTestResult> hitTestResults) async {
    var singleHitTestResult = hitTestResults.firstWhere(
            (hitTestResult) => hitTestResult.type == ARHitTestResultType.plane);
    if (singleHitTestResult != null) {
       webAnchors=  ARPlaneAnchor(
          transformation: singleHitTestResult.worldTransform, ttl: 2);
      bool? didAddAnchor = await arAnchorManager!.addAnchor(webAnchors);
      if (didAddAnchor ?? false) {
        anchors.add(webAnchors);
        // Add note to anchor
        var newNode = ARNode(
            type: NodeType.fileSystemAppFolderGLB,
            uri: "ammonite_science_zone_uk.glb",
            scale: Vector3(2.5, 2.5, 2.5),
            position: Vector3(0.0, 0.50, 0.0),
            rotation: Vector4(1.0, 0.0, 0.0, 0.0),
            data: {"onTapText": "Apri informazioni fossili"});
        bool? didAddNodeToAnchor =
        await arObjectManager!.addNode(newNode, planeAnchor: webAnchors);
        if (didAddNodeToAnchor ?? false) {
          nodes.add(newNode);
        } else {
          arSessionManager!.onError("Adding Node to Anchor failed");
        }
      } else {
        arSessionManager!.onError("Adding Anchor failed");
      }
    }
  }
  getDistance() async {

    setState(() {
      arSessionManager?.getDistanceFromAnchor(webAnchors).then((value) =>
      distance = value!.toStringAsFixed(3));
    });
     if (double.parse(distance.toString()) <= 1.50) {
      showCatchDialog("Fossile catturato");
      showExitDialog();
    }else {
       showCatchDialog("Devi avvicinarti ancora!");
     }
  }
  Future<bool> showCatchDialog(String str) async {
    return await showDialog(
        barrierDismissible: true, context: context, builder: (context) =>
        AlertDialog(
          shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              const Text('Fossil World'),
              Container(
                height: 50,
                width: 50,
                padding: const EdgeInsets.all(7),
                decoration: BoxDecoration(border: Border.all(color: form),
                  shape: BoxShape.circle,
                  color: const Color.fromRGBO(210, 180, 140, 1),),
                child: Image.asset(
                  'assets/image/logo.png', height: 8, width: 8,),),
            ],
          ), content:  Text(str,),
        ));
  }
  Future<File> _downloadFile(String url, String filename) async {
    var request = await httpClient!.getUrl(Uri.parse(url));
    var response = await request.close();
    var bytes = await consolidateHttpClientResponseBytes(response);
    String dir = (await getApplicationDocumentsDirectory()).path;
    File file = File('$dir/$filename');
    await file.writeAsBytes(bytes);
    return file;
  }
  Future<bool> showExitDialog()async {
    return await showDialog(barrierDismissible: false,context: context, builder: (context)=>
        AlertDialog(shape:  RoundedRectangleBorder(borderRadius: BorderRadius.circular(10),),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              const Text('FOSSIL WORLD'),
              Container(height: 50, width: 50, padding: const EdgeInsets.all(7), decoration: BoxDecoration(border: Border.all(color: form), shape: BoxShape.circle, color: const Color.fromRGBO(210, 180, 140, 1),),
                child: Image.asset('assets/image/logo.png', height: 8, width: 8,),),
            ],
          ), content: const Text("Vuoi continuare a catturare fossili?",style: TextStyle(fontWeight: FontWeight.w300),),
          actions: [
            ElevatedButton(style: ElevatedButton.styleFrom( backgroundColor: form), onPressed: (){onRemoveEverything();
            Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (context) {
                  return HomeManagement();
                }));},
              child: const Text("NO",style: TextStyle(color:Color.fromRGBO(210, 180, 140, 1) ),),),
            ElevatedButton(style: ElevatedButton.styleFrom( backgroundColor: const Color.fromRGBO(210, 180, 140, 1)),
                onPressed: (){
                onRemoveEverything();
                Navigator.of(context).pop(false);},
                child: const Text("SI",style:TextStyle(color: form),))],));
  }

}