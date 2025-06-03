// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cuti.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class CutiAdapter extends TypeAdapter<Cuti> {
  @override
  final int typeId = 5;

  @override
  Cuti read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Cuti(
      nama: fields[1] as String,
      idKaryawan: fields[2] as String,
      jabatan: fields[3] as String,
      mulai: fields[4] as DateTime?,
      selesai: fields[5] as DateTime?,
      alasan: fields[6] as String?,
      status: fields[7] as String?,
    )..id = fields[0] as String?;
  }

  @override
  void write(BinaryWriter writer, Cuti obj) {
    writer
      ..writeByte(8)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.nama)
      ..writeByte(2)
      ..write(obj.idKaryawan)
      ..writeByte(3)
      ..write(obj.jabatan)
      ..writeByte(4)
      ..write(obj.mulai)
      ..writeByte(5)
      ..write(obj.selesai)
      ..writeByte(6)
      ..write(obj.alasan)
      ..writeByte(7)
      ..write(obj.status);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CutiAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
