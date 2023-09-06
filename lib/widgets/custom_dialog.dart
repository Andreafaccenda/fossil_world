import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:mapbox_navigator/widgets/costanti.dart';

Widget customAlertDialog(BuildContext context) {
  return AlertDialog(
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10),),
    title: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        const Text('USCITA APP'),
        Container(height: 50,
          width: 50,
          padding: const EdgeInsets.all(7),
          decoration: BoxDecoration(border: Border.all(color: Colors.white),
            shape: BoxShape.circle,
            color: const Color.fromRGBO(210, 180, 140, 1),),
          child: Image.asset('assets/image/logo.png', height: 8, width: 8,),),
      ],
    ), content: const Text("Vuoi uscire dall'applicazione ?",),
    actions: [
      ElevatedButton(
        style: ElevatedButton.styleFrom(backgroundColor: Colors.white),
        onPressed: () {
          Navigator.of(context).pop(false);
        },
        child: const Text(
          "NO", style: TextStyle(color: Color.fromRGBO(210, 180, 140, 1)),),),
      ElevatedButton(style: ElevatedButton.styleFrom(
          backgroundColor: const Color.fromRGBO(210, 180, 140, 1)),
          onPressed: () {
            exit(0);
          },
          child: const Text("SI", style: TextStyle(color: Colors.white),))
    ],);

}
 Widget customSnackBar(String str,bool catturato){
  return  Stack(
    clipBehavior: Clip.none,
    children: [
      Container(
        height: 90,
        padding: const EdgeInsets.all(16),
        decoration: const BoxDecoration(
          color: Color.fromRGBO(210, 180, 140, 1),
          borderRadius: BorderRadius.all(Radius.circular(20)),
        ),
        child:  Row(
          children: [
            const SizedBox(width: 48,),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Fossil World',style: TextStyle(color: Colors.white,fontSize: 18),),
                  const SizedBox(height: 5,),
                  Text(str,style: const TextStyle(color: Colors.white,fontSize: 12),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      Positioned(bottom:0,
        child: ClipRRect(
          borderRadius: const BorderRadius.only(
            bottomLeft: Radius.circular(20),
          ),
          child: SvgPicture.asset('assets/image/bubbles.svg',height: 48,width: 40,color: Colors.black38,),
        ),
      ),
      Positioned(
        top: -20,
        left: 0,
        child: Stack(
          alignment: Alignment.center,
          children: [
            SvgPicture.asset('assets/image/fail.svg',
              height: 40,
            color:  Colors.black38,),
            Positioned(
              top: 10,
              child: Visibility(
                visible: catturato,
                child: Image.asset(
                  'assets/image/pickage.png',
                  height: 16,),
              ),
            ),
            Positioned(
              top: 10,
              child: Visibility(
                visible: !catturato,
                child: SvgPicture.asset(
                  'assets/image/close.svg',
                  height: 16,),
              ),
            ),
          ],
        ),
      )
    ],
  );
 }

 Widget customBottomSheet(){
   return Container(padding: const EdgeInsets.fromLTRB(15, 30, 20, 15), height: 400,
     decoration: BoxDecoration(boxShadow:  [BoxShadow(blurRadius: 60, color: white.withOpacity(0.4),),],color: marrone, borderRadius: const BorderRadius.only(topRight: Radius.circular(30), topLeft: Radius.circular(30),),),
     child: Stack(
       children: [  Column(
         children: [
           const SizedBox(height: 5,),
           const Text('LEGENDA:',style: TextStyle(color: white,fontWeight: FontWeight.w900, fontSize: 20),),
           Padding(padding: const EdgeInsets.all(20),
             child: Column(
               children: [
                 Row(
                   mainAxisAlignment: MainAxisAlignment.start,
                   children: [
                     Container( padding: const EdgeInsets.all(10), decoration: BoxDecoration(border: Border.all(color: secondaryColor5LightTheme), borderRadius: BorderRadius.circular(10),color: grey300, ),
                       child: Image.asset('assets/image/star.png',height: 20,),
                     ),
                     const SizedBox(width: 10,),
                     const Text('Fossile già catturato',style: TextStyle(color: white,fontWeight: FontWeight.w300),)
                   ],
                 ),
                 const SizedBox(height: 15,),
                 Row(
                   mainAxisAlignment: MainAxisAlignment.start,
                   children: [
                     Container( padding: const EdgeInsets.all(10), decoration: BoxDecoration(border: Border.all(color: secondaryColor5LightTheme), borderRadius: BorderRadius.circular(10),color: grey300, ),
                       child: Image.asset('assets/image/circle.png',height: 20,),
                     ),
                     const SizedBox(width: 10,),
                     const Text('Fossile non ancora catturato',style: TextStyle(color: white,fontWeight: FontWeight.w300),)
                   ],
                 ),
                 const SizedBox(height: 15,),
                 Row(
                   mainAxisAlignment: MainAxisAlignment.start,
                   children: [
                     Container( padding: const EdgeInsets.all(10), decoration: BoxDecoration(border: Border.all(color: secondaryColor5LightTheme), borderRadius: BorderRadius.circular(10),color: grey300, ),
                       child: Image.asset('assets/image/location.png',height: 20,color: green,),
                     ),
                     const SizedBox(width: 10,),
                     const Text('Sei vicino alle coordinate \n  del fossile',style: TextStyle(color: white,fontWeight: FontWeight.w300),)
                   ],
                 ),
                 const SizedBox(height: 15,),
                 Row(
                   mainAxisAlignment: MainAxisAlignment.start,
                   children: [
                     Container( padding: const EdgeInsets.all(10), decoration: BoxDecoration(border: Border.all(color: secondaryColor5LightTheme), borderRadius: BorderRadius.circular(10),color: grey300, ),
                       child: Image.asset('assets/image/location.png',height: 20,color: red,),
                     ),
                     const SizedBox(width: 10,),
                     const Text('Sei lontano dalle coordinate \n del fossile',style: TextStyle(color: white,fontWeight: FontWeight.w300),)
                   ],
                 ),
                 const SizedBox(height: 15,),
                 Row(
                   mainAxisAlignment: MainAxisAlignment.start,
                   children: [
                     Container( padding: const EdgeInsets.all(10), decoration: BoxDecoration(border: Border.all(color: secondaryColor5LightTheme), borderRadius: BorderRadius.circular(10),color: grey300, ),
                       child: Image.asset('assets/image/pickage.png',height: 20),
                     ),
                     const SizedBox(width: 10,),
                     const Text('Strumento per la cattura \n del fossile',style: TextStyle(color: white,fontWeight: FontWeight.w300),)
                   ],
                 ),
               ],
             ),
           ),
         ],),

       ],
     ),
   );
 }