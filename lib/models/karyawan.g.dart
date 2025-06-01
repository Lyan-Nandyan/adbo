// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'karyawan.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class KaryawanAdapter extends TypeAdapter<Karyawan> {
  @override
  final int typeId = 0;

  @override
  Karyawan read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Karyawan(
      nama: fields[1] as String,
      password: fields[2] as String,
      jabatan: fields[3] as String,
      cuti: fields[4] as String?,
    )..id = fields[0] as String?;
  }

  @override
  void write(BinaryWriter writer, Karyawan obj) {
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
      ..write(obj.cuti);
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
