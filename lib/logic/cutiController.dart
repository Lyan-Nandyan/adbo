import 'dart:math';

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
    await box.add(Cuti(
      nama: nama,
      idKaryawan: idKaryawan,
      jabatan: jabatan,
      mulai: tanggalMulai,
      selesai: tanggalSelesai,
      alasan: alasan,
      status: 'Pending', // Status awal cuti
    ));
    debugPrint(
        'Cuti diajukan - ID: $idKaryawan, Nama: $nama, Jabatan: $jabatan, Mulai: $tanggalMulai, Selesai: $tanggalSelesai, Alasan: $alasan');
    var boxKaryawan = Hive.box<Karyawan>(HiveBox.karyawan);
    Karyawan? karyawan = boxKaryawan.values.firstWhere(
      (k) => k.id == idKaryawan && k.jabatan == jabatan,
    );
    if (karyawan != null) {
      karyawan.cuti =
          '[Menunggu persetujuan], cuti telah diajukan mulai dari ${tanggalMulai.toLocal().toIso8601String()} hingga ${tanggalSelesai.toLocal().toIso8601String()} dengan alasan: $alasan';
      await karyawan.save();
    } else {
      debugPrint(
          'Karyawan dengan ID $idKaryawan dan jabatan $jabatan tidak ditemukan.');
    }
  }

  Future<void> setujuiCuti(String cutiId) async {
    var box = Hive.box<Cuti>(HiveBox.cuti);
    Cuti? cuti = box.get(cutiId);

    if (cuti != null) {
      cuti.status = 'Disetujui';
      await cuti.save();
    }

    var boxKaryawan = Hive.box<Karyawan>(HiveBox.karyawan);
    Karyawan? karyawan = boxKaryawan.values.firstWhere(
      (k) => k.id == cuti?.idKaryawan && k.jabatan == cuti?.jabatan,
      orElse: () => Karyawan(
          nama: cuti?.nama ?? '', password: '', jabatan: cuti?.jabatan ?? ''),
    );
    if (karyawan != null) {
      karyawan.cuti =
          '[Disetujui], cuti telah disetujui mulai dari ${cuti?.mulai?.toLocal().toIso8601String()} hingga ${cuti?.selesai?.toLocal().toIso8601String()} dengan alasan: ${cuti?.alasan}';
      // Simpan perubahan pada karyawan
      await karyawan.save();
    }
  }

  Future<void> tolakCuti(String cutiId) async {
    var box = Hive.box<Cuti>(HiveBox.cuti);
    Cuti? cuti = box.get(cutiId);

    if (cuti != null) {
      cuti.status =
          '[Ditolak], pengajuan cuti Anda dari ${cuti.mulai?.toLocal().toIso8601String()} hingga ${cuti.selesai?.toLocal().toIso8601String()} dengan alasan: ${cuti.alasan} telah ditolak';
      await cuti.save();
    }

    var boxKaryawan = Hive.box<Karyawan>(HiveBox.karyawan);
    Karyawan? karyawan = boxKaryawan.values.firstWhere(
      (k) => k.id == cuti?.idKaryawan && k.jabatan == cuti?.jabatan,
      orElse: () => Karyawan(
          nama: cuti?.nama ?? '', password: '', jabatan: cuti?.jabatan ?? ''),
    );
    if (karyawan != null) {
      karyawan.cuti = 'Tidak ada';
      // Simpan perubahan pada karyawan
      await karyawan.save();
    }
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
