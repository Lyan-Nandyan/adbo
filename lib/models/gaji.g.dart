// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'gaji.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class KaryawanAdapter extends TypeAdapter<Karyawan> {
  @override
  final int typeId = 4;

  @override
  Karyawan read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Karyawan(
      idKaryawan: fields[0] as String,
      gaji: fields[2] as int,
    );
  }

  @override
  void write(BinaryWriter writer, Karyawan obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.idKaryawan)
      ..writeByte(2)
      ..write(obj.gaji);
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
