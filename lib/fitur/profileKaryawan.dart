import 'package:adbo/models/boxes.dart';
import 'package:adbo/models/karyawan.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Profilekaryawan extends StatefulWidget {
  const Profilekaryawan({super.key});

  @override
  State<Profilekaryawan> createState() => _ProfilekaryawanState();
}

class _ProfilekaryawanState extends State<Profilekaryawan> {
  Karyawan? _karyawan;

  Future<void> _loadUserProfile() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? username = prefs.getString('username');
    String? jabatan = prefs.getString('jabatan');
    String? id = prefs.getString('id');
    debugPrint(
        'Mencari user dengan ID: $id, Nama: $username, Jabatan: $jabatan');

    if (username == null || jabatan == null || id == null) {
      debugPrint('Data profil dari SharedPreferences tidak lengkap.');
      return;
    }

    var box = Hive.box<Karyawan>(HiveBox.karyawan);
    // Menggunakan firstWhereOrNull agar tidak error jika tidak ditemukan
    Karyawan karyawan = box.values.firstWhere(
      (k) => k.key.toString() == id && k.nama == username && k.jabatan == jabatan,
    );
    debugPrint(
        'karyawan: ${karyawan.id}, ${karyawan.nama}, ${karyawan.jabatan}');
    if (karyawan != null) {
      debugPrint('User ditemukan: ${karyawan.nama} - ${karyawan.jabatan}');
      setState(() {
        _karyawan = karyawan;
      });
    } else {
      debugPrint('User tidak ditemukan di Hive.');
    }
  }

  @override
  void initState() {
    super.initState();
    _loadUserProfile();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile Karyawan'),
      ),
      body: _karyawan == null
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Nama: ${_karyawan!.nama}',
                      style: const TextStyle(fontSize: 20)),
                  const SizedBox(height: 10),
                  Text('Jabatan: ${_karyawan!.jabatan}',
                      style: const TextStyle(fontSize: 20)),
                  const SizedBox(height: 10),
                  Text('ID Karyawan: ${_karyawan!.id}',
                      style: const TextStyle(fontSize: 20)),
                  const SizedBox(height: 10),
                  Text('cuti: ${_karyawan!.cuti}',
                      style: const TextStyle(fontSize: 20)),
                  const SizedBox(height: 10),
                ],
              ),
            ),
    );
  }
}
