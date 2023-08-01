
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';

import '../main.dart';
import 'costanti.dart';


Widget searchListView(
    bool isResponseForDestination,
    TextEditingController destinationController,
    TextEditingController sourceController) {
  return ListView.builder(
    shrinkWrap: true,
    physics: const NeverScrollableScrollPhysics(),
    itemCount: fossili.length,
    itemBuilder: (BuildContext context, int index) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 5),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Colors.grey[400],),
          child: Column(
          children: [
            ListTile(
              onTap: () {
                String text = fossili[index].indirizzo.toString();
                if (sourceController.text.isNotEmpty) {
                  destinationController.text = text;
                } else {
                  sourceController.text = text;
                }
                FocusManager.instance.primaryFocus?.unfocus();
              },

              leading: const SizedBox(
                height: double.infinity,
                child: CircleAvatar(backgroundColor:Colors.white,
                    child: Icon(Icons.map,color: Color.fromRGBO(210, 180, 140, 1),)),
              ),
              title: Text(fossili[index].nome.toString(),
                  style: const TextStyle(fontWeight: FontWeight.bold,color: Colors.black54)),
              subtitle: Text(fossili[index].indirizzo.toString(),
                  overflow: TextOverflow.ellipsis,style: const TextStyle(color: Colors.black54),),
            ),
          ],
        ),
        ),
      );
    },
  );

}