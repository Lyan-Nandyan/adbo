import 'package:adbo/models/absensi.dart';
import 'package:adbo/models/boxes.dart';
import 'package:adbo/models/cuti.dart';
import 'package:adbo/models/gaji.dart';
import 'package:adbo/models/hrd.dart';
import 'package:adbo/models/karyawan.dart';
import 'package:adbo/models/manager.dart';
import 'package:adbo/models/penilaian.dart';
import 'package:flutter/material.dart';
import 'package:adbo/home.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/date_symbol_data_local.dart'; // <-- 1. TAMBAHKAN IMPORT INI

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Inisialisasi format tanggal untuk locale Indonesia
  await initializeDateFormatting('id_ID', null); // <-- 2. TAMBAHKAN BARIS INI

  await Hive.initFlutter();

  // Mendaftarkan semua adapter
  Hive.registerAdapter(KaryawanAdapter());
  Hive.registerAdapter(HrdAdapter());
  Hive.registerAdapter(ManagerAdapter());
  Hive.registerAdapter(AbsensiAdapter());
  Hive.registerAdapter(CutiAdapter());
  Hive.registerAdapter(PenilaianAdapter());
  Hive.registerAdapter(GajiAdapter());

  // Membuka semua box
  await Hive.openBox<Karyawan>(HiveBox.karyawan);
  await Hive.openBox<Hrd>(HiveBox.hrd);
  await Hive.openBox<Manager>(HiveBox.manager);
  await Hive.openBox<Absensi>(HiveBox.absensi);
  await Hive.openBox<Cuti>(HiveBox.cuti);
  await Hive.openBox<Penilaian>(HiveBox.penilaian);
  await Hive.openBox<Gaji>(HiveBox.gaji);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Home(),
    );
  }
}
