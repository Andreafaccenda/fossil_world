import 'package:flutter/material.dart';

import '../main.dart';

Widget carouselCard(int index, num distance, num duration) {
  return Card(
    color: Colors.grey[300],
    elevation: 10,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20),),
    clipBehavior: Clip.antiAlias,
    child: Padding(
      padding: const EdgeInsets.all(15),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            backgroundImage: NetworkImage(fossili[index].immagine.toString()),
            radius: 20,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  fossili[index].nome.toString(),
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 14,color: Colors.black54),
                ),
                Text(fossili[index].descrizione.toString(),
                    style: const TextStyle(color: Colors.black54),
                    overflow: TextOverflow.ellipsis),
                const SizedBox(height: 5),
                Text(
                  '${distance.toStringAsFixed(2)}kms, ${duration.toStringAsFixed(2)} mins',
                  style: const TextStyle(color: Colors.black54),
                  //style: const TextStyle(color: Color.fromRGBO(210, 180, 140, 1),),
                )
              ],
            ),
          ),
        ],
      ),
    ),
  );
}
