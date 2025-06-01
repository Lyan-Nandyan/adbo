// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'absensi.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class KaryawanAdapter extends TypeAdapter<Karyawan> {
  @override
  final int typeId = 3;

  @override
  Karyawan read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Karyawan(
      nama: fields[0] as String,
      idKaryawan: fields[1] as String,
      checkIn: fields[2] as DateTime?,
      checkOut: fields[3] as DateTime?,
    );
  }

  @override
  void write(BinaryWriter writer, Karyawan obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.nama)
      ..writeByte(1)
      ..write(obj.idKaryawan)
      ..writeByte(2)
      ..write(obj.checkIn)
      ..writeByte(3)
      ..write(obj.checkOut);
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
