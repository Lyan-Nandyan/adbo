// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'hrd.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class HrdAdapter extends TypeAdapter<Hrd> {
  @override
  final int typeId = 1;

  @override
  Hrd read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Hrd(
      nama: fields[1] as String,
      password: fields[2] as String,
      jabatan: fields[3] as String,
      email: fields[4] as String,
    )..id = fields[0] as String?;
  }

  @override
  void write(BinaryWriter writer, Hrd obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.nama)
      ..writeByte(2)
      ..write(obj.password)
      ..writeByte(3)
      ..write(obj.jabatan)
      ..writeByte(4)
      ..write(obj.email);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is HrdAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
