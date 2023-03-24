class Weapon {

  Weapon();

  Weapon.create({
   required this.name,
   required this.quantity,
   required this.type,
   required this.caliber,
    required this.roundC,
    required this.magC,
  });

  late String name;
  late int quantity;
  late String type;
  late String caliber;
  late int roundC;
  late int magC;
}