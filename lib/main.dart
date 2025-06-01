import 'package:adbo/home.dart';
import 'package:adbo/homeManager.dart';
import 'package:adbo/loginManager.dart';
import 'package:adbo/models/boxes.dart';
import 'package:adbo/models/karyawan.dart';
import 'package:adbo/models/manager.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';



void main() async {
  await Hive.initFlutter();

  // karyawan box
  Hive.registerAdapter(KaryawanAdapter());
  await Hive.openBox<Karyawan>(HiveBox.karyawan);

  Hive.registerAdapter(ManagerAdapter());
  await Hive.openBox<Manager>(HiveBox.manager);

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
        home: LoginManager());
  }
}
