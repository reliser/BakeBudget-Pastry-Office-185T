// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'equipment_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class EquipmentAdapter extends TypeAdapter<Equipment> {
  @override
  final int typeId = 1;

  @override
  Equipment read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Equipment(
      name: fields[0] as String,
      cost: fields[1] as double,
      notificationEnabled: fields[2] as bool,
      notificationDate: fields[3] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, Equipment obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.name)
      ..writeByte(1)
      ..write(obj.cost)
      ..writeByte(2)
      ..write(obj.notificationEnabled)
      ..writeByte(3)
      ..write(obj.notificationDate);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is EquipmentAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
