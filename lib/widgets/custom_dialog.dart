import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../screens/auth/login_view.dart';

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