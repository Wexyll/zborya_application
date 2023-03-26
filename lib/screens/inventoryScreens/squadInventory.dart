import 'dart:convert';

import 'package:animated_snack_bar/animated_snack_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:getwidget/components/list_tile/gf_list_tile.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:zboryar_application/constants/constants.dart';
import 'package:zboryar_application/database/hive/model/invWeapon.dart';
import 'package:grouped_list/grouped_list.dart';

import '../../components/components.dart';
import '../../database/hive/model/boxes.dart';
import '../../database/hive/model/squadWeapon.dart';
import '../../database/storage.dart';

class squadInventory extends StatefulWidget {
  const squadInventory({Key? key}) : super(key: key);

  @override
  State<squadInventory> createState() => _squadInventoryState();
}

class _squadInventoryState extends State<squadInventory> {
  List categoriesList = [];
  String dropDownValue = 'Sniper';
  bool isWeaponFromInventory = false;
  final TextEditingController nameController = TextEditingController();
  final TextEditingController typeController = TextEditingController();
  final TextEditingController sNumController = TextEditingController();
  final TextEditingController caliberController = TextEditingController();
  final TextEditingController soldierController = TextEditingController();

  @override
  void initState() {
    super.initState();
    getCategories();
  }

  @override
  void dispose() {
    super.dispose();
    nameController.dispose();
    typeController.dispose();
    sNumController.dispose();
    caliberController.dispose();
    soldierController.dispose();
  }

  @override
  Widget build(BuildContext context) {


    return Scaffold(
      appBar: AppBar(
        title: Text("Squad Inventory"),
        backgroundColor: bg_login,
        automaticallyImplyLeading: false,
      ),
      body: Padding(
        padding: EdgeInsets.fromLTRB(0, 0, 0, 75),
        child: ValueListenableBuilder<Box>(
          valueListenable: Boxes.getSquadWeapons().listenable(),
          builder: (context, box, _) {
            final weaponsList = box.values.toList().cast<squadWeapon>();
            return buildSquadInventoryList(weaponsList);
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await addWeaponDialog();
        },
        child: Icon(
          Icons.add,
          color: Colors.white,
          size: 55,
        ),
        backgroundColor: bg_login,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      // drawer: const NavigationDrawer(),
    );
  }

  /*
  *
  * BUILD CONTENT
  *
   */

  Widget buildSquadInventoryList(List<squadWeapon> weaponsList) {
    if (weaponsList.isEmpty) {
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
          elements: weaponsList,
          groupBy: (singleWeapon) => singleWeapon.Type,
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
          itemBuilder: (c, singleWeapon) {
            return Dismissible(
              background: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                  color: Colors.red,
                ),
              ),
              confirmDismiss: (direction) => deleteDialog(direction),
              key: Key(singleWeapon.key.toString()),
              onDismissed: (direction) {
                singleWeapon.delete();
                ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('${singleWeapon.Name} dismissed')));
              },
              child: GFListTile(
                padding: EdgeInsets.all(15),
                margin: EdgeInsets.all(6),
                color: Colors.grey[400],
                titleText: '${singleWeapon.Name} - ID: ${singleWeapon.Soldier}',
                subTitleText: '${singleWeapon.Caliber}',
                description: Text('${singleWeapon.Serial_Number}'),
                icon: SvgPicture.asset(
                  "assets/icon/${singleWeapon.Type}.svg",
                  width: 35,
                  height: 32,
                ),
                onTap: () async {
                  await openEditWeaponDetailsDialog(singleWeapon);
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
  Future openEditWeaponDetailsDialog(var weapons) => showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          return StatefulBuilder(
            builder: (context, setState) {
              return AlertDialog(
                title: Text("Edit Weapon"),
                content: Container(
                  height: 350,
                  width: 400,
                  child: ListView(
                    children: [
                      buildTextField(
                          textController: soldierController,
                          hintText: "Soldier Assigned"),
                      SizedBox(
                        height: 8,
                      ),
                      buildTextField(
                          textController: nameController,
                          hintText: "Weapon Name"),
                      SizedBox(
                        height: 8,
                      ),
                      buildTextField(
                          textController: sNumController,
                          hintText: "Weapon Serial Number"),
                      SizedBox(
                        height: 8,
                      ),
                      DropdownButton<String>(
                        items: [
                          for(String category in categoriesList) DropdownMenuItem<String>(value: category, child: Text(category)),
                        ],
                        value: dropDownValue,
                        onChanged: (value) => setState(() {
                          dropDownValue = value!;
                          typeController.text = value;
                        }),
                      ),
                      SizedBox(height: 8),
                      buildTextField(
                          textController: caliberController,
                          hintText: "Caliber"),
                    ],
                  ),
                ),
                actions: <Widget>[
                  TextButton(
                    onPressed: () {
                      if (weapons.Name != nameController.text &&
                          nameController.text != '') {
                        weapons.Name = nameController.text;
                        nameController.clear();
                      }
                      if (weapons.Type != typeController.text &&
                          typeController.text != '') {
                        weapons.Type = typeController.text;
                        typeController.clear();
                      }
                      if (weapons.Caliber != caliberController.text &&
                          caliberController.text != '') {
                        weapons.Caliber = caliberController.text;
                        caliberController.clear();
                      }
                      if (weapons.Soldier != soldierController.text &&
                          soldierController.text != '') {
                        weapons.Soldier = soldierController.text;
                        soldierController.clear();
                      }
                      if (weapons.Serial_Number != sNumController.text &&
                          sNumController.text != '') {
                        weapons.Serial_Number = sNumController.text;
                      }
                      weapons.save();
                      isWeaponFromInventory = false;
                      Navigator.pop(context);
                    },
                    child: Text("Okay"),
                  ),
                  TextButton(
                    onPressed: () {
                      resetModalFields();
                      return Navigator.pop(context);
                    },
                    child: Text("Cancel"),
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
                    TextFormField(
                      controller: soldierController,
                      obscureText: false,
                      decoration: InputDecoration(
                        hintText: "Soldier Assigned",
                        filled: true,
                        fillColor: Colors.grey,
                        hintStyle: TextStyle(color: Colors.white),
                      ),
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    TextFormField(
                      controller: nameController,
                      obscureText: false,
                      decoration: InputDecoration(
                        hintText: "Weapon Name",
                        filled: true,
                        fillColor: Colors.grey,
                        hintStyle: TextStyle(color: Colors.white),
                      ),
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    TextFormField(
                      controller: sNumController,
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
                      controller: caliberController,
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
                        value: isWeaponFromInventory,
                        onChanged: (isChecked) => setState(() {
                              this.isWeaponFromInventory = isChecked!;
                            }))
                  ],
                ),
              ),
              actions: <Widget>[
                TextButton(
                  onPressed: () async {
                    if (nameController.text != '' &&
                        caliberController.text != '' &&
                        soldierController.text != '' &&
                        sNumController.text != '') {
                      final StorageService _storageService = StorageService();
                      String? _User = await _storageService.User();
                      addSquadWeapon(
                          nameController.text,
                          dropDownValue,
                          caliberController.text,
                          sNumController.text,
                          soldierController.text,
                          _User!);
                      AnimatedSnackBar(
                        mobileSnackBarPosition: MobileSnackBarPosition.top,
                        duration: Duration(milliseconds: 5),
                        snackBarStrategy: RemoveSnackBarStrategy(),
                        builder: ((context) {
                          return Container(
                            height: 40,
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(20)),
                              color: bg_login,
                            ),
                            child: Text(
                              'Weapon Added',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20,
                                  color: Colors.white),
                            ),
                          );
                        }),
                      ).show(context);
                      if (isWeaponFromInventory == true) {
                        final box = Boxes.getWeapons();
                        final wpn = box.values.toList().cast<InventoryWeapon>();
                        for (int i = 0; i <= wpn.length - 1; i++) {
                          if (wpn[i].Name == nameController.text) {
                            if (wpn[i].Quantity > 1) {
                              wpn[i].Quantity = wpn[i].Quantity - 1;
                              wpn[i].save();
                            } else {
                              wpn[i].delete();
                            }
                          }
                        }
                      }
                      ;
                      dropDownValue = 'Sniper';
                      caliberController.clear();
                      soldierController.clear();
                      sNumController.clear();
                      nameController.clear();
                      isWeaponFromInventory = false;
                      Navigator.pop(context);
                    } else {
                      dropDownValue = 'Sniper';
                      caliberController.clear();
                      soldierController.clear();
                      sNumController.clear();
                      nameController.clear();
                      isWeaponFromInventory = false;
                      AnimatedSnackBar(
                        mobileSnackBarPosition: MobileSnackBarPosition.top,
                        duration: Duration(milliseconds: 5),
                        snackBarStrategy: RemoveSnackBarStrategy(),
                        builder: ((context) {
                          return Container(
                            height: 40,
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(20)),
                              color: bg_login,
                            ),
                            child: Text(
                              'No Weapons Added',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20,
                                  color: Colors.white),
                            ),
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

  Future<bool?> deleteDialog(DismissDirection direction) async {
    return await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
            title: Text("Delete Weapon?"),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(true);
                },
                child: Text("Okay"),
              ),
              TextButton(
                onPressed: () {
                  return Navigator.of(context).pop(false);
                },
                child: Text("Cancel"),
              ),
            ],
          ),
        ) ??
        false;
  }

  Future getCategories() async {
    final String response = await rootBundle.loadString(
        'assets/json/categories.json');
    final data = await json.decode(response);
    categoriesList = data.toList();
  }

  resetModalFields() {
    typeController.clear();
    soldierController.clear();
    nameController.clear();
    caliberController.clear();
    dropDownValue = 'Sniper';
  }
}


/*
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
 */
