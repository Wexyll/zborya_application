import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:getwidget/components/list_tile/gf_list_tile.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:zboryar_application/constants/constants.dart';

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
    var my_list = widget.wpnList;
    print(my_list[0].quantity);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Items Scanned'),
        backgroundColor: bg_login,
      ),
      body: ListView.builder(
        itemCount: widget.wpnList.length,
        itemBuilder: (context, index) {

          return GFListTile(
            padding: EdgeInsets.all(15),
            margin: EdgeInsets.all(6),
            color: Colors.grey[400],
            titleText: '${widget.wpnList[index].name} - Quantity: ${my_list[index].quantity}',
            subTitleText: '${widget.wpnList[index].type}',
            description: Text('${widget.wpnList[index].caliber}'),
            icon: SvgPicture.asset(
              "assets/icon/${widget.wpnList[index].type}.svg",
              width: 35,
              height: 32,
            ),
            onTap: () async {
              await openDialog(index, my_list);
              setState(() {

              });
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final StorageService _storageService = StorageService();
          String? _User = await _storageService.User();
          for(int i = 0; i<= my_list.length-1; i++){
            addWeapon(my_list[i].name, my_list[i].quantity, my_list[i].type, my_list[i].caliber, _User!, my_list[i].roundC, my_list[i].magC);
          }
          Navigator.of(context).pop();
        },
        child: Icon(Icons.check_circle, color: Colors.white, size: 55,),
        backgroundColor: bg_login,

      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
  Future openDialog(int index, var my_list) => showDialog(
    context: context,
    builder: (context) {
      return StatefulBuilder(
        builder: (context, setState) {
          return Column(
            children: [
              AlertDialog(
                title: Text("Change ${my_list[index].name} Quantity"),
                content: NumberPicker(
                  value: my_list[index].quantity,
                  minValue: 0,
                  maxValue: 1000,
                  step: 1,
                  haptics: true,
                  onChanged: (value) =>
                      setState(() {
                        my_list[index].quantity = value;
                      }),
                ),
                actions: <Widget>[
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text("Okay"),
                  ),
                ],
              ),
            ],
          );
        },
      );
    },

  );
  //Hive Functionality to add a weapon to Hive
  addWeapon(String name, num quantity, String type, String caliber, String user, int rounds, int mags) async {
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
}
/*Goes between the ontap {}
{
                showDialog(
                  context: context,
                  builder: (context) {
                    int num = widget.wpnList[index].quantity;
                    return StatefulBuilder(
                      builder: (context, setState) {
                        return AlertDialog(
                          title: Text("Title of Dialog"),
                          content: NumberPicker(
                            value: widget.wpnList[index].quantity,
                            minValue: 0,
                            maxValue: 1000,
                            step: 1,
                            haptics: true,
                            onChanged: (value) => setState(() {
                              widget.wpnList[index].quantity = value;
                              quant = widget.wpnList[index].quantity;
                            }),
                          ),
                          actions: <Widget>[
                            TextButton(
                              onPressed: () {
                                setState(() {
                                  widget.wpnList[index].quantity;
                                quant = widget.wpnList[index].quantity;});
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
                setState(() {
                  widget.wpnList[index].quantity;
                  quant = widget.wpnList[index].quantity;
                });
                quant = widget.wpnList[index].quantity;
              });
 */
