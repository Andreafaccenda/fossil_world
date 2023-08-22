import 'package:flutter/material.dart';

import 'package:mapbox_navigator/screens/fossili/fossils_map.dart';
import 'package:mapbox_navigator/screens/fossili/fossils_table.dart';
class HomeManagement extends StatefulWidget {

  @override
  State<HomeManagement> createState() => _HomeManagementState();
}

class _HomeManagementState extends State<HomeManagement> {
  final List<Widget> _pages = [FossilMap(),const FossilsTable()];
  int _index = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          SafeArea(
            child: Container(
              margin: const EdgeInsets.only(left: 16),
              height: 40,
              width: 40,
              decoration: const BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(color: Colors.black12,
                  offset: Offset(0,3),
                  blurRadius: 8,)
                ],
              ),
              child: Icon(Icons.menu,color: Colors.black54,),
            ),
          ),
          _pages.elementAt(_index),
          Padding(
            padding: const EdgeInsets.all(30.0),
            child: Align(
              alignment: Alignment(0.0,1.0),
              child: ClipRRect(
                borderRadius: const BorderRadius.all(Radius.circular(30),
                ),
                child: BottomNavigationBar(
                  selectedItemColor: Colors.white,
                  unselectedItemColor: Colors.grey,
                  showSelectedLabels: true,
                  showUnselectedLabels: false,
                  backgroundColor: Colors.black26,
                  currentIndex: _index,
                  onTap: (int index) {
                    setState(() {
                      _index = index;
                    });
                  },
                  items: const [
                    BottomNavigationBarItem(
                        icon: Icon(Icons.map), label: 'Mappa'),
                    BottomNavigationBarItem(
                        icon: Icon(Icons.backpack), label: 'Fossili'),
                  ],


                ),
              ),
            ),
          )
        ],
      )
    );
  }
}

