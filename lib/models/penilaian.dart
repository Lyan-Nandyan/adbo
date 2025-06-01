import 'package:hive/hive.dart';
part 'penilaian.g.dart';

@HiveType(typeId: 6)
class Karyawan extends HiveObject {
  @HiveField(0)
  final String idKaryawan;

  @HiveField(1)
  final double score;

  Karyawan({required this.idKaryawan, required this.score});
}
