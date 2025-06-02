import 'package:adbo/models/absensi.dart';
import 'package:adbo/models/boxes.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

class Absencontroller {
  Future<void> absenMasuk(BuildContext context, String idKaryawan, String nama,
      String jabatan) async {
    // Logika untuk absen masuk
    DateTime now = DateTime.now();
    // Simulasi penyimpanan waktu absen masuk
    // Misalnya, simpan ke database atau shared preferences di sini
    print("Absen masuk pada: $now");

    var box = Hive.box<Absensi>(HiveBox.absensi);
    await box.add((Absensi(
      idKaryawan: idKaryawan,
      nama: nama,
      jabatan: jabatan,
      checkIn: now,
      checkOut: null,
    )));

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Absen Masuk Berhasil'),
        backgroundColor: Colors.green,
      ),
    );
  }

  Future<void> absenKeluar(BuildContext context, String idKaryawan,
      String nama, String jabatan) async {
    // Logika untuk absen keluar
    DateTime now = DateTime.now();
    // Simulasi penyimpanan waktu absen keluar
    // Misalnya, simpan ke database atau shared preferences di sini
    print("Absen keluar pada: $now");

    var box = Hive.box<Absensi>(HiveBox.absensi);
    Absensi? absensi = box.values.firstWhere(
      (absen) => absen.idKaryawan == idKaryawan && absen.checkOut == null,
      orElse: () => Absensi(
          idKaryawan: idKaryawan,
          nama: nama,
          jabatan: jabatan,
          checkIn: DateTime.now(),
          checkOut: DateTime.now()),
    );

    if (absensi.checkOut == null) {
      absensi.checkOut = now;
      await absensi.save();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Absen Keluar Berhasil'),
          backgroundColor: Colors.green,
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Anda sudah absen keluar'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<List<Absensi>> getAllAbsensi() async {
    var box = Hive.box<Absensi>(HiveBox.absensi);
    return box.values.toList();
  }
}
