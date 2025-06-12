import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';
import 'package:adbo/models/boxes.dart';
import 'package:adbo/models/gaji.dart';
import 'package:adbo/models/karyawan.dart';
import 'package:adbo/logic/gajiController.dart';

class ManajemenGajiHrd extends StatefulWidget {
  const ManajemenGajiHrd({super.key});

  @override
  State<ManajemenGajiHrd> createState() => _ManajemenGajiHrdState();
}

class _ManajemenGajiHrdState extends State<ManajemenGajiHrd> {
  final GajiController _gajiController = GajiController();
  final Box<Karyawan> _karyawanBox = Hive.box<Karyawan>(HiveBox.karyawan);

  String _getKaryawanName(String idKaryawan) {
    try {
      final karyawan =
          _karyawanBox.values.firstWhere((k) => k.id == idKaryawan);
      return karyawan.nama;
    } catch (e) {
      return 'Nama Tidak Ditemukan';
    }
  }

  void _showGajiDialog({Gaji? gaji}) {
    final _formKey = GlobalKey<FormState>();
    String? selectedKaryawanId = gaji?.idKaryawan;
    final _jumlahController =
        TextEditingController(text: gaji?.jumlah.toString() ?? '');
    DateTime selectedDate = gaji?.periode ?? DateTime.now();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(gaji == null ? 'Tambah Gaji' : 'Ubah Gaji'),
          content: StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              return Form(
                key: _formKey,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (gaji == null)
                        DropdownButtonFormField<String>(
                          value: selectedKaryawanId,
                          hint: const Text('Pilih Karyawan'),
                          items: _karyawanBox.values.map((Karyawan karyawan) {
                            return DropdownMenuItem<String>(
                              value: karyawan.id,
                              child: Text(karyawan.nama),
                            );
                          }).toList(),
                          onChanged: (value) {
                            setState(() {
                              selectedKaryawanId = value;
                            });
                          },
                          validator: (value) =>
                              value == null ? 'Pilih karyawan dulu' : null,
                        ),
                      TextFormField(
                        controller: _jumlahController,
                        decoration:
                            const InputDecoration(labelText: 'Jumlah Gaji'),
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Jumlah tidak boleh kosong';
                          }
                          if (int.tryParse(value) == null) {
                            return 'Masukkan angka yang valid';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 20),
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                                "Periode: ${DateFormat('MMMM yyyy').format(selectedDate)}"),
                          ),
                          TextButton(
                            child: const Text('Pilih Tanggal'),
                            onPressed: () async {
                              final DateTime? picked = await showDatePicker(
                                context: context,
                                initialDate: selectedDate,
                                firstDate: DateTime(2020),
                                lastDate: DateTime(2101),
                              );
                              if (picked != null && picked != selectedDate) {
                                setState(() {
                                  selectedDate = picked;
                                });
                              }
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Batal'),
            ),
            ElevatedButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  if (gaji == null) {
                    _gajiController.addGaji(
                      idKaryawan: selectedKaryawanId!,
                      jumlah: int.parse(_jumlahController.text),
                      periode: selectedDate,
                    );
                  } else {
                    _gajiController.updateGaji(
                      gaji: gaji,
                      jumlah: int.parse(_jumlahController.text),
                    );
                  }
                  Navigator.pop(context);
                }
              },
              child: const Text('Simpan'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Manajemen Gaji Karyawan'),
        backgroundColor: const Color(0xFF1E3A8A),
      ),
      body: ValueListenableBuilder<Box<Gaji>>(
        valueListenable: Hive.box<Gaji>(HiveBox.gaji).listenable(),
        builder: (context, box, _) {
          final listGaji = box.values.toList().cast<Gaji>();
          listGaji.sort((a, b) => b.periode.compareTo(a.periode));

          if (listGaji.isEmpty) {
            return const Center(child: Text("Belum ada data gaji."));
          }

          return ListView.builder(
            itemCount: listGaji.length,
            itemBuilder: (context, index) {
              final gaji = listGaji[index];
              final namaKaryawan = _getKaryawanName(gaji.idKaryawan);
              final formatCurrency = NumberFormat.currency(
                  locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0);

              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
                elevation: 3,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: ListTile(
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  title: Text(
                    namaKaryawan,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(formatCurrency.format(gaji.jumlah)),
                      Text(
                          "Periode: ${DateFormat('MMMM yyyy').format(gaji.periode)}"),
                    ],
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit, color: Colors.blue),
                        onPressed: () => _showGajiDialog(gaji: gaji),
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () {
                          _gajiController.deleteGaji(gaji);
                        },
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showGajiDialog(),
        backgroundColor: const Color(0xFF10B981),
        child: const Icon(Icons.add),
      ),
    );
  }
}
