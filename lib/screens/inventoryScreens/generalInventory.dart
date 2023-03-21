import 'package:flutter/material.dart';
import 'package:zboryar_application/database/hive/model/invWeapon.dart';



class generalInventory extends StatefulWidget {
  const generalInventory({Key? key}) : super(key: key);

  @override
  State<generalInventory> createState() => _generalInventoryState();
}

class _generalInventoryState extends State<generalInventory> {
  @override
  Widget build(BuildContext context) {
      return Container(
        child: Text("General Inventory"),
      );
  }
}
