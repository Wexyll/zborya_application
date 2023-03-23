// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'squadWeapon.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class squadWeaponAdapter extends TypeAdapter<squadWeapon> {
  @override
  final int typeId = 1;

  @override
  squadWeapon read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return squadWeapon()
      ..Name = fields[0] as String
      ..Type = fields[1] as String
      ..Caliber = fields[3] as String
      ..Serial_Number = fields[4] as String
      ..Soldier = fields[5] as String
      ..User = fields[6] as String;
  }

  @override
  void write(BinaryWriter writer, squadWeapon obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.Name)
      ..writeByte(1)
      ..write(obj.Type)
      ..writeByte(3)
      ..write(obj.Caliber)
      ..writeByte(4)
      ..write(obj.Serial_Number)
      ..writeByte(5)
      ..write(obj.Soldier)
      ..writeByte(6)
      ..write(obj.User);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is squadWeaponAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
