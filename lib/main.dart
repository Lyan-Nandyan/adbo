import 'package:adbo/home.dart';
import 'package:adbo/models/absensi.dart';
import 'package:adbo/models/boxes.dart';
import 'package:adbo/models/cuti.dart';
import 'package:adbo/models/hrd.dart';
import 'package:adbo/models/karyawan.dart';
import 'package:adbo/models/manager.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:hive_flutter/hive_flutter.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  await SharedPreferences.getInstance();
  // karyawan box
  Hive.registerAdapter(KaryawanAdapter());
  await Hive.openBox<Karyawan>(HiveBox.karyawan);
  // hrd box
  Hive.registerAdapter(HrdAdapter());
  await Hive.openBox<Hrd>(HiveBox.hrd);
  // manager box
  Hive.registerAdapter(ManagerAdapter());
  await Hive.openBox<Manager>(HiveBox.manager);
  // absensi box
  Hive.registerAdapter(AbsensiAdapter());
  await Hive.openBox<Absensi>(HiveBox.absensi);
  // cuti box
  Hive.registerAdapter(CutiAdapter());
  await Hive.openBox<Cuti>(HiveBox.cuti);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home: Home());
  }
}
