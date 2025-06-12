import 'package:adbo/logic/cutiController.dart';
import 'package:adbo/menu/homeKaryawan.dart';
import 'package:adbo/models/boxes.dart';
import 'package:adbo/models/cuti.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Pengajuancuti extends StatefulWidget {
  const Pengajuancuti({super.key});

  @override
  State<Pengajuancuti> createState() => _PengajuancutiState();
}

class _PengajuancutiState extends State<Pengajuancuti> {
  final CutiController _pengajuanCutiController = CutiController();
  final TextEditingController _alasanCutiController = TextEditingController();
  final TextEditingController _tanggalMulaiController = TextEditingController();
  final TextEditingController _tanggalSelesaiController =
      TextEditingController();
  DateTime? tanggalMulai;
  DateTime? tanggalSelesai;
  final formkey = GlobalKey<FormState>();
  String? username;
  String? jabatan;
  String? id;
  String? cuti;
  String? mulai;
  String? selesai;
  String? alasan;

  Future<void> _loadUserKaryawan() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      username = prefs.getString('username') ?? 'User';
      jabatan = prefs.getString('jabatan') ?? 'karyawan';
      id = prefs.getString('id') ?? '0';
    });
    var box = Hive.box<Cuti>(HiveBox.cuti);
    Cuti? cutiData = box.values.firstWhere(
      (c) =>
          c.idKaryawan == id && c.jabatan == jabatan && c.status == 'Pending',
    );
    setState(() {
      cuti = cutiData.status;
      mulai = cutiData.mulai.toString();
      selesai = cutiData.selesai.toString();
      alasan = cutiData.alasan;
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
        title: const Text(
          'Pengajuan Cuti',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.blue.shade700,
        elevation: 5,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(15),
          ),
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.blue.shade50,
              Colors.blue.shade100,
            ],
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Card(
              elevation: 8,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              child: Padding(
                padding: const EdgeInsets.all(25),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    const Text(
                      'Pengajuan Cuti Karyawan',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue,
                      ),
                    ),
                    const SizedBox(height: 30),
                    FutureBuilder<bool>(
                      future: _pengajuanCutiController.isAlreadyCuti(
                          id ?? 'null', jabatan ?? 'null'),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                              child: CircularProgressIndicator());
                        }

                        if (snapshot.hasError) {
                          return const Text(
                            'Terjadi kesalahan. Silakan coba lagi.',
                            style: TextStyle(color: Colors.red),
                          );
                        }

                        if (snapshot.data == true) {
                          return Container(
                            padding: const EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              color: Colors.blue.shade50,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: Colors.blue.shade200,
                                width: 1.5,
                              ),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Status Pengajuan Cuti Anda',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.blue,
                                  ),
                                ),
                                const SizedBox(height: 15),
                                _buildStatusItem(
                                    Icons.info, 'Status Cuti:', cuti ?? '-'),
                                _buildStatusItem(Icons.calendar_today,
                                    'Tanggal Mulai:', mulai ?? '-'),
                                _buildStatusItem(Icons.calendar_today,
                                    'Tanggal Selesai:', selesai ?? '-'),
                                _buildStatusItem(
                                    Icons.note, 'Alasan:', alasan ?? '-'),
                              ],
                            ),
                          );
                        }

                        return Column(
                          children: [
                            const Text(
                              'Formulir Pengajuan Cuti',
                              style: TextStyle(
                                fontSize: 18,
                                color: Colors.blueGrey,
                              ),
                            ),
                            const SizedBox(height: 25),
                            Form(
                              key: formkey,
                              child: Column(
                                children: [
                                  TextFormField(
                                    controller: _alasanCutiController,
                                    decoration: InputDecoration(
                                      labelText: 'Alasan Cuti',
                                      labelStyle:
                                          const TextStyle(color: Colors.blue),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(10),
                                        borderSide: const BorderSide(
                                            color: Colors.blue),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(10),
                                        borderSide: const BorderSide(
                                            color: Colors.blue, width: 2),
                                      ),
                                      filled: true,
                                      fillColor: Colors.white,
                                    ),
                                    validator: (value) =>
                                        value == null || value.isEmpty
                                            ? 'Wajib diisi'
                                            : null,
                                    maxLines: 3,
                                  ),
                                  const SizedBox(height: 20),
                                  TextFormField(
                                    controller: _tanggalMulaiController,
                                    readOnly: true,
                                    decoration: InputDecoration(
                                      labelText: 'Tanggal Mulai Cuti',
                                      labelStyle:
                                          const TextStyle(color: Colors.blue),
                                      suffixIcon: const Icon(
                                        Icons.calendar_today,
                                        color: Colors.blue,
                                      ),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(10),
                                        borderSide: const BorderSide(
                                            color: Colors.blue, width: 2),
                                      ),
                                      filled: true,
                                      fillColor: Colors.white,
                                    ),
                                    onTap: () async {
                                      FocusScope.of(context).unfocus();

                                      DateTime? pickedDate =
                                          await showDatePicker(
                                        context: context,
                                        initialDate:
                                            tanggalMulai ?? DateTime.now(),
                                        firstDate: DateTime(2000),
                                        lastDate: DateTime(2100),
                                      );

                                      if (pickedDate != null) {
                                        setState(() {
                                          tanggalMulai = pickedDate;
                                          _tanggalMulaiController.text =
                                              '${pickedDate.day}-${pickedDate.month}-${pickedDate.year}';
                                        });
                                      }
                                    },
                                    validator: (value) =>
                                        value == null || value.isEmpty
                                            ? 'Wajib pilih tanggal mulai'
                                            : null,
                                  ),
                                  const SizedBox(height: 20),
                                  TextFormField(
                                    controller: _tanggalSelesaiController,
                                    readOnly: true,
                                    decoration: InputDecoration(
                                      labelText: 'Tanggal Selesai Cuti',
                                      labelStyle:
                                          const TextStyle(color: Colors.blue),
                                      suffixIcon: const Icon(
                                        Icons.calendar_today,
                                        color: Colors.blue,
                                      ),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(10),
                                        borderSide: const BorderSide(
                                            color: Colors.blue, width: 2),
                                      ),
                                      filled: true,
                                      fillColor: Colors.white,
                                    ),
                                    onTap: () async {
                                      FocusScope.of(context).unfocus();

                                      DateTime? pickedDate =
                                          await showDatePicker(
                                        context: context,
                                        initialDate:
                                            tanggalSelesai ?? DateTime.now(),
                                        firstDate: DateTime(2000),
                                        lastDate: DateTime(2100),
                                      );

                                      if (pickedDate != null) {
                                        setState(() {
                                          tanggalSelesai = pickedDate;
                                          _tanggalSelesaiController.text =
                                              '${pickedDate.day}-${pickedDate.month}-${pickedDate.year}';
                                        });
                                      }
                                    },
                                    validator: (value) =>
                                        value == null || value.isEmpty
                                            ? 'Wajib pilih tanggal selesai'
                                            : null,
                                  ),
                                  const SizedBox(height: 30),
                                  SizedBox(
                                    width: double.infinity,
                                    child: ElevatedButton(
                                      onPressed: () async {
                                        if (formkey.currentState!.validate()) {
                                          if (tanggalMulai != null &&
                                              tanggalSelesai != null) {
                                            await _pengajuanCutiController
                                                .ajukanCuti(
                                              username ?? 'User',
                                              id ?? '0',
                                              jabatan ?? 'karyawan',
                                              tanggalMulai!,
                                              tanggalSelesai!,
                                              _alasanCutiController.text,
                                            );
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(
                                              SnackBar(
                                                content: const Text(
                                                    'Pengajuan cuti berhasil.'),
                                                behavior:
                                                    SnackBarBehavior.floating,
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                ),
                                                backgroundColor:
                                                    Colors.green.shade600,
                                              ),
                                            );
                                            Navigator.pushReplacement(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      Homekaryawan()),
                                            );
                                          } else {
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(
                                              SnackBar(
                                                content: const Text(
                                                    'Tanggal cuti belum lengkap.'),
                                                behavior:
                                                    SnackBarBehavior.floating,
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                ),
                                                backgroundColor:
                                                    Colors.orange.shade600,
                                              ),
                                            );
                                          }
                                        }
                                      },
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.blue.shade700,
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 15),
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                        elevation: 5,
                                      ),
                                      child: const Text(
                                        'Ajukan Cuti',
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStatusItem(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 20, color: Colors.blue.shade600),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: Colors.blueGrey.shade700,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
