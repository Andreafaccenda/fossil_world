import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';

import 'costanti.dart';
import 'location_field.dart';

Widget endpointsCard(TextEditingController sourceController,
    TextEditingController destinationController) {
  return Card(
    color: const Color.fromRGBO(210, 180, 140, 1),
    elevation: 5,
    clipBehavior: Clip.antiAlias,
    margin: const EdgeInsets.all(0),
    child: Column(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 10),
          child: Row(
            children: [
              Column(
                children: [
                  const Icon(Icons.directions_car, size: 8),
                  Container(
                    margin: const EdgeInsets.only(top: 3),
                    color: Colors.white,
                    width: 1,
                    height: 40,
                  ),
                  const Icon(Icons.location_on, size: 12),
                ],
              ),

              Expanded(
                child: Column(
                  children: [
                    LocationField(
                        isDestination: false,
                        textEditingController: sourceController),
                    LocationField(
                        isDestination: true,
                        textEditingController: destinationController),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    ),
  );

}