import 'package:hive/hive.dart';
part 'manager.g.dart';

@HiveType(typeId: 2)
class Karyawan extends HiveObject {
  @HiveField(0)
  final String nama;

  @HiveField(1)
  final String password;

  @HiveField(2)
  final String jabatan;

  Karyawan({required this.nama, required this.password, required this.jabatan});
}
