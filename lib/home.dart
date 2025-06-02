import 'package:adbo/login/loginHrd.dart';
import 'package:adbo/login/loginKaryawan.dart';
import 'package:adbo/login/loginManager.dart';
import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'Selamat Datang di Aplikasi',
              style: TextStyle(fontSize: 24),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Aksi untuk masuk ke menu karyawan
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const LoginKaryawan(),
                    ));
              },
              child: const Text('Menu Karyawan'),
            ),
            ElevatedButton(
              onPressed: () {
                // Aksi untuk masuk ke menu karyawan
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const Loginhrd(),
                    ));
              },
              child: const Text('Menu HRD'),
            ),
            ElevatedButton(
              onPressed: () {
                // Aksi untuk masuk ke menu manager
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const LoginManager(),
                    ));
              },
              child: const Text('Menu Manager'),
            ),
          ],
        ),
      ),
    );
  }
}
