import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:webview_flutter/webview_flutter.dart';
import '../../model/fossil.dart';
import '../../widgets/costanti.dart';
import 'fossil_view_model.dart';


const MAPBOX_ACCESS_TOKEN='pk.eyJ1IjoiZmFjYzAwIiwiYSI6ImNsam9kc3kzbDFtcHMzZXBqdWQ2YjNzeDcifQ.koA0RgNUY0hLmiOT6W1yqg';

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
    return SafeArea(
        child: Scaffold(
          body: Stack(
            children: [
              const SizedBox(
                width: double.infinity,
                height: 350,
                /*child: BabylonJSViewer(
                  src: 'assets/image/ammonite_science_zone_uk.glb',*/
            child: WebView(
              initialUrl: 'https://app.vectary.com/p/6LgldENY7Kch7KwWlbEycm',
              javascriptMode: JavascriptMode.unrestricted,
            ),
                ),
              buttonArrow(context),
              scroll(),
            ],
          ),
        ));
  }

  scroll() {
    double width = MediaQuery.of(context).size.width;
    return DraggableScrollableSheet(
        initialChildSize: 0.6,
        maxChildSize: 1.0,
        minChildSize: 0.6,
        builder: (context, scrollController) {
          return Container(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            clipBehavior: Clip.hardEdge,
            decoration: const BoxDecoration(
              color:  Color.fromRGBO(210, 180, 140, 1),
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20)),
            ),
            child: SingleChildScrollView(
              controller: scrollController,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 10, bottom: 25),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          height: 5,
                          width: 35,
                          color: Colors.black12,),],),),
                  Text(widget.model.nome.toString(), style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white,),),
                  const SizedBox(height: 15,),
                  const Text('Rarità:', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w900,
                    color: Colors.black54,),),
                    SizedBox(height: 10, width: width, child: ListView.builder(itemCount: 5, scrollDirection: Axis.horizontal, itemBuilder: (context,int key){return  const Icon(Icons.star, color: Colors.white, size: 16,);},),),
                  const SizedBox(height: 15,),
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 10),
                    child: Divider(height: 4,),),
                  const Text("Descrizione:",style: TextStyle(color: Colors.black54,fontSize: 16,fontWeight: FontWeight.w900),),
                  const SizedBox(height: 2,),
                  Text(widget.model.descrizione.toString(),style: const TextStyle(color: Colors.white,fontWeight: FontWeight.normal,letterSpacing: 0.5,wordSpacing: 1.5),),
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 10),
                    child: Divider(height: 4,),),
                  const SizedBox(height: 15,),
                  const Text("Posizione:",style: TextStyle(color: Colors.black54,fontSize: 16,fontWeight: FontWeight.w900),),
                  const SizedBox(height: 2,),Text(' ${widget.model.indirizzo.toString()}',style: const TextStyle(color: Colors.white,fontWeight: FontWeight.normal,letterSpacing: 0.5,wordSpacing: 1.5),),
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 5),
                    child: Divider(height: 4,),),
                  SizedBox(
                    height: MediaQuery.of(context).size.height*0.45,
                    child: FlutterMap(
                      options: MapOptions(
                        center:  LatLng(double.parse(widget.model.latitudine.toString()),double.parse(widget.model.longitudine.toString())),
                        zoom: 15,
                        minZoom: 5,
                        maxZoom: 20,
                        // Stop following the location marker on the map if user interacted with the map.

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
                            Marker(point: LatLng(double.parse(widget.model.latitudine.toString()),double.parse(widget.model.longitudine.toString())), builder: (context){
                              return Container(
                                child:   Image.asset('assets/icon/icon_fossil.png',scale: 0.4),
                              );
                            })
                          ],
                        ),
                      ],),),

                ],
              ),
            ),
          );
        });
  }
}


