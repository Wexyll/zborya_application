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
import '../../database/storage.dart';

class generalInventory extends StatefulWidget {
  const generalInventory({Key? key}) : super(key: key);

  @override
  State<generalInventory> createState() => _generalInventoryState();
}

class _generalInventoryState extends State<generalInventory> {
  String dropDownValue = 'Sniper';
  int quant = 0;
  final TextEditingController roundsController = TextEditingController();
  final TextEditingController magsController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController quantityController = TextEditingController();
  final TextEditingController typeController = TextEditingController();
  final TextEditingController caliberController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("General Inventory"),
        backgroundColor: bg_login,
        automaticallyImplyLeading: false,
      ),
      body: Padding(
        padding: EdgeInsets.fromLTRB(0, 0, 0, 75),
        child: ValueListenableBuilder<Box<InventoryWeapon>>(
            valueListenable: Boxes.getWeapons().listenable(),
            builder: (context, box, _) {
              final weapons = box.values.toList().cast<InventoryWeapon>();
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
                    Text("Quantity"),
                    NumberPicker(
                      value: quant,
                      minValue: 0,
                      maxValue: 1000,
                      step: 1,
                      haptics: true,
                      onChanged: (value) => setState(() {
                        quant = value;
                      }),
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
                    SizedBox(
                      height: 8,
                    ),
                    TextFormField(
                      controller: roundsController,
                      obscureText: false,
                      decoration: InputDecoration(
                        hintText: "Round Count",
                        filled: true,
                        fillColor: Colors.grey,
                        hintStyle: TextStyle(color: Colors.white),
                      ),
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    TextFormField(
                      controller: magsController,
                      obscureText: false,
                      decoration: InputDecoration(
                        hintText: "Magazine Count",
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
                  onPressed: () async {
                    if (nameController.text != '' && quant != 0 && caliberController.text != '') {
                      final StorageService _storageService = StorageService();
                      String? _User = await _storageService.User();
                      int roundC = 0;
                      int magC = 0;
                      if (roundsController.text != '') {
                        roundC = int.parse(roundsController.text);
                      }
                      if(magsController.text != '') {
                        magC = int.parse(magsController.text);
                      }
                      addWeapon(nameController.text, quant, dropDownValue, caliberController.text, _User!, roundC, magC);
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
                      quant = 0;
                      dropDownValue = 'Sniper';
                      caliberController.clear();
                      nameController.clear();
                      Navigator.pop(context);
                    } else{
                      nameController.clear();
                      quant = 0;
                      dropDownValue = 'Sniper';
                      caliberController.clear();
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
      });
  addWeapon(String name, num quantity, String type, String caliber,
      String user, int rounds, int mags) async {
    final weapon = InventoryWeapon()
      ..Name = name
      ..Quantity = quantity
      ..Type = type
      ..Caliber = caliber
      ..User = user
      ..RoundCount = rounds
      ..MagCount = mags;

    final box = Boxes.getWeapons();
    box.add(weapon);
  }

  Widget buildContent(List<InventoryWeapon> weapons) {
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
                background: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                    color: Colors.red,
                  ),
                ),
                confirmDismiss: (direction) => deleteDialog(context, direction),
                key: Key(weapons.key.toString()),
                onDismissed: (direction) {
                  weapons.delete();
                  ScaffoldMessenger.of(context).showSnackBar(
                      showSnackBar(context, '${weapons.Name} dismissed'));
                },
                child: GFListTile(
                  padding: EdgeInsets.all(15),
                  margin: EdgeInsets.all(6),
                  color: Colors.grey[400],
                  titleText: '${weapons.Name} - Quantity: ${weapons.Quantity}',
                  subTitleText: '${weapons.Type}',
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
                      Text("${weapons.Name} Quantity"),
                      NumberPicker(
                        value: weapons.Quantity,
                        minValue: 0,
                        maxValue: 1000,
                        step: 1,
                        haptics: true,
                        onChanged: (value) => setState(() {
                          weapons.Quantity = value;
                        }),
                      ),
                      TextFormField(
                        controller: nameController,
                        obscureText: false,
                        decoration: InputDecoration(
                          hintText: "${weapons.Name}",
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
                        value: weapons.Type,
                        onChanged: (value) => setState(() {
                          weapons.Type = value!;
                        }),
                      ),
                      SizedBox(
                        height: 8,
                      ),
                      TextFormField(
                        controller: caliberController,
                        obscureText: false,
                        decoration: InputDecoration(
                          hintText: "${weapons.Caliber}",
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
                      if (weapons.Quantity != 0) {
                        if (weapons.Name != nameController.text && nameController.text != '') {
                          weapons.Name = nameController.text;
                          nameController.clear();
                        }
                        if (weapons.Type != typeController.text && typeController.text != '') {
                          weapons.Type = typeController.text;
                          typeController.clear();
                        }
                        if (weapons.Caliber != caliberController.text &&
                            caliberController.text != '') {
                          weapons.Caliber = caliberController.text;
                          caliberController.clear();
                        }
                        weapons.save();
                        Navigator.pop(context);
                      } else {
                        weapons.delete();
                        Navigator.pop(context);
                      }
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

  resetModalFields() {
    typeController.clear();
    nameController.clear();
    caliberController.clear();
    quantityController.clear();
    magsController.clear();
    roundsController.clear();
    dropDownValue = 'Sniper';
  }
}