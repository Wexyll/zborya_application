import 'package:animated_snack_bar/animated_snack_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:getwidget/components/list_tile/gf_list_tile.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:zboryar_application/constants/constants.dart';
import 'package:zboryar_application/database/hive/model/invWeapon.dart';
import 'package:grouped_list/grouped_list.dart';

import '../../database/hive/model/boxes.dart';
import '../../database/hive/model/squadWeapon.dart';
import '../../database/storage.dart';

class squadInventory extends StatefulWidget {
  const squadInventory({Key? key}) : super(key: key);

  @override
  State<squadInventory> createState() => _squadInventoryState();
}

class _squadInventoryState extends State<squadInventory> {

  String dropDownValue = 'Sniper';
  int quant = 0;
  bool isChecked = false;
  final TextEditingController name = TextEditingController();
  final TextEditingController type = TextEditingController();
  final TextEditingController sNum = TextEditingController();
  final TextEditingController caliber = TextEditingController();
  final TextEditingController soldier = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Squad Inventory"),
        backgroundColor: bg_login,
      ),
      body: Padding(
        padding: EdgeInsets.fromLTRB(0, 0, 0, 75),
        child: ValueListenableBuilder<Box<squadWeapon>>(
          valueListenable: Boxes.getSquadWeapons().listenable(),
          builder: (context, box, _) {
            final weapons = box.values.toList().cast<squadWeapon>();
            return buildContent(weapons);
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await addWeaponDialog();
          setState(() {});
        },
        child: Icon(
          Icons.add,
          color: Colors.white,
          size: 55,
        ),
        backgroundColor: bg_login,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  Widget buildContent(List<squadWeapon> weapons) {
    if (weapons.isEmpty) {
      return Center(
        child: Text(
          'No Weapons Added Yet',
          style: TextStyle(fontSize: 24),
        ),
      );
    } else {
      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: GroupedListView(
          shrinkWrap: true,
          elements: weapons,
          groupBy: (weapons) => weapons.Type,
          order: GroupedListOrder.ASC,
          useStickyGroupSeparators: true,
          groupSeparatorBuilder: (String value) => Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              value,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
          itemBuilder: (c, weapons) {
            return Dismissible(
              key: Key(weapons.Name),
              onDismissed: (direction) {
                setState(() {
                  weapons.delete();
                });
                ScaffoldMessenger.of(context)
                    .showSnackBar(SnackBar(content: Text('${weapons.Name} dismissed')));
              },
              child: GFListTile(
                padding: EdgeInsets.all(15),
                margin: EdgeInsets.all(6),
                color: Colors.grey[400],
                titleText: '${weapons.Name} - ID: ${weapons.Serial_Number}',
                subTitleText: '${weapons.Soldier}',
                description: Text('${weapons.Caliber}'),
                icon: SvgPicture.asset(
                  "assets/icon/${weapons.Type}.svg",
                  width: 35,
                  height: 32,
                ),
                onTap: () async {
                  await openDialog(weapons);
                  setState(() {});
                },
              ),
            );
          },
        ),
      );
    }
  }

  /*
  *
  *
  * FUNCTIONS START HERE
  *
  *
   */
  Future openDialog(var weapons) => showDialog(
    context: context,
    builder: (context) {
      return StatefulBuilder(
        builder: (context, setState) {
          String select = '';
          return AlertDialog(
            title: Text("Edit Weapon"),
            content: Container(
              height: 350,
              width: 400,
              child: ListView(
                children: [
                  Text("Assigned Firearm"),
                  TextFormField(
                    controller: soldier,
                    obscureText: false,
                    decoration: InputDecoration(
                      hintText: "Soldier Assigned",
                      filled: true,
                      fillColor: Colors.grey,
                      hintStyle: TextStyle(color: Colors.white),
                    ),
                  ),
                  TextFormField(
                    controller: name,
                    obscureText: false,
                    decoration: InputDecoration(
                      hintText: "Weapon Name",
                      filled: true,
                      fillColor: Colors.grey,
                      hintStyle: TextStyle(color: Colors.white),
                    ),
                  ),
                  TextFormField(
                    controller: sNum,
                    obscureText: false,
                    decoration: InputDecoration(
                      hintText: "Weapon Serial Number",
                      filled: true,
                      fillColor: Colors.grey,
                      hintStyle: TextStyle(color: Colors.white),
                    ),
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  DropdownButton<String>(
                    items: const [
                      DropdownMenuItem<String>(
                          value: "Sniper", child: Text("Sniper")),
                      DropdownMenuItem<String>(
                          value: "Rifle", child: Text("Rifle")),
                      DropdownMenuItem<String>(
                          value: "Pistol", child: Text("Pistol")),
                      DropdownMenuItem<String>(
                          value: "Shotgun", child: Text("Shotgun")),
                      DropdownMenuItem<String>(
                          value: "Sub_Machinegun",
                          child: Text("Sub_Machinegun")),
                      DropdownMenuItem<String>(
                          value: "Machinegun", child: Text("Machinegun")),
                      DropdownMenuItem<String>(
                          value: "Explosive", child: Text("Explosive")),
                      DropdownMenuItem<String>(
                          value: "Other", child: Text("Other")),
                    ],
                    value: dropDownValue,
                    onChanged: (value) => setState(() {
                      dropDownValue = value!;
                    }),
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  TextFormField(
                    controller: caliber,
                    obscureText: false,
                    decoration: InputDecoration(
                      hintText: "Caliber",
                      filled: true,
                      fillColor: Colors.grey,
                      hintStyle: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                    if (weapons.Name != name.text && name.text != '') {
                      weapons.Name = name.text;
                      name.clear();
                    }
                    if (weapons.Type != type.text && type.text != '') {
                      weapons.Type = type.text;
                      type.clear();
                    }
                    if (weapons.Caliber != caliber.text &&
                        caliber.text != '') {
                      weapons.Caliber = caliber.text;
                      caliber.clear();
                    }
                    if(weapons.Soldier != soldier.text && soldier.text != ''){
                      weapons.Soldier = soldier.text;
                      soldier.clear();
                    }
                    if(weapons.Serial_Number != sNum.text && sNum.text != ''){
                      weapons.Serial_Number = sNum.text;
                    }
                    weapons.save();
                    isChecked = false;
                    Navigator.pop(context);
                },
                child: Text("Okay"),
              ),
            ],
          );
        },
      );
    },
  );

  addWeaponDialog() => showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Text("Add Weapon"),
              content: Container(
                height: 350,
                width: 400,
                child: ListView(
                  children: [
                    Text("Assigned Firearm"),
                    TextFormField(
                      controller: name,
                      obscureText: false,
                      decoration: InputDecoration(
                        hintText: "Weapon Name",
                        filled: true,
                        fillColor: Colors.grey,
                        hintStyle: TextStyle(color: Colors.white),
                      ),
                    ),
                    TextFormField(
                      controller: soldier,
                      obscureText: false,
                      decoration: InputDecoration(
                        hintText: "Soldier Assigned",
                        filled: true,
                        fillColor: Colors.grey,
                        hintStyle: TextStyle(color: Colors.white),
                      ),
                    ),
                    TextFormField(
                      controller: sNum,
                      obscureText: false,
                      decoration: InputDecoration(
                        hintText: "Weapon Serial Number",
                        filled: true,
                        fillColor: Colors.grey,
                        hintStyle: TextStyle(color: Colors.white),
                      ),
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    DropdownButton<String>(
                      items: const [
                        DropdownMenuItem<String>(
                            value: "Sniper", child: Text("Sniper")),
                        DropdownMenuItem<String>(
                            value: "Rifle", child: Text("Rifle")),
                        DropdownMenuItem<String>(
                            value: "Pistol", child: Text("Pistol")),
                        DropdownMenuItem<String>(
                            value: "Shotgun", child: Text("Shotgun")),
                        DropdownMenuItem<String>(
                            value: "Sub_Machinegun",
                            child: Text("Sub_Machinegun")),
                        DropdownMenuItem<String>(
                            value: "Machinegun", child: Text("Machinegun")),
                        DropdownMenuItem<String>(
                            value: "Explosive", child: Text("Explosive")),
                        DropdownMenuItem<String>(
                            value: "Other", child: Text("Other")),
                      ],
                      value: dropDownValue,
                      onChanged: (value) => setState(() {
                        dropDownValue = value!;
                      }),
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    TextFormField(
                      controller: caliber,
                      obscureText: false,
                      decoration: InputDecoration(
                        hintText: "Caliber",
                        filled: true,
                        fillColor: Colors.grey,
                        hintStyle: TextStyle(color: Colors.white),
                      ),
                    ),
                    CheckboxListTile(
                        controlAffinity: ListTileControlAffinity.leading,
                        title: Text("Weapon From Inventory?"),
                        value: isChecked,
                        onChanged: (isChecked) => setState(() {this.isChecked = isChecked!;}))
                  ],
                ),
              ),
              actions: <Widget>[
                TextButton(
                  onPressed: () async {
                    if (name.text != '' && caliber.text != '' && soldier.text != '' && sNum.text != '') {
                      final StorageService _storageService = StorageService();
                      String? _User = await _storageService.User();
                      addSquadWeapon(name.text, dropDownValue, caliber.text, soldier.text, sNum.text, _User!);
                      AnimatedSnackBar(
                        mobileSnackBarPosition: MobileSnackBarPosition.top,
                        duration: Duration(milliseconds: 5),
                        snackBarStrategy: RemoveSnackBarStrategy(),
                        builder: ((context) {
                          return Container(
                            height: 40,
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.all(Radius.circular(20)),
                              color: bg_login,
                            ),
                            child: Text('Weapon Added', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: Colors.white),),
                          );
                        }),
                      ).show(context);
                      if(isChecked == true) {
                        final box = Boxes.getWeapons();
                        final wpn = box.values.toList().cast<InventoryWeapon>();
                        for(int i = 0; i <= wpn.length-1; i++){
                          if(wpn[i].Name == name.text){
                            if(wpn[i].Quantity > 1){
                              wpn[i].Quantity = wpn[i].Quantity-1;
                              wpn[i].save();
                            } else {
                              wpn[i].delete();
                            }
                          }
                        }
                      };
                      dropDownValue = 'Sniper';
                      caliber.clear();
                      soldier.clear();
                      sNum.clear();
                      name.clear();
                      isChecked = false;
                      Navigator.pop(context);
                    } else{
                      dropDownValue = 'Sniper';
                      caliber.clear();
                      soldier.clear();
                      sNum.clear();
                      name.clear();
                      isChecked = false;
                      AnimatedSnackBar(
                        mobileSnackBarPosition: MobileSnackBarPosition.top,
                        duration: Duration(milliseconds: 5),
                        snackBarStrategy: RemoveSnackBarStrategy(),
                        builder: ((context) {
                          return Container(
                            height: 40,
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.all(Radius.circular(20)),
                              color: bg_login,
                            ),
                            child: Text('No Weapons Added', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: Colors.white),),
                          );
                        }),
                      ).show(context);
                      Navigator.pop(context);
                    }
                  },
                  child: Text("Okay"),
                ),
              ],
            );
          },
        );
      });

  addSquadWeapon(String name, String type, String caliber, String sNum,
      String soldier, String user) async {
    final weapon = squadWeapon()
      ..Name = name
      ..Type = type
      ..Caliber = caliber
      ..Serial_Number = sNum
      ..Soldier = soldier
      ..User = user;

    final box = Boxes.getSquadWeapons();
    box.add(weapon);
  }
}
