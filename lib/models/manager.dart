import 'package:hive/hive.dart';
part 'manager.g.dart';

@HiveType(typeId: 2)
class Manager extends HiveObject {
  @HiveField(0)
  final String nama;

  @HiveField(1)
  final String password;

  @HiveField(2)
  final String jabatan;

  Manager({required this.nama, required this.password, required this.jabatan});
}
