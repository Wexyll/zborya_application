import 'package:hive/hive.dart';
import 'invWeapon.dart';

class Boxes {
  static Box<InventoryWeapon> getWeapons() =>
      Hive.box<InventoryWeapon>('inventoryWeapons');
}