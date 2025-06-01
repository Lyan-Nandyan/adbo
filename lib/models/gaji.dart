import 'package:hive/hive.dart';
part 'gaji.g.dart';

@HiveType(typeId: 4)
class Karyawan extends HiveObject {
  @HiveField(0)
  final String idKaryawan;

  @HiveField(2)
  final int gaji;

  Karyawan({required this.idKaryawan, required this.gaji});
}
