import 'package:adbo/fitur/tampilanAbsensi.dart';
import 'package:adbo/login/loginKaryawan.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Homekaryawan extends StatefulWidget {
  const Homekaryawan({super.key});

  @override
  State<Homekaryawan> createState() => _HomeKaryawanState();
}

class _HomeKaryawanState extends State<Homekaryawan> {
  String? username;
  String? jabatan;
  String? id;

  Future<void> _loadUserKaryawan() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      username = prefs.getString('username') ?? 'User';
      jabatan = prefs.getString('jabatan') ?? 'karyawan';
      id = prefs.getString('id') ?? '0';
    });
  }

  Future<void> _logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => LoginKaryawan()),
    );
  }

  @override
  void initState() {
    super.initState();
    _loadUserKaryawan();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Menu Karyawan'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: _logout,
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(50.0),
          child: Container(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              'Selamat Datang, $username ($jabatan)',
              style: const TextStyle(fontSize: 16.0),
            ),
          ),
        ),
      ),
      body: ElevatedButton.icon(
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const Tampilanabsensi(),
              ));
        },
        icon: const Icon(Icons.access_time),
        label: const Text('Absensi Karyawan'),
        style: ElevatedButton.styleFrom(
          minimumSize: const Size(double.infinity, 50),
        ),
      ),
    );
  }
}
