import 'package:hive/hive.dart';
part 'penilaian.g.dart';

@HiveType(typeId: 6)
class Penilaian extends HiveObject {
  @HiveField(0)
  final String idKaryawan;

  @HiveField(1)
  final double score;

  Penilaian({required this.idKaryawan, required this.score});
}
