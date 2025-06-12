import 'package:hive/hive.dart';

// Penting: Jalankan build_runner setiap kali Anda mengubah file ini
// Perintah: flutter packages pub run build_runner build
part 'gaji.g.dart';

@HiveType(typeId: 4)
class Gaji extends HiveObject {
  @HiveField(0)
  final String idKaryawan;

  @HiveField(1)
  int jumlah;

  @HiveField(2)
  final DateTime periode;

  Gaji({
    required this.idKaryawan,
    required this.jumlah,
    required this.periode,
  });
}
