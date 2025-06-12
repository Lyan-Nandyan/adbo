import 'package:adbo/models/boxes.dart';
import 'package:adbo/models/cuti.dart';
import 'package:adbo/models/karyawan.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

class CutiController {
  Future<void> ajukanCuti(
    String nama,
    String idKaryawan,
    String jabatan,
    DateTime tanggalMulai,
    DateTime tanggalSelesai,
    String alasan,
  ) async {
    var box = Hive.box<Cuti>(HiveBox.cuti);
    int key = await box.add(Cuti(
      nama: nama,
      idKaryawan: idKaryawan,
      jabatan: jabatan,
      mulai: tanggalMulai,
      selesai: tanggalSelesai,
      alasan: alasan,
      status: 'Pending', // Status awal cuti
    ));
    Cuti? cuti = box.get(key);
    if (cuti != null) {
      cuti.id = key.toString(); // Simpan key sebagai id
      await cuti.save(); // Simpan perubahan
    }
    debugPrint(
        'Cuti diajukan - ID: $idKaryawan, Nama: $nama, Jabatan: $jabatan, Mulai: $tanggalMulai, Selesai: $tanggalSelesai, Alasan: $alasan');
    var boxKaryawan = Hive.box<Karyawan>(HiveBox.karyawan);
    Karyawan? karyawan = boxKaryawan.values.firstWhere(
      (k) => k.id == idKaryawan && k.jabatan == jabatan,
    );
    karyawan.cuti = '[Menunggu persetujuan]';
    await karyawan.save();
  }

  Future<void> setujuiCuti(String cutiId) async {
    debugPrint('Menyetujui cuti dengan ID: $cutiId');

    var box = Hive.box<Cuti>(HiveBox.cuti);
    Cuti? cuti = box.values.firstWhere(
      (c) => c.id == cutiId,
    );
    cuti.status = 'Disetujui';
    await cuti.save();

    var boxKaryawan = Hive.box<Karyawan>(HiveBox.karyawan);
    Karyawan? karyawan = boxKaryawan.values.firstWhere(
      (k) => k.id == cuti.idKaryawan && k.jabatan == cuti.jabatan,
      orElse: () =>
          Karyawan(nama: cuti.nama, password: '', jabatan: cuti.jabatan),
    );
    karyawan.cuti = 'Tidak ada(sedang cuti)';
    // Simpan perubahan pada karyawan
    await karyawan.save();
  }

  Future<void> tolakCuti(String cutiId) async {
    var box = Hive.box<Cuti>(HiveBox.cuti);
    Cuti? cuti = box.values.firstWhere(
      (c) => c.id == cutiId,
    );

    cuti.status = 'Ditolak';
    await cuti.save();

    var boxKaryawan = Hive.box<Karyawan>(HiveBox.karyawan);
    Karyawan? karyawan = boxKaryawan.values.firstWhere(
      (k) => k.id == cuti.idKaryawan && k.jabatan == cuti.jabatan,
      orElse: () =>
          Karyawan(nama: cuti.nama, password: '', jabatan: cuti.jabatan),
    );
    karyawan.cuti = 'Tidak ada';
    // Simpan perubahan pada karyawan
    await karyawan.save();
  }

  Future<List<Cuti>> getCutiByKaryawan(String idKaryawan) async {
    var box = Hive.box<Cuti>(HiveBox.cuti);
    return box.values.where((cuti) => cuti.idKaryawan == idKaryawan).toList();
  }

  Future<List<Cuti>> getAllCuti() async {
    var box = Hive.box<Cuti>(HiveBox.cuti);
    return box.values.toList();
  }

  Future<bool> isAlreadyCuti(String idKaryawan, String jabatan) async {
    var box = Hive.box<Cuti>(HiveBox.cuti);
    return box.values.any((cuti) =>
        cuti.idKaryawan == idKaryawan &&
        cuti.jabatan == jabatan &&
        cuti.status == 'Pending');
  }
}
