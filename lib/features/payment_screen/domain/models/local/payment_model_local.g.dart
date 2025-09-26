// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'payment_model_local.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class PaymentModelAdapter extends TypeAdapter<PaymentModel> {
  @override
  final int typeId = 2;

  @override
  PaymentModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return PaymentModel(
      id: fields[0] as String,
      tripId: fields[1] as String?,
      payer: fields[2] as UserModel,
      shares: (fields[3] as List).cast<UserShareModel>(),
      date: fields[4] as int,
      title: fields[5] as String,
      amount: fields[6] as double,
      settled: fields[7] as bool,
      splitType: fields[8] as String,
    );
  }

  @override
  void write(BinaryWriter writer, PaymentModel obj) {
    writer
      ..writeByte(9)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.tripId)
      ..writeByte(2)
      ..write(obj.payer)
      ..writeByte(3)
      ..write(obj.shares)
      ..writeByte(4)
      ..write(obj.date)
      ..writeByte(5)
      ..write(obj.title)
      ..writeByte(6)
      ..write(obj.amount)
      ..writeByte(7)
      ..write(obj.settled)
      ..writeByte(8)
      ..write(obj.splitType);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PaymentModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
