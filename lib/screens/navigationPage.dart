import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:zboryar_application/screens/inventoryScreens/squadInventory.dart';

import '../constants/constants.dart';
import '../database/item.dart';
import '../database/storage.dart';
import 'LoginForm.dart';
import 'cameraScreen/camera.dart';
import 'inventoryScreens/generalInventory.dart';
import 'inventoryScreens/logistics.dart';
import 'login.dart';

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
  //Build method of the navigation bar that will hold all of the seperate pages to be displayed
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
                  text: 'Squad',
                ),
                GButton(
                  icon: Icons.data_usage,
                  text: 'Inventory',
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
    drawer: NavigationDrawer(),
  );
}
class NavigationDrawer extends StatelessWidget{
  NavigationDrawer({Key? key}) : super(key: key)
  {}
  @override
  Widget build(BuildContext context) => Drawer(
    child: SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          buildMenuItems(context),
        ],
      ),
    ),
  );


  Widget buildMenuItems(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 15),
    child: Wrap(
      runSpacing: 12,
      children: [ListTile(
          leading: const Icon(Icons.logout),
          title: const Text("Logout"),
          onTap: () async {
            final StorageService _storageService = StorageService();
            final encryptData eIsLoggedIn = encryptData("isLoggedIn", "true");
            _storageService.deleteSecureData(eIsLoggedIn);
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => LoginScreen()),
            );
          },
        ),
  ],
    ),
  );
}
