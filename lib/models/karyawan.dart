import 'package:hive/hive.dart';
part 'karyawan.g.dart';

@HiveType(typeId: 0)
class Karyawan extends HiveObject {
  @HiveField(0)
  final String nama;

  @HiveField(1)
  final String password;

  @HiveField(2)
  final String jabatan;
  
  @HiveField(3)
  final String? cuti;

  Karyawan({required this.nama, required this.password, required this.jabatan, this.cuti});
}
