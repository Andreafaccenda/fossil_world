import 'package:babylonjs_viewer/babylonjs_viewer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mapbox_navigator/screens/fossili/fossil_view_model.dart';
import '../../helpers/shared_prefs.dart';
import '../../model/fossil.dart';

class DettagliFossile extends StatefulWidget {
  FossilModel model;
  DettagliFossile({super.key, required this.model});

  @override
  State<DettagliFossile> createState() => _DettagliFossileState();
}

class _DettagliFossileState extends State<DettagliFossile> {
  final viewModel = FossilViewModel();

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Colors.grey[300],
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(210, 180, 140, 1),
        elevation: 0.00,
        title: const Text("Dettagli fossile",style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 18),),),
      body: SingleChildScrollView(
        child: Container(
          width: width,
          child: Stack(
            children: <Widget>[
              Container(
                padding: const EdgeInsets.fromLTRB(10, 30, 10, 10),
                alignment: Alignment.center,
                height: height*0.4,
                child: Padding(
                  padding: const EdgeInsets.all(25.0),
                  child: BabylonJSViewer(
                    src: 'assets/image/ammonite_science_zone_uk.glb',
                  ),
                ),
              ),
              Container(
                width: width,
                margin: EdgeInsets.fromLTRB( 15, height*0.40, 15, 20),
                padding: const EdgeInsets.all(30),
                decoration: BoxDecoration(
                  color: const Color.fromRGBO(210, 180, 140, 1),
                  borderRadius: BorderRadius.circular(30),),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(widget.model.nome.toString(), style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold,
                      color: Colors.white,),),
                    const SizedBox(height: 15,),
                    const Text('Rarità:', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w900,
                      color: Colors.black54,),),
                    SizedBox(height: 10, width: width, child: ListView.builder(itemCount: 5, scrollDirection: Axis.horizontal, itemBuilder: (context,int key){return  const Icon(Icons.star, color: Colors.white, size: 16,);},),),
                    const SizedBox(height: 15,),
                    const Text("Descrizione:",style: TextStyle(color: Colors.black54,fontSize: 16,fontWeight: FontWeight.w900),),
                    const SizedBox(height: 8,),
                    Text(widget.model.descrizione.toString(),style: const TextStyle(color: Colors.white,fontWeight: FontWeight.normal,letterSpacing: 0.5,wordSpacing: 1.5),),
                    const SizedBox(height: 15,),
                     Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                         const Text('Posizione:', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w900,
                          color: Colors.black54,),),
                        CupertinoButton(color: const Color.fromRGBO(210, 180, 140, 1), onPressed: () {
                          //bottomSheet(context);
                        },
                        child: const Icon(Icons.location_on,color: Colors.black54,),),
                      ],
                    ),
                    Text(' ${widget.model.indirizzo.toString()}',style: const TextStyle(color: Colors.white,fontWeight: FontWeight.normal,letterSpacing: 0.5,wordSpacing: 1.5),),
                  ],
                ),
              ),
            ],),),
      ),
    );
  }
  /*void bottomSheet(context) {
    showModalBottomSheet(context: context, backgroundColor: Colors.transparent, isScrollControlled: true, builder: (context) => Container(padding: const EdgeInsets.fromLTRB(10, 20, 10, 20), height: 300, decoration: const BoxDecoration(color:  Color.fromRGBO(210, 180, 140, 1) , borderRadius: BorderRadius.only(topRight: Radius.circular(25), topLeft: Radius.circular(25),),),
      child:  Stack(
          children: [
                  SizedBox(
                  height: 260,
                  child: MapboxMap(
                    accessToken: dotenv.env['MAPBOX_ACCESS_TOKEN'],
                    initialCameraPosition: _initialCameraPosition,
                    onMapCreated: _onMapCreated,
                    onStyleLoadedCallback: _onStyleLoadedCallback,
                    myLocationEnabled: true,
                    zoomGesturesEnabled: true,
                    myLocationTrackingMode: MyLocationTrackingMode.TrackingGPS,
                    minMaxZoomPreference: const MinMaxZoomPreference(5, 17),),),],),
    ),);
  }*/

}


