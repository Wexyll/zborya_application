import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:zboryar_application/screens/inventoryScreens/squadInventory.dart';

import '../constants/constants.dart';
import 'cameraScreen/camera.dart';
import 'inventoryScreens/generalInventory.dart';
import 'inventoryScreens/logistics.dart';

class navigationPage extends StatefulWidget {
  @override
  State<navigationPage> createState() => _navigationPageState();
}

class _navigationPageState extends State<navigationPage> {
  int _currentIndex = 0;
  List<Widget> _Nav =  <Widget>[
    squadInventory(),
    generalInventory(),
    cameraPage(),
    logisticsPage(),
  ];


  @override
  Widget build(BuildContext context) => Scaffold(
    body: Center(child: _Nav.elementAt(_currentIndex)),
          bottomNavigationBar: Container(
            color: bg_login,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: GNav(
              tabBorderRadius: 28,
              backgroundColor: bg_login,
              color: Colors.white,
              activeColor: selected,
              tabBackgroundColor: highlight,
              gap: 8,
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 13),
              selectedIndex: _currentIndex,
              onTabChange: (index){
                setState(() {
                  _currentIndex = index;
                });
              },
              tabs: [
                GButton(
                  icon: Icons.storage,
                  text: 'Inventory',
                ),
                GButton(
                  icon: Icons.data_usage,
                  text: 'Squad',
                ),
                GButton(
                  icon: Icons.camera_alt,
                  text: 'Camera',
                ),
                GButton(
                  icon: Icons.note_alt,
                  text: 'Logistics',
                ),
              ],
            ),
            ),
          ),
  );

}
