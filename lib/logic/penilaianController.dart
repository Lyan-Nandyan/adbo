import 'package:adbo/models/boxes.dart';
import 'package:adbo/models/penilaian.dart';
import 'package:hive/hive.dart';

class Penilaiancontroller {
  Future<void> addPenilaian(
      String idKaryawan, double penilaian) async {
    var box = Hive.box<Penilaian>(HiveBox.penilaian);
    await box.add(Penilaian(
      idKaryawan: idKaryawan,
      score: penilaian,
      tanggal: DateTime.now(),
    ));
  }

  Future<List<Penilaian>> getPenilaianByKaryawan(String idKaryawan) async {
    var box = Hive.box<Penilaian>(HiveBox.penilaian);
    return box.values
        .where((penilaian) => penilaian.idKaryawan == idKaryawan)
        .toList();
  }

  Future<List<Penilaian>> getAllPenilaian() async {
    var box = Hive.box<Penilaian>(HiveBox.penilaian);
    return box.values.toList();
  }
}
