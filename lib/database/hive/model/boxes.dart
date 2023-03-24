import 'package:hive/hive.dart';
import 'package:zboryar_application/database/hive/model/squadWeapon.dart';
import 'invWeapon.dart';

class Boxes {
  static Box<InventoryWeapon> getWeapons() =>
      Hive.box<InventoryWeapon>('inventoryWeapons');

  static Box<squadWeapon> getSquadWeapons() =>
      Hive.box<squadWeapon>('squadWeapons');
}

/*
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
 */