import 'package:hive/hive.dart';

part 'squadWeapon.g.dart';

@HiveType(typeId: 1)
class squadWeapon extends HiveObject{
  @HiveField(0)
  late String Name;

  @HiveField(1)
  late String Type;

  @HiveField(3)
  late String Caliber;

  @HiveField(4)
  late String Serial_Number;

  @HiveField(5)
  late String Soldier;

  @HiveField(6)
  late String User;
}