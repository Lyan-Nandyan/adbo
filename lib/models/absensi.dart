import 'package:hive/hive.dart';
part 'absensi.g.dart';

@HiveType(typeId: 3)
class Absensi extends HiveObject {
  @HiveField(0)
  final String nama;

  @HiveField(1)
  final String idKaryawan;

  @HiveField(2)
  final DateTime? checkIn;

  @HiveField(3)
  final DateTime? checkOut;


  Absensi({
    required this.nama,
    required this.idKaryawan,
    this.checkIn,
    this.checkOut,
  });
}
