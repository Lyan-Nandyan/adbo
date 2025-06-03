import 'package:adbo/logic/absenController.dart';
import 'package:adbo/models/absensi.dart';
import 'package:flutter/material.dart';

class Logabsensi extends StatefulWidget {
  const Logabsensi({super.key});

  @override
  State<Logabsensi> createState() => _LogabsensiState();
}

class _LogabsensiState extends State<Logabsensi> {
  final Absencontroller _absenController = Absencontroller();
  List<Absensi> _absensiList = [];

  @override
  void initState() {
    super.initState();
    _loadAbsensi();
  }

  void _loadAbsensi() async {
    List<Absensi> data = await _absenController.getAllAbsensi();
    setState(() {
      _absensiList = data;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Riwayat Absensi')),
      body: ListView.builder(
        itemCount: _absensiList.length,
        itemBuilder: (context, index) {
          final absensi = _absensiList[index];
          return ListTile(
            title: Text('${absensi.nama} (${absensi.jabatan})'),
            subtitle: Text(
              'Masuk: ${absensi.checkIn}\nKeluar: ${absensi.checkOut ?? "Belum Absen Keluar"}',
            ),
          );
        },
      ),
    );
  }
}
