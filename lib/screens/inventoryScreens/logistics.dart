import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:getwidget/components/list_tile/gf_list_tile.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/adapters.dart';

import '../../constants/constants.dart';
import '../../database/hive/model/boxes.dart';
import '../../database/hive/model/invWeapon.dart';


class logisticsPage extends StatefulWidget {
  const logisticsPage({Key? key}) : super(key: key);

  @override
  State<logisticsPage> createState() => _logisticsPageState();
}

class _logisticsPageState extends State<logisticsPage> {
  final TextEditingController rounds = TextEditingController();
  final TextEditingController mags = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Logistical Page"),
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
    );
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
              '${value}',
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
          itemBuilder: (c, weapons) {
            int total = weapons.RoundCount * weapons.MagCount;
            num _totalA = (weapons.Quantity! * (weapons.RoundCount * weapons.MagCount));
            return GFListTile(
              padding: EdgeInsets.all(15),
              margin: EdgeInsets.all(6),
              color: Colors.grey[400],
              titleText: '${weapons.Name} - Q: ${weapons.Quantity}\nTotal Rounds: ${_totalA}',
              description: Text('\nMags: ${weapons.MagCount}\nRounds Per Gun ${total}'),
              icon: SvgPicture.asset(
                "assets/icon/${weapons.Type}.svg",
                width: 35,
                height: 32,
              ),
              onTap: () async {
                await openDialog(weapons);
                setState(() {});
              },
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
          return AlertDialog(
            title: Text("Edit Weapon"),
            content: Container(
              height: 130,
              width: 400,
              child: ListView(
                children: [
                  Text("${weapons.Name} - Round/Mag Count"),
                  TextFormField(
                    controller: rounds,
                    obscureText: false,
                    keyboardType: TextInputType.number,
                    inputFormatters: <TextInputFormatter>[
                      FilteringTextInputFormatter.digitsOnly
                    ],
                    decoration: InputDecoration(
                      hintText: "Round Count : ${weapons.RoundCount}",
                      filled: true,
                      fillColor: Colors.grey,
                      hintStyle: TextStyle(color: Colors.white),
                    ),
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  TextFormField(
                    controller: mags,
                    obscureText: false,
                    keyboardType: TextInputType.number,
                    inputFormatters: <TextInputFormatter>[
                      FilteringTextInputFormatter.digitsOnly
                    ],
                    decoration: InputDecoration(
                      hintText: "Mag Count : ${weapons.MagCount}",
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
                  Navigator.pop(context);
                },
                child: Text("Cancel"),
              ),
              TextButton(
                onPressed: () {
                    if (weapons.RoundCount != rounds.text && rounds.text != '') {
                      weapons.RoundCount = int.parse(rounds.text);
                      rounds.clear();
                    }
                    if (weapons.MagCount != mags.text && mags.text != '') {
                      weapons.MagCount = int.parse(mags.text);
                      mags.clear();
                    }
                    weapons.save();
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
}
