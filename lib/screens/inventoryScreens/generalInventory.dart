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
  List categoriesList = [];
  List caliberList = [];
  String dropDownValue = 'Sniper';
  String caliberDropDown = '9x19mm NATO';
  int quant = 0;
  final TextEditingController roundsController = TextEditingController();
  final TextEditingController magsController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController quantityController = TextEditingController();
  final TextEditingController typeController = TextEditingController();
  final TextEditingController caliberController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getCategories();
    getCalibers();
  }

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
      barrierDismissible: false,
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
                    buildTextField(textController: nameController, hintText: "Weapon Name"),
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
                    SizedBox(
                      height: 8,
                    ),
                    DropdownButton<String>(
                      items: [
                        for(String caliber in caliberList) DropdownMenuItem<String>(value: caliber, child: Text(caliber)),
                      ],
                      value: caliberDropDown,
                      onChanged: (value) => setState(() {
                        caliberDropDown = value!;
                        caliberController.text = value!;
                      }),
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    buildTextField(textController: roundsController, hintText: "Round Count"),
                    SizedBox(
                      height: 8,
                    ),
                    buildTextField(textController: magsController, hintText: "Magazine Count"),
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
                      showSnackBar(context, "Weapon Added");
                      quant = 0;
                      resetModalFields();
                      Navigator.pop(context);
                    } else{
                      quant = 0;
                      resetModalFields();
                      showSnackBar(context, "No Weapons Added");
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
      barrierDismissible: false,
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
                      buildTextField(textController: nameController, hintText: "${weapons.Name}"),
                      SizedBox(
                        height: 8,
                      ),
                      DropdownButton<String>(
                        items: [
                          for(String category in categoriesList) DropdownMenuItem<String>(value: category, child: Text(category)),
                        ],
                        value: weapons.Type,
                        onChanged: (value) => setState(() {
                          weapons.Type = value!;
                        }),
                      ),
                      SizedBox(
                        height: 8,
                      ),
                      DropdownButton<String>(
                        items: [
                          for(String caliber in caliberList) DropdownMenuItem<String>(value: caliber, child: Text(caliber)),
                        ],
                        value: weapons.Caliber,
                        onChanged: (value) => setState(() {
                          weapons.Caliber = value!;
                        }),
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
                        weapons.save();
                        resetModalFields();
                        Navigator.pop(context);
                      } else {
                        weapons.delete();
                        resetModalFields();
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

  Future getCategories() async {
    final String response = await rootBundle.loadString(
        'assets/json/categories.json');
    final data = await json.decode(response);
    categoriesList = data.toList();
  }
  Future getCalibers() async {
    final String response = await rootBundle.loadString(
        'assets/json/caliber.json');
    final data = await json.decode(response);
    caliberList = data.toList();
  }
}