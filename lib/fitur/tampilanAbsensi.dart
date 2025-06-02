import 'package:adbo/logic/absenController.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Tampilanabsensi extends StatefulWidget {
  const Tampilanabsensi({super.key});

  @override
  State<Tampilanabsensi> createState() => _TampilanabsensiState();
}

class _TampilanabsensiState extends State<Tampilanabsensi> {
  final Absencontroller _absenController = Absencontroller();
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

  @override
  void initState() {
    super.initState();
    _loadUserKaryawan();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tampilan Absensi'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'Tampilan Absensi Karyawan',
              style: TextStyle(fontSize: 24),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                _absenController.absenMasuk(context, id ?? '0',
                    username ?? 'User', jabatan ?? 'karyawan');
              },
              child: const Text('Check In'),
            ),
            ElevatedButton(
                onPressed: () {
                  _absenController.absenKeluar(context, id ?? '0',
                      username ?? 'User', jabatan ?? 'karyawan');
                },
                child: Text('Check Out')),
          ],
        ),
      ),
    );
  }
}
