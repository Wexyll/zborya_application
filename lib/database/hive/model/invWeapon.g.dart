// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'invWeapon.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class InventoryWeaponAdapter extends TypeAdapter<InventoryWeapon> {
  @override
  final int typeId = 0;

  @override
  InventoryWeapon read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return InventoryWeapon()
      ..Name = fields[0] as String
      ..Quantity = fields[1] as num
      ..Type = fields[2] as String
      ..Caliber = fields[3] as String
      ..User = fields[4] as String;
  }

  @override
  void write(BinaryWriter writer, InventoryWeapon obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.Name)
      ..writeByte(1)
      ..write(obj.Quantity)
      ..writeByte(2)
      ..write(obj.Type)
      ..writeByte(3)
      ..write(obj.Caliber)
      ..writeByte(4)
      ..write(obj.User);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is InventoryWeaponAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
