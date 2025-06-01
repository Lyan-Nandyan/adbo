// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'manager.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class KaryawanAdapter extends TypeAdapter<Karyawan> {
  @override
  final int typeId = 2;

  @override
  Karyawan read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Karyawan(
      nama: fields[0] as String,
      password: fields[1] as String,
      jabatan: fields[2] as String,
    );
  }

  @override
  void write(BinaryWriter writer, Karyawan obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.nama)
      ..writeByte(1)
      ..write(obj.password)
      ..writeByte(2)
      ..write(obj.jabatan);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is KaryawanAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
