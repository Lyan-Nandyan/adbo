// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'gaji.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class GajiAdapter extends TypeAdapter<Gaji> {
  @override
  final int typeId = 4;

  @override
  Gaji read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Gaji(
      idKaryawan: fields[0] as String,
      jumlah: fields[1] as int,
      periode: fields[2] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, Gaji obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.idKaryawan)
      ..writeByte(1)
      ..write(obj.jumlah)
      ..writeByte(2)
      ..write(obj.periode);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is GajiAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
