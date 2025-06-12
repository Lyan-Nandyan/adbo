import 'package:adbo/logic/gajiController.dart';
import 'package:adbo/models/gaji.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RiwayatGajiKaryawan extends StatefulWidget {
  const RiwayatGajiKaryawan({super.key});

  @override
  State<RiwayatGajiKaryawan> createState() => _RiwayatGajiKaryawanState();
}

class _RiwayatGajiKaryawanState extends State<RiwayatGajiKaryawan> {
  final GajiController _gajiController = GajiController();
  List<Gaji> _riwayatGaji = [];
  bool _isLoading = true;
  String? _karyawanId;

  @override
  void initState() {
    super.initState();
    _loadRiwayatGaji();
  }

  Future<void> _loadRiwayatGaji() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _karyawanId = prefs.getString('id');
      if (_karyawanId != null) {
        _riwayatGaji = _gajiController.getGajiKaryawan(_karyawanId!);
      }
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final formatCurrency =
        NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Riwayat Gaji Anda'),
        backgroundColor: const Color(0xFF1E3A8A),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _riwayatGaji.isEmpty
              ? const Center(
                  child: Text(
                    'Belum ada data gaji untuk ditampilkan.',
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.all(12.0),
                  itemCount: _riwayatGaji.length,
                  itemBuilder: (context, index) {
                    final gaji = _riwayatGaji[index];
                    return Card(
                      margin: const EdgeInsets.symmetric(vertical: 8),
                      elevation: 2,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: ListTile(
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 15),
                        leading: Icon(
                          Icons.receipt_long_rounded,
                          color: Colors.green.shade600,
                          size: 40,
                        ),
                        title: Text(
                          formatCurrency.format(gaji.jumlah),
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                        subtitle: Text(
                          "Periode: ${DateFormat('MMMM yyyy', 'id_ID').format(gaji.periode)}",
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ),
                    );
                  },
                ),
    );
  }
}
