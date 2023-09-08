import 'dart:async';
import 'dart:io';
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
import 'package:latlong2/latlong.dart';
import 'package:mapbox_navigator/model/user_model.dart';
import 'package:mapbox_navigator/screens/auth/auth_view_model.dart';
import 'package:path_provider/path_provider.dart';
import 'package:vector_math/vector_math_64.dart';
import 'package:geolocator/geolocator.dart';
import '../../model/fossil.dart';
import '../../widgets/costanti.dart';
import '../../widgets/custom_dialog.dart';
import '../fossili/fossils_list.dart';

class ArWidget extends StatefulWidget {
  FossilModel model;
  ArWidget({super.key, required this.model});
  @override
  _ArWidgetState createState() => _ArWidgetState();
}

class _ArWidgetState extends State<ArWidget> {

  ARSessionManager? arSessionManager;
  ARObjectManager? arObjectManager;
  ARAnchorManager? arAnchorManager;
  ARLocationManager? arLocationManager;
  final viewModel = AuthViewModel();
  HttpClient? httpClient;
  late UserModel user;
  List<ARNode> nodes = [];
  Distance distance = Distance();
  List<ARAnchor> anchors = [];
  String distanza = "5.00";
  double meter = 0.00;
  late LatLng coordinate;
  bool catturato = false;
  late var webAnchors;
  List<dynamic> lista = [];
  bool vicino = false;

  final LocationSettings locationSettings = const LocationSettings(
    accuracy: LocationAccuracy.high,
    distanceFilter: 5,
  );

  @override
  void initState() {
    super.initState();
    _isFossilNearly();
    _getUser();
  }

  @override
  void dispose() {
    super.dispose();
    arSessionManager!.dispose();
  }
  _getUser()async{

    var prefId = await viewModel.getIdSession();
    user = (await viewModel.getUserFormId(prefId))!;
    for(var id in user.lista_fossili ?? <String>[]){
      if(id == widget.model.id){
        setState(() {
          catturato=true;
        });
      }
    }
  }
  _isFossilNearly(){
    Geolocator.getPositionStream(locationSettings: locationSettings)
        .listen((Position? position) async {
      setState(() {
        meter = distance.as(
            LengthUnit.Meter,
            LatLng(position!.latitude, position!.longitude),LatLng(double.parse(widget.model.latitudine.toString()),double.parse(widget.model.longitudine.toString())));
      });
      if (meter < 10.00) {
        setState(() {
          vicino = true;
        });
      }else{
        setState(() {
          vicino = false;
        });
      }
    });
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
        title: const Text('Cattura',style: TextStyle(color: white,fontWeight: FontWeight.bold,fontSize: 20),),
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
                  Container(padding: const EdgeInsets.all(10), decoration: BoxDecoration(borderRadius: BorderRadius.circular(16), color: grey300,),
                      child:  Column(
                        children: [
                          Image.asset('assets/image/location.png',height: 30,color: vicino ? green: red,),
                          const SizedBox(height: 5,),
                          Text('Coordinate',style: TextStyle(color: vicino ? green: red,fontSize: 10,fontWeight: FontWeight.w700),),
                        ],
                      ),),
                  const SizedBox(width: 25),
                  GestureDetector(onTap: () {
                    getDistance();
                    },
                    child: Container(padding: const EdgeInsets.all(10), decoration: BoxDecoration(borderRadius: BorderRadius.circular(16), color: grey300),
                      child:  Column(
                        children: [
                          Image.asset('assets/image/icon_cattura.png',height: 30,),
                          const SizedBox(height: 5,),
                           Text('Cattura',style: TextStyle(color: black54,fontSize: 10,fontWeight: FontWeight.w700),),
                        ],
                      ),),),
                  const SizedBox(width: 25),
                  GestureDetector(onTap: () {
                    //bottom sheet
                    showModalBottomSheet(context: context, backgroundColor: trasparent, isScrollControlled: true, builder: (context) =>
                        customBottomSheet());
                  },
                    child: Container(padding: const EdgeInsets.all(10), decoration: BoxDecoration(borderRadius: BorderRadius.circular(16), color: grey300,),
                      child:  Column(
                        children: [
                          Image.asset('assets/image/icon_informazioni.png',height: 30,),
                           SizedBox(height: 5,),
                           Text('Legenda',style: TextStyle(color: black54,fontSize: 10,fontWeight: FontWeight.w700),),
                        ],
                      ),),),],),
            ],
          ),
        ),
      ),
    );
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
    _downloadFile("https://github.com/Andreafaccenda/fossil_world/blob/master/interlocking_circles.glb?raw=true",
        "interlocking_circles.glb");
  }


  Future<void> onNodeTapped(List<String> nodeNames) async {
    var foregroundNode =
    nodes.firstWhere((element) => element.name == nodeNames.first);
    arSessionManager!.onError(foregroundNode.data!["onTapText"]);
  }
  Future<void> onRemoveEverything() async {
    for (var anchor in anchors) {
      arAnchorManager!.removeAnchor(anchor);
    }
    anchors = [];
  }

  Future<void> onPlaneOrPointTapped(
      List<ARHitTestResult> hitTestResults) async {
      if(vicino) {
        var singleHitTestResult = hitTestResults.firstWhere(
                (hitTestResult) =>
            hitTestResult.type == ARHitTestResultType.plane);
        webAnchors = ARPlaneAnchor(transformation: singleHitTestResult.worldTransform, ttl: 2);
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
        if (catturato) {
          var catchNode = ARNode(
              type: NodeType.fileSystemAppFolderGLB,
              uri: "gold_star.glb",
              scale: Vector3(0.2, 0.2, 0.2),
              position: Vector3(0.0, 1.00, 0.0),
              rotation: Vector4(1.0, 0.0, 0.0, 0.0),
              data: {"onTapText": "Apri informazioni fossili"});
          await arObjectManager!.addNode(catchNode, planeAnchor: webAnchors);
        } else {
          var catchNode = ARNode(
              type: NodeType.fileSystemAppFolderGLB,
              uri: "interlocking_circles.glb",
              scale: Vector3(0.10, 0.10, 0.10),
              position: Vector3(0.0, 1.00, 0.0),
              rotation: Vector4(1.0, 0.0, 0.0, 0.0),
              data: {"onTapText": "Apri informazioni fossili"});
          await arObjectManager!.addNode(catchNode, planeAnchor: webAnchors);
        }
      }
  }

  getDistance() async {
      setState(() {
        arSessionManager?.getDistanceFromAnchor(webAnchors).then((value) =>
        distanza = value!.toStringAsFixed(3));
      });
      if (double.parse(distanza.toString()) <= 2.00) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: customSnackBar('Fossile catturato', true),
            behavior: SnackBarBehavior.floating,
            elevation: 0,
            backgroundColor: trasparent,
          ),
        );
        onRemoveEverything();
        if (!catturato) {
          user.lista_fossili?.add(widget.model.id);
          viewModel.updateUser(user);
          setState(() {
            catturato = true;
          });
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: customSnackBar('Devi avvicinarti ancora', false),
            behavior: SnackBarBehavior.floating,
            elevation: 0,
            backgroundColor: trasparent,
          ),
        );
      }
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