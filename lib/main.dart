import 'package:adbo/loginKaryawan.dart';
import 'package:adbo/models/boxes.dart';
import 'package:adbo/models/karyawan.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  await Hive.initFlutter();
  await SharedPreferences.getInstance();
  // karyawan box
  Hive.registerAdapter(KaryawanAdapter());
  await Hive.openBox<Karyawan>(HiveBox.karyawan);

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
        home: LoginKaryawan());
  }
}
