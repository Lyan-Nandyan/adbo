import 'package:adbo/fitur/formPenilaian.dart';
import 'package:adbo/models/boxes.dart';
import 'package:adbo/models/karyawan.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';

class Listkaryawan extends StatefulWidget {
  const Listkaryawan({super.key});

  @override
  State<Listkaryawan> createState() => _ListkaryawanState();
}

class _ListkaryawanState extends State<Listkaryawan> {
  List<Karyawan> _karyawanList = [];

  Future<List<Karyawan>> _fetchKaryawan() async {
    var box = Hive.box<Karyawan>(HiveBox.karyawan);
    return box.values.toList();
  }

  Future<void> _loadKaryawan() async {
    List<Karyawan> karyawanList = await _fetchKaryawan();
    setState(() {
      _karyawanList = karyawanList;
    });
  }

  @override
  void initState() {
    super.initState();
    _loadKaryawan();
  } 

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
      title: const Text('Daftar Karyawan'),
    ),body: ListView.builder(
      itemCount: _karyawanList.length,
      itemBuilder: (context, index) {
        final karyawan = _karyawanList[index];
        return ListTile(
          title: Text(karyawan.nama),
          subtitle: Text(karyawan.jabatan),
          trailing: Text(karyawan.id!),
          onTap: () {
            Navigator.push(context, 
              MaterialPageRoute(
                builder:(context) => Formpenilaian(idkaryawan: karyawan.id!, nama: karyawan.nama,),
              ),
            );
          },
        );
      },
    ));
  }
}
