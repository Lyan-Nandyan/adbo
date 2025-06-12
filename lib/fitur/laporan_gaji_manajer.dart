import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';
import 'package:adbo/models/boxes.dart';
import 'package:adbo/models/gaji.dart';
import 'package:adbo/models/karyawan.dart';

class LaporanGajiManager extends StatefulWidget {
  const LaporanGajiManager({super.key});

  @override
  State<LaporanGajiManager> createState() => _LaporanGajiManagerState();
}

class _LaporanGajiManagerState extends State<LaporanGajiManager> {
  final Box<Gaji> _gajiBox = Hive.box<Gaji>(HiveBox.gaji);
  final Box<Karyawan> _karyawanBox = Hive.box<Karyawan>(HiveBox.karyawan);
  DateTime _selectedDate = DateTime.now();

  String _getKaryawanName(String idKaryawan) {
    try {
      final karyawan =
          _karyawanBox.values.firstWhere((k) => k.id == idKaryawan);
      return karyawan.nama;
    } catch (e) {
      return 'Nama Tidak Ditemukan';
    }
  }

  void _pilihPeriode() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2101),
      initialDatePickerMode: DatePickerMode.year,
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final formatCurrency =
        NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Laporan Gaji Karyawan'),
        backgroundColor: const Color(0xFF1E3A8A),
        actions: [
          IconButton(
            icon: const Icon(Icons.calendar_today),
            onPressed: _pilihPeriode,
            tooltip: 'Pilih Periode',
          ),
        ],
      ),
      body: ValueListenableBuilder<Box<Gaji>>(
        valueListenable: _gajiBox.listenable(),
        builder: (context, box, _) {
          final listGaji = box.values
              .where((gaji) =>
                  gaji.periode.month == _selectedDate.month &&
                  gaji.periode.year == _selectedDate.year)
              .toList();

          final totalGaji = listGaji.fold<int>(
              0, (previousValue, element) => previousValue + element.jumlah);

          if (listGaji.isEmpty) {
            return Center(
              child: Text(
                  "Tidak ada data gaji untuk periode ${DateFormat('MMMM yyyy', 'id_ID').format(_selectedDate)}."),
            );
          }

          return Column(
            children: [
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16.0),
                margin: const EdgeInsets.all(12.0),
                decoration: BoxDecoration(
                  color: Colors.blue[800],
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.blue.withOpacity(0.3),
                      spreadRadius: 2,
                      blurRadius: 5,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Text(
                      'Total Gaji Periode ${DateFormat('MMMM yyyy', 'id_ID').format(_selectedDate)}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      formatCurrency.format(totalGaji),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 12.0),
                  itemCount: listGaji.length,
                  itemBuilder: (context, index) {
                    final gaji = listGaji[index];
                    final namaKaryawan = _getKaryawanName(gaji.idKaryawan);

                    return Card(
                      margin: const EdgeInsets.symmetric(vertical: 6),
                      child: ListTile(
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 8),
                        leading: CircleAvatar(
                          child: Text(
                              namaKaryawan.isNotEmpty ? namaKaryawan[0] : '-'),
                        ),
                        title: Text(namaKaryawan),
                        trailing: Text(
                          formatCurrency.format(gaji.jumlah),
                          style: const TextStyle(fontWeight: FontWeight.w600),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
