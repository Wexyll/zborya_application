class Weapon {

  Weapon();

  Weapon.create({
   required this.name,
   required this.quantity,
   required this.type,
   required this.caliber,
  });

  late String name;
  late int quantity;
  late String type;
  late String caliber;
}