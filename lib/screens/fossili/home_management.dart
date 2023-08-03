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
      body: _pages[_index],
      bottomNavigationBar: BottomNavigationBar(
        elevation: 15,
        backgroundColor: const Color.fromRGBO(210, 180, 140, 1),
        selectedItemColor: Colors.white,
        showSelectedLabels: true,
        showUnselectedLabels: false,
        onTap: (selectedIndex) {
          setState(() {
            _index = selectedIndex;
          });
        },
        currentIndex: _index,
        items: const [
          BottomNavigationBarItem(
              icon: Icon(Icons.map), label: 'Mappa'),
          BottomNavigationBarItem(
              icon: Icon(Icons.backpack), label: 'Fossili'),
        ],
      ),
    );
  }
}

