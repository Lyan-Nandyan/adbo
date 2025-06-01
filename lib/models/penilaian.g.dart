// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'penilaian.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class PenilaianAdapter extends TypeAdapter<Penilaian> {
  @override
  final int typeId = 6;

  @override
  Penilaian read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Penilaian(
      idKaryawan: fields[0] as String,
      score: fields[1] as double,
    );
  }

  @override
  void write(BinaryWriter writer, Penilaian obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.idKaryawan)
      ..writeByte(1)
      ..write(obj.score);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PenilaianAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
