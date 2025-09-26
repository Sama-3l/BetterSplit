// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'trip_model_local.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class TripModelAdapter extends TypeAdapter<TripModel> {
  @override
  final int typeId = 6;

  @override
  TripModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return TripModel(
      id: fields[0] as String,
      title: fields[1] as String,
      startDate: fields[2] as DateTime,
      endDate: fields[3] as DateTime,
      qrInfo: fields[4] as String,
      icon: fields[5] as String,
      goingOn: fields[6] as bool,
      stats: fields[7] as String,
      selectedCurrency: fields[8] as String,
      users: (fields[9] as List).cast<UserModel>(),
      payments: (fields[10] as List).cast<PaymentModel>(),
      ledger: (fields[11] as List).cast<LedgerModel>(),
      netBalance: (fields[12] as Map).cast<String, double>(),
    );
  }

  @override
  void write(BinaryWriter writer, TripModel obj) {
    writer
      ..writeByte(13)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.title)
      ..writeByte(2)
      ..write(obj.startDate)
      ..writeByte(3)
      ..write(obj.endDate)
      ..writeByte(4)
      ..write(obj.qrInfo)
      ..writeByte(5)
      ..write(obj.icon)
      ..writeByte(6)
      ..write(obj.goingOn)
      ..writeByte(7)
      ..write(obj.stats)
      ..writeByte(8)
      ..write(obj.selectedCurrency)
      ..writeByte(9)
      ..write(obj.users)
      ..writeByte(10)
      ..write(obj.payments)
      ..writeByte(11)
      ..write(obj.ledger)
      ..writeByte(12)
      ..write(obj.netBalance);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TripModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
