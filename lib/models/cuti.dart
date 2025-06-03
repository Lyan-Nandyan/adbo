import 'package:hive/hive.dart';
part 'cuti.g.dart';

@HiveType(typeId: 5)
class Cuti extends HiveObject {
  @HiveField(0)
  String? id;

  @HiveField(1)
  final String nama;

  @HiveField(2)
  final String idKaryawan;

  @HiveField(3)
  final String jabatan;

  @HiveField(4)
  final DateTime? mulai;

  @HiveField(5)
  final DateTime? selesai;

  @HiveField(6)
  final String? alasan;

  @HiveField(7)
  String? status;

  Cuti(
      {required this.nama,
      required this.idKaryawan,
      required this.jabatan,
      required this.mulai,
      required this.selesai,
      required this.alasan,
      this.status});
}
