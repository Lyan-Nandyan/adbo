import 'package:adbo/models/boxes.dart';
import 'package:adbo/models/gaji.dart';
import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';

class GajiController {
  // Mengambil box 'gaji' dari Hive menggunakan nama dari HiveBox
  final _box = Hive.box<Gaji>(HiveBox.gaji);

  // Menambahkan data gaji baru
  void addGaji({
    required String idKaryawan,
    required int jumlah,
    required DateTime periode,
  }) {
    // Mencegah duplikasi data gaji untuk karyawan di periode yang sama
    final isExist = _box.values.any((gaji) =>
        gaji.idKaryawan == idKaryawan &&
        gaji.periode.month == periode.month &&
        gaji.periode.year == periode.year);

    if (isExist) {
      debugPrint(
          "Error: Gaji untuk karyawan ini pada periode tersebut sudah ada.");
      return;
    }

    final gajiBaru = Gaji(
      idKaryawan: idKaryawan,
      jumlah: jumlah,
      periode: periode,
    );
    _box.add(gajiBaru);
  }

  // Mengubah data gaji yang sudah ada
  void updateGaji({
    required Gaji gaji,
    required int jumlah,
  }) {
    gaji.jumlah = jumlah;
    gaji.save();
  }

  // Mengambil semua data gaji milik satu karyawan
  List<Gaji> getGajiKaryawan(String idKaryawan) {
    final data =
        _box.values.where((gaji) => gaji.idKaryawan == idKaryawan).toList();
    // Mengurutkan dari yang terbaru
    data.sort((a, b) => b.periode.compareTo(a.periode));
    return data;
  }

  // Mengambil seluruh data gaji dari semua karyawan
  ValueListenable<List<Gaji>> getAllGaji() {
    final List<Gaji> gajiList = _box.values.toList();
    // Mengurutkan berdasarkan periode terbaru
    gajiList.sort((a, b) => b.periode.compareTo(a.periode));
    return ValueNotifier(gajiList);
  }

  // Menghapus data gaji
  void deleteGaji(Gaji gaji) {
    gaji.delete();
  }
}
