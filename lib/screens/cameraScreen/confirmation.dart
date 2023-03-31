import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:getwidget/components/list_tile/gf_list_tile.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:zboryar_application/constants/constants.dart';
import 'package:zboryar_application/screens/inventoryScreens/generalInventory.dart';
import 'package:zboryar_application/screens/navigationPage.dart';

import '../../components/components.dart';
import '../../database/hive/model/boxes.dart';
import '../../database/hive/model/invWeapon.dart';
import '../../database/storage.dart';
import '../../domain/weapon.dart';

class confirmWeapons extends StatefulWidget {
  List<Weapon> wpnList = [];
  confirmWeapons({Key? key, required this.wpnList}) : super(key: key);

  @override
  State<confirmWeapons> createState() => _confirmWeaponsState();
}

class _confirmWeaponsState extends State<confirmWeapons> {
  @override
  Widget build(BuildContext context) {
    var my_list = widget.wpnList.toList();
    print(my_list[0].quantity);

    //Displaying listTiles of weapons
    return Scaffold(
      appBar: AppBar(
        title: const Text('Items Scanned'),
        backgroundColor: bg_login,
        leading: IconButton(
          onPressed: (){
            my_list.clear();
            Navigator.of(context).pop();
          }, icon: const Icon(Icons.arrow_back_ios),
        ),
      ),
      body: ListView.builder(
        itemCount: my_list.length,
        itemBuilder: (context, index) {
          return Dismissible(
            background: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(20)),
                color: Colors.red,
              ),
            ),
            confirmDismiss: (direction) => deleteDialog(context, direction),
            key: Key(my_list[index].name),
            onDismissed: (direction) {
              print(my_list);
              print("===========");
              my_list.removeAt(index);
              print(my_list);
              ScaffoldMessenger.of(context).showSnackBar(
                  showSnackBar(context, '${my_list[index].name} dismissed'));
            },
            child: GFListTile(
              padding: EdgeInsets.all(15),
              margin: EdgeInsets.all(6),
              color: Colors.grey[400],
              titleText:
                  '${my_list[index].name} - Quantity: ${my_list[index].quantity}',
              subTitleText: '${my_list[index].type}',
              description: Text('${my_list[index].caliber}'),
              icon: SvgPicture.asset(
                "assets/icon/${my_list[index].type}.svg",
                width: 35,
                height: 32,
              ),
              onTap: () async {},
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          if(!my_list.isEmpty) {
            final StorageService _storageService = StorageService();
            String? _User = await _storageService.User();
            for (int i = 0; i <= my_list.length - 1; i++) {
              addWeapon(
                  my_list[i].name,
                  my_list[i].quantity,
                  my_list[i].type,
                  my_list[i].caliber,
                  _User!,
                  my_list[i].roundC,
                  my_list[i].magC);
            }
            my_list.clear();
            Navigator.of(context).pop();
            showSnackBar(context, "Weapons Added");
          } else{
            my_list.clear();
            Navigator.of(context).pop();
            showSnackBar(context, "No Weapons Added");
          }
        },
        child: Icon(
          Icons.check_circle,
          color: Colors.white,
          size: 55,
        ),
        backgroundColor: bg_login,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  //Hive Functionality to add a weapon to Hive
  addWeapon(String name, num quantity, String type, String caliber, String user,
      int rounds, int mags) async {
    final weapon = InventoryWeapon()
      ..Name = name
      ..Quantity = quantity
      ..Type = type
      ..Caliber = caliber
      ..User = user
      ..RoundCount = rounds
      ..MagCount = mags;

    final box = Boxes.getWeapons();
    final wpn = box.values.toList().cast<InventoryWeapon>();
    print("BOX + ${box}");
    if(!wpn.isEmpty) {
      for (int i = 0; i <= wpn.length - 1; i++) {
        if (wpn[i].Name == weapon.Name) {
          wpn[i].Quantity = wpn[i].Quantity + weapon.Quantity;
          wpn[i].save();
          return;
        }
      }
    }

    box.add(weapon);
  }
}
