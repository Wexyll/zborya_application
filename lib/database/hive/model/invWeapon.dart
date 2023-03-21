import 'package:hive/hive.dart';

part 'invWeapon.g.dart';

@HiveType(typeId: 0)
class InventoryWeapon extends HiveObject{
  @HiveField(0)
  late String Name;

  @HiveField(1)
  late num Quantity;

  @HiveField(2)
  late String Type;

  @HiveField(3)
  late String Caliber;

  @HiveField(4)
  late String User;
}