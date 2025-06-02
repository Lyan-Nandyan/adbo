import 'package:adbo/loginKaryawan.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MenuKaryawan extends StatefulWidget {
  const MenuKaryawan({super.key});

  @override
  State<MenuKaryawan> createState() => _MenuKaryawanState();
}

class _MenuKaryawanState extends State<MenuKaryawan> {
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
    await prefs.remove('username');
    await prefs.setBool('isLoggedIn', false);
    await prefs.remove('jabatan');
    await prefs.remove('id');
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
    return AppBar(
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
    );
  }
}
