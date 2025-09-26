// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_share_model_local.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class UserShareModelAdapter extends TypeAdapter<UserShareModel> {
  @override
  final int typeId = 3;

  @override
  UserShareModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return UserShareModel(
      user: fields[0] as UserModel,
      amount: fields[1] as double?,
      percentage: fields[2] as double?,
    );
  }

  @override
  void write(BinaryWriter writer, UserShareModel obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.user)
      ..writeByte(1)
      ..write(obj.amount)
      ..writeByte(2)
      ..write(obj.percentage);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserShareModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
