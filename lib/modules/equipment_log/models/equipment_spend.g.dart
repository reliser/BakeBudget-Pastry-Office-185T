// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'equipment_spend.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class EquipmentSpendAdapter extends TypeAdapter<EquipmentSpend> {
  @override
  final int typeId = 6;

  @override
  EquipmentSpend read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return EquipmentSpend(
      amount: fields[0] as double,
      date: fields[1] as DateTime,
      equipmentName: fields[2] as String,
    );
  }

  @override
  void write(BinaryWriter writer, EquipmentSpend obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.amount)
      ..writeByte(1)
      ..write(obj.date)
      ..writeByte(2)
      ..write(obj.equipmentName);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is EquipmentSpendAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
