import 'package:hive/hive.dart';
part 'hrd.g.dart';

@HiveType(typeId: 1)
class Hrd extends HiveObject {
  @HiveField(0)
  String? id;

  @HiveField(1)
  final String nama;

  @HiveField(2)
  final String password;

  @HiveField(3)
  final String jabatan;

  @HiveField(4)
  final String email;

  Hrd(
      {required this.nama,
      required this.password,
      required this.jabatan,
      required this.email});
}
