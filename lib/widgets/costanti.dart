import 'dart:ui';

import 'package:flutter/material.dart';

import '../helpers/shared_prefs.dart';
import '../main.dart';

InputDecoration formDecoration(String labelText,IconData iconData) {
  return InputDecoration(
    errorStyle: const TextStyle(fontSize: 10),
    prefixIcon: Icon(
      iconData,
      color: Color.fromRGBO(210, 180, 140, 1),
    ),
    errorMaxLines: 3,
    labelText: labelText,
    labelStyle: const TextStyle(color: Colors.grey),
    border: OutlineInputBorder(),
    focusedBorder: const OutlineInputBorder(
      borderSide: BorderSide(
        width: 2,
        color: Color.fromRGBO(210, 180, 140, 1),
      ),
    ),
  );
}

const TextStyle style16Orange = TextStyle(
  color: Colors.orange,
  fontSize: 16,);

const TextStyle style16White = TextStyle(
  color: Colors.white,
  fontSize: 16,);

const TextStyle style16Black = TextStyle(
  color: Colors.black,
  fontSize: 16,);

const String apiKey = "Your key";

const Color primaryColor = Color(0xFF006491);
const Color textColorLightTheme = Color(0xFF0D0D0E);

const Color secondaryColor80LightTheme = Color(0xFF202225);
const Color secondaryColor60LightTheme = Color(0xFF313336);
const Color secondaryColor40LightTheme = Color(0xFF585858);
const Color secondaryColor20LightTheme = Color(0xFF787F84);
const Color secondaryColor10LightTheme = Color(0xFFEEEEEE);
const Color secondaryColor5LightTheme = Color(0xFFF8F8F8);
const defaultPadding = 16.0;
const Color green = Color(0xFF1FCC79);
const Color red = Color(0xFFFF6464);
const Color mainText = Color(0xFF2E3E5C);
const Color SecondaryText = Color(0xFF9FA5C0);
const Color outline = Color(0xFFD0DBEA);
const Color white = Color(0xFFFFFFFF);
Color? whiteOpacity = Colors.white.withOpacity(0.4);
Color? grey300 = Colors.grey[300];
Color? black54 = Colors.black54;
Color? trasparent = Colors.transparent;
Color? marrone = Color.fromRGBO(210, 180, 140, 1);


Widget buttonArrow(BuildContext context) {
  return Padding(
    padding: const EdgeInsets.all(20.0),
    child: InkWell(
      onTap: () {
        Navigator.pop(context);
      },
      child: Container(
        clipBehavior: Clip.hardEdge,
        height: 55,
        width: 55,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
        ),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            height: 55,
            width: 55,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(25),
            ),
            child: Icon(
              Icons.arrow_back_ios,
              size: 20,
              color: marrone,
            ),
          ),
        ),
      ),
    ),
  );
}

Widget _paddingFossil(int index){
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 30,vertical:10),
    child: Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.grey[400],),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 15,right: 0,left: 10,bottom: 10),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(decoration: BoxDecoration(border: Border.all(color: white),shape: BoxShape.circle),
                  child: CircleAvatar(
                    backgroundImage: NetworkImage(fossili[index].immagine.toString()),
                    radius: 25,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        fossili[index].nome.toString(),
                        style: const TextStyle(
                            color: white,fontWeight: FontWeight.w800, fontSize: 16),
                      ),
                      const SizedBox(height: 5,),
                      Row(
                        children: [
                          Image.asset('assets/image/icon_location.png',height: 20,color: white,),
                          Text(fossili[index].indirizzo.toString(),
                            overflow: TextOverflow.ellipsis,style: const TextStyle(
                                color: white,fontWeight: FontWeight.w500, fontSize: 12),),
                        ],
                      ),
                      const SizedBox(height: 5),
                      Row(
                        children: [
                          Image.asset('assets/image/street.png',height: 20,color: white,),
                          const SizedBox(width: 5,),
                          Text( '${(getDistanceFromSharedPrefs(index) / 1000).toStringAsFixed(2)} km',
                            overflow: TextOverflow.ellipsis,style: const TextStyle(
                                color: white,fontWeight: FontWeight.w400, fontSize: 12),),
                        ],
                      ),
                      const SizedBox(height: 5,),
                      Row(
                        children: [
                          const Icon(Icons.directions_car,size:20,color: white),
                          const SizedBox(width: 5,),
                          Text( '${(getDurationFromSharedPrefs(index) / 60).toStringAsFixed(2)} min',
                            overflow: TextOverflow.ellipsis,style: const TextStyle(
                                color: white,fontWeight: FontWeight.w400, fontSize: 12),),
                        ],
                      ),

                    ],
                  ),),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}