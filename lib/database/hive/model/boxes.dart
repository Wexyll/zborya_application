import 'package:hive/hive.dart';
import 'package:zboryar_application/database/hive/model/squadWeapon.dart';
import 'invWeapon.dart';

class Boxes {
  static Box<InventoryWeapon> getWeapons() =>
      Hive.box<InventoryWeapon>('inventoryWeapons');

  static Box<squadWeapon> getSquadWeapons() =>
      Hive.box<squadWeapon>('squadWeapons');
}