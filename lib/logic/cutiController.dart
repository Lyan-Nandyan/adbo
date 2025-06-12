import 'package:adbo/models/boxes.dart';
import 'package:adbo/models/cuti.dart';
import 'package:adbo/models/karyawan.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

/// Controller untuk mengelola semua logika bisnis terkait pengajuan cuti.
/// Ini termasuk mengajukan, menyetujui, menolak, dan mengambil data cuti dari Hive.
class CutiController {
  /// Fungsi untuk membuat pengajuan cuti baru oleh karyawan.
  Future<void> ajukanCuti(
    String nama,
    String idKaryawan,
    String jabatan,
    DateTime tanggalMulai,
    DateTime tanggalSelesai,
    String alasan,
  ) async {
    final box = Hive.box<Cuti>(HiveBox.cuti);

    // Membuat objek Cuti baru
    final cutiBaru = Cuti(
      nama: nama,
      idKaryawan: idKaryawan,
      jabatan: jabatan,
      mulai: tanggalMulai,
      selesai: tanggalSelesai,
      alasan: alasan,
      status: 'Pending', // Status awal setiap pengajuan adalah 'Pending'
    );

    // Menambahkan ke box dan mendapatkan key-nya
    final int key = await box.add(cutiBaru);

    // Menggunakan key sebagai ID unik untuk referensi di masa depan
    cutiBaru.id = key.toString();
    await cutiBaru.save(); // Menyimpan perubahan (ID baru)

    debugPrint('Pengajuan Cuti berhasil dibuat dengan ID: ${cutiBaru.id}');

    // Update status cuti di data karyawan
    final boxKaryawan = Hive.box<Karyawan>(HiveBox.karyawan);
    try {
      final karyawan = boxKaryawan.values.firstWhere(
        (k) => k.id == idKaryawan && k.jabatan == jabatan,
      );
      karyawan.cuti = '[Menunggu persetujuan]';
      await karyawan.save();
    } catch (e) {
      debugPrint('Error: Karyawan dengan ID $idKaryawan tidak ditemukan.');
    }
  }

  /// Fungsi untuk menyetujui pengajuan cuti (biasanya oleh atasan/admin).
  Future<void> setujuiCuti(String cutiId) async {
    final box = Hive.box<Cuti>(HiveBox.cuti);
    // Mengambil data Cuti berdasarkan key-nya, lebih efisien
    final cuti = box.get(int.tryParse(cutiId));

    if (cuti != null) {
      cuti.status = 'Disetujui';
      await cuti.save();

      // Update status cuti di data karyawan
      final boxKaryawan = Hive.box<Karyawan>(HiveBox.karyawan);
      try {
        final karyawan = boxKaryawan.values.firstWhere(
          (k) => k.id == cuti.idKaryawan && k.jabatan == cuti.jabatan,
        );
        karyawan.cuti = 'Sedang Cuti';
        await karyawan.save();
      } catch (e) {
        debugPrint('Error saat update karyawan untuk cuti disetujui: $e');
      }
    } else {
      debugPrint(
          'Error: Cuti dengan ID $cutiId tidak ditemukan untuk disetujui.');
    }
  }

  /// Fungsi untuk menolak pengajuan cuti.
  Future<void> tolakCuti(String cutiId) async {
    final box = Hive.box<Cuti>(HiveBox.cuti);
    // Mengambil data Cuti berdasarkan key-nya
    final cuti = box.get(int.tryParse(cutiId));

    if (cuti != null) {
      cuti.status = 'Ditolak';
      await cuti.save();

      // Kembalikan status cuti karyawan ke 'Tidak ada'
      final boxKaryawan = Hive.box<Karyawan>(HiveBox.karyawan);
      try {
        final karyawan = boxKaryawan.values.firstWhere(
          (k) => k.id == cuti.idKaryawan && k.jabatan == cuti.jabatan,
        );
        karyawan.cuti = 'Tidak ada';
        await karyawan.save();
      } catch (e) {
        debugPrint('Error saat update karyawan untuk cuti ditolak: $e');
      }
    } else {
      debugPrint(
          'Error: Cuti dengan ID $cutiId tidak ditemukan untuk ditolak.');
    }
  }

  /// Mengambil semua riwayat cuti untuk seorang karyawan.
  Future<List<Cuti>> getCutiByKaryawan(String idKaryawan) async {
    final box = Hive.box<Cuti>(HiveBox.cuti);
    return box.values.where((cuti) => cuti.idKaryawan == idKaryawan).toList();
  }

  /// Mengambil semua data cuti dari semua karyawan (untuk admin).
  Future<List<Cuti>> getAllCuti() async {
    final box = Hive.box<Cuti>(HiveBox.cuti);
    return box.values.toList();
  }

  /// Mencari pengajuan cuti terakhir yang statusnya 'Pending' atau 'Disetujui'.
  /// Ini digunakan untuk memeriksa apakah karyawan sudah mengajukan cuti dan belum selesai.
  /// Jika status 'Ditolak' atau tidak ada, fungsi ini akan mengembalikan null,
  /// sehingga karyawan bisa mengajukan cuti baru.
  Future<Cuti?> getActiveOrPendingCuti(
      String idKaryawan, String jabatan) async {
    final box = Hive.box<Cuti>(HiveBox.cuti);
    try {
      // Menggunakan `lastWhere` untuk mendapatkan pengajuan terbaru yang memenuhi syarat
      final cuti = box.values.lastWhere((c) =>
          c.idKaryawan == idKaryawan &&
          c.jabatan == jabatan &&
          (c.status == 'Pending' || c.status == 'Disetujui'));
      return cuti;
    } catch (e) {
      // Jika `lastWhere` tidak menemukan elemen (melempar error),
      // artinya tidak ada cuti aktif. Kembalikan null.
      return null;
    }
  }
}
