// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ledger_model_local.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class LedgerModelAdapter extends TypeAdapter<LedgerModel> {
  @override
  final int typeId = 5;

  @override
  LedgerModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return LedgerModel(
      id: fields[0] as String,
      tripId: fields[1] as String?,
      payer: fields[2] as UserModel,
      friend: fields[3] as UserModel,
      amount: fields[4] as double,
      completed: fields[5] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, LedgerModel obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.tripId)
      ..writeByte(2)
      ..write(obj.payer)
      ..writeByte(3)
      ..write(obj.friend)
      ..writeByte(4)
      ..write(obj.amount)
      ..writeByte(5)
      ..write(obj.completed);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is LedgerModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
