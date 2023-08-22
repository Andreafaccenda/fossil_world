import 'dart:async';
import 'dart:io';
import 'package:ar_flutter_plugin/ar_flutter_plugin.dart';
import 'package:ar_flutter_plugin/datatypes/anchor_types.dart';
import 'package:ar_flutter_plugin/datatypes/config_planedetection.dart';
import 'package:ar_flutter_plugin/datatypes/hittest_result_types.dart';
import 'package:ar_flutter_plugin/datatypes/node_types.dart';
import 'package:ar_flutter_plugin/managers/ar_anchor_manager.dart';
import 'package:ar_flutter_plugin/managers/ar_location_manager.dart';
import 'package:ar_flutter_plugin/managers/ar_object_manager.dart';
import 'package:ar_flutter_plugin/managers/ar_session_manager.dart';
import 'package:ar_flutter_plugin/models/ar_anchor.dart';
import 'package:ar_flutter_plugin/models/ar_hittest_result.dart';
import 'package:ar_flutter_plugin/models/ar_node.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:path_provider/path_provider.dart';
import 'package:vector_math/vector_math_64.dart';

import '../../widgets/costanti.dart';

class LocalAndWebObjectsView extends StatefulWidget {
  const LocalAndWebObjectsView({Key? key}) : super(key: key);

  @override
  State<LocalAndWebObjectsView> createState() => _LocalAndWebObjectsViewState();
}

class _LocalAndWebObjectsViewState extends State<LocalAndWebObjectsView> {
  late ARSessionManager arSessionManager;
  late ARObjectManager arObjectManager;
  ARAnchorManager? arAnchorManager;
  HttpClient? httpClient;
  bool comparso = true;

  var distance;

  ARNode? webObjectNode;
  ARNode? starObjectNode;
  late var webAnchors;
  List<ARNode> nodes = [];
  List<ARAnchor> anchors = [];

  String location = "";

  final LocationSettings locationSettings = const LocationSettings(
    accuracy: LocationAccuracy.high,
    distanceFilter: 100,
  );
  @override
  void initState() {
    super.initState();
    StreamSubscription<Position> positionStream =
    Geolocator.getPositionStream(locationSettings: locationSettings)
        .listen((Position? position) async {
      List<Placemark> newPlace = await placemarkFromCoordinates(position!.latitude,position!.longitude);

      // this is all you need
      Placemark placeMark  = newPlace[0];
      String? address = "${placeMark.street}, ${placeMark.locality}, "
          "${placeMark.administrativeArea} ${placeMark.postalCode}, ${placeMark.country}";
       setState(() {
         location="Lat:${position?.latitude.toString()} \n Long:${position?.longitude.toString()}\n ${address.toString()}";
       });
    });
  }

  @override
  void dispose() {
    super.dispose();
    arSessionManager.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: secondaryColor10LightTheme,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 30),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              SizedBox(
                height: MediaQuery
                    .of(context)
                    .size
                    .height * .75,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(22),
                  child: ARView(
                    onARViewCreated: onARViewCreated,
                    planeDetectionConfig: PlaneDetectionConfig.horizontalAndVertical,),),),
              const SizedBox(height: 10,),
              const Text('Posizione:',style: TextStyle(color: secondaryColor80LightTheme,fontWeight: FontWeight.w800,fontSize: 20),),
              Text(location.toString(),style: const TextStyle(color: secondaryColor80LightTheme,fontWeight: FontWeight.w300),),
              const SizedBox(height: 5,),
               Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CupertinoButton(child: const Text('Calcola distanza'), onPressed: (){getDistance();}),
                  Text(distance.toString()),
                ],
                ),
            ],
          ),
        ),
      ),
    );
  }

  void onARViewCreated(ARSessionManager arSessionManager,
      ARObjectManager arObjectManager,
      ARAnchorManager arAnchorManager,
      ARLocationManager arLocationManager) {
    this.arSessionManager = arSessionManager;
    this.arObjectManager = arObjectManager;
    this.arAnchorManager = arAnchorManager;

    this.arSessionManager.onInitialize(
        showFeaturePoints: false,
        showPlanes: true,
        customPlaneTexturePath: "assets/image/triangle.png",
        showWorldOrigin: false,
        handlePans: true,
        handleRotation: true,
        showAnimatedGuide: false
    );
    this.arObjectManager.onInitialize();

    this.arSessionManager.onPlaneOrPointTap = onPlaneOrPointTapped;
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
    this.arSessionManager!.onError(foregroundNode.data!["onTapText"]);
  }

  Future<void> onPlaneOrPointTapped(
      List<ARHitTestResult> hitTestResults) async {
    var singleHitTestResult = hitTestResults.firstWhere(
            (hitTestResult) => hitTestResult.type == ARHitTestResultType.plane);
    if (singleHitTestResult != null) {
      var newAnchor = ARPlaneAnchor(
          transformation: singleHitTestResult.worldTransform, ttl: 2);
      bool? didAddAnchor = await this.arAnchorManager!.addAnchor(newAnchor);
      if (didAddAnchor ?? false) {
        this.anchors.add(newAnchor);
        // Add note to anchor
        var newNode = ARNode(
            type: NodeType.fileSystemAppFolderGLB,
            uri: "ammonite_science_zone_uk.glb",
            scale: Vector3(1, 1, 1),
            position: Vector3(0.0, 0.0, 0.0),
            rotation: Vector4(1.0, 0.0, 0.0, 0.0),
            data: {"onTapText": "Ouch, that hurt!"});
        bool? didAddNodeToAnchor =
        await this.arObjectManager!.addNode(newNode, planeAnchor: newAnchor);
        if (didAddNodeToAnchor ?? false) {
          this.nodes.add(newNode);
        } else {
          this.arSessionManager!.onError("Adding Node to Anchor failed");
        }
      } else {
        this.arSessionManager!.onError("Adding Anchor failed");
      }
    }
  }

  getDistance() async {

    setState(() {
      arSessionManager.getDistanceFromAnchor(webAnchors).then((value) =>
      distance = value?.toStringAsFixed(3));
    });
   /* if (double.parse(distance.toString()) <= 1.00) {
      showCatchDialog();
    }*/
  }

  Future<bool> showCatchDialog() async {
    return await showDialog(
        barrierDismissible: true, context: context, builder: (context) =>
        AlertDialog(shape: RoundedRectangleBorder(
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
          ), content: const Text("Fossile catturato",),
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

}
 /* Future<void> onWebObjectAtButtonPressed() async {

    if (webObjectNode != null) {
      arObjectManager.removeNode(webObjectNode!);
      webObjectNode = null;
    } else {
      var newNode = ARNode(
          type: NodeType.fileSystemAppFolderGLB,
          uri:"ammonite_science_zone_uk.glb",
          scale: Vector3(0.8, 0.8, 0.8),
          position: Vector3(0.0, 0.0, 0.0),
          rotation: Vector4(1.0, 0.0, 0.0, 0.0));
      bool? didAddWebNode = await arObjectManager.addNode(newNode);
      webObjectNode = (didAddWebNode!) ? newNode : null;
    }
    if (catchObjectNode != null) {
      arObjectManager.removeNode(catchObjectNode!);
      catchObjectNode = null;
    } else {
      var newNode = ARNode(
          type: NodeType.webGLB,
          uri:
          "https://github.com/Andreafaccenda/fossil_world/blob/master/gold_star.glb?raw=true",
          scale: Vector3(0.05, 0.05, 0.05),
          position: Vector3(0.0, 0.15, 0.0));
      bool? didAddWebNode = await arObjectManager.addNode(newNode);
      catchObjectNode = (didAddWebNode!) ? newNode : null;
    }
  }
  Future<bool> dialog()async {
    return await showDialog(barrierDismissible: false,context: context, builder: (context) {
      Future.delayed(const Duration(seconds: 15), () {
        onWebObjectAtButtonPressed();
        Navigator.of(context).pop(true);
      });
      return const Center(
        child:  CircularProgressIndicator(
          color: Color.fromRGBO(210, 180, 140, 1),),
      );
    });
  }*/

