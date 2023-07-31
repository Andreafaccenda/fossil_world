import 'package:ar_flutter_plugin/ar_flutter_plugin.dart';
import 'package:ar_flutter_plugin/datatypes/node_types.dart';
import 'package:ar_flutter_plugin/managers/ar_anchor_manager.dart';
import 'package:ar_flutter_plugin/managers/ar_location_manager.dart';
import 'package:ar_flutter_plugin/managers/ar_object_manager.dart';
import 'package:ar_flutter_plugin/managers/ar_session_manager.dart';
import 'package:ar_flutter_plugin/models/ar_node.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:vector_math/vector_math_64.dart';

class LocalAndWebObjectsView extends StatefulWidget {
  const LocalAndWebObjectsView({Key? key}) : super(key: key);

  @override
  State<LocalAndWebObjectsView> createState() => _LocalAndWebObjectsViewState();
}

class _LocalAndWebObjectsViewState extends State<LocalAndWebObjectsView> {
  late ARSessionManager arSessionManager;
  late ARObjectManager arObjectManager;


  //String localObjectReference;
  ARNode? catchObjectNode;

  //String webObjectReference;
  ARNode? webObjectNode;

  @override
  void dispose() {
    arSessionManager.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(210, 180, 140, 1),
        centerTitle: true,
        title: const Text('Fossil World',
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
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
                  onARViewCreated: onARViewCreated,),),),
            CupertinoButton(
                borderRadius: const BorderRadius.all(Radius.circular(10)),
                color: const Color.fromRGBO(210, 180, 140, 1),
                child: const Text('3D Ammonite',
                  style: TextStyle(color: Color.fromRGBO(255, 255, 255, 1)),),
                onPressed: () {
                  onWebObjectAtButtonPressed();
                }),
          ],
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

    this.arSessionManager.onInitialize(
      showFeaturePoints: false,
      showPlanes: true,
      customPlaneTexturePath: "assets/image/triangle.png",
      showWorldOrigin: false,
      handleTaps: false,
      showAnimatedGuide: false,
    );
    this.arObjectManager.onInitialize();
  }


  Future<void> onWebObjectAtButtonPressed() async {

    if (webObjectNode != null) {
      arObjectManager.removeNode(webObjectNode!);
      webObjectNode = null;
    } else {
      var newNode = ARNode(
          type: NodeType.webGLB,
          uri:
          "https://github.com/Andreafaccenda/fossil_world/blob/master/ammonite_science_zone_uk.glb?raw=true",
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
}