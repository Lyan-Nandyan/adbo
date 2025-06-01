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
      gaji: fields[2] as int,
    );
  }

  @override
  void write(BinaryWriter writer, Gaji obj) {
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
      other is GajiAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
