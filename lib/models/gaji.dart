import 'package:hive/hive.dart';
part 'gaji.g.dart';

@HiveType(typeId: 4)
class Gaji extends HiveObject {
  @HiveField(0)
  final String idKaryawan;

  @HiveField(2)
  int gaji;

  Gaji({required this.idKaryawan, required this.gaji});
}
