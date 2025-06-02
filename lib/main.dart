import 'package:adbo/homeHrd.dart';
import 'package:adbo/loginHrd.dart'; // Ganti ke loginHrd
import 'package:adbo/home.dart';
import 'package:adbo/homeManager.dart';
import 'package:adbo/loginManager.dart';

import 'package:adbo/models/boxes.dart';
import 'package:adbo/models/hrd.dart';
import 'package:adbo/models/karyawan.dart';
import 'package:adbo/models/manager.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';



void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();

  // Daftarkan adapter dan buka box
  Hive.registerAdapter(KaryawanAdapter());
  await Hive.openBox<Karyawan>(HiveBox.karyawan);


  Hive.registerAdapter(HrdAdapter());
  await Hive.openBox<Hrd>(HiveBox.hrd);

  Hive.registerAdapter(ManagerAdapter());
  await Hive.openBox<Manager>(HiveBox.manager);


  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  Future<bool> _isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool('isLoggedIn') ?? false;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
//       title: 'ADBO HRD App',
//       theme: ThemeData(
//         colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
//         useMaterial3: true,
//       ),
//       home: FutureBuilder<bool>(
//         future: _isLoggedIn(),
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return const Scaffold(
//               body: Center(child: CircularProgressIndicator()),
//             );
//           } else if (snapshot.data == true) {
//             return const HomeHrd();
//           } else {
//             return const Loginhrd(); // ganti ke LoginHrd sesuai namamu
//           }
//         },
//       ),
//     );
        title: 'Flutter Demo',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home: LoginManager());
  }
}
