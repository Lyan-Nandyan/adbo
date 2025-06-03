import 'package:adbo/logic/cutiController.dart';
import 'package:adbo/menu/homeKaryawan.dart';
import 'package:flutter/material.dart';
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
        title: const Text('Pengajuan Cuti'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'Pengajuan Cuti Karyawan',
              style: TextStyle(fontSize: 24),
            ),
            const SizedBox(height: 20),
            FutureBuilder<bool>(
              future: _pengajuanCutiController.isAlreadyCuti(
                  id ?? 'null', jabatan ?? 'null'),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (snapshot.hasError) {
                  return const Text('Terjadi kesalahan. Silakan coba lagi.');
                }

                if (snapshot.data == true) {
                  return const Text('Anda sudah mengajukan cuti.');
                }

                // Jika belum mengajukan cuti
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('Anda belum mengajukan cuti.'),
                    const SizedBox(height: 20),
                    Form(
                      key: formkey,
                      child: Column(
                        children: [
                          TextFormField(
                            controller: _alasanCutiController,
                            decoration: const InputDecoration(
                              labelText: 'Alasan Cuti',
                            ),
                            validator: (value) => value == null || value.isEmpty
                                ? 'Wajib diisi'
                                : null,
                          ),
                          TextFormField(
                            controller: _tanggalMulaiController,
                            readOnly: true,
                            decoration: const InputDecoration(
                              labelText: 'Tanggal Mulai Cuti',
                              suffixIcon: Icon(Icons.calendar_today),
                            ),
                            onTap: () async {
                              FocusScope.of(context).unfocus();

                              DateTime? pickedDate = await showDatePicker(
                                context: context,
                                initialDate: tanggalMulai ?? DateTime.now(),
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
                            validator: (value) => value == null || value.isEmpty
                                ? 'Wajib pilih tanggal mulai'
                                : null,
                          ),
                          TextFormField(
                            controller: _tanggalSelesaiController,
                            readOnly: true,
                            decoration: const InputDecoration(
                              labelText: 'Tanggal Selesai Cuti',
                              suffixIcon: Icon(Icons.calendar_today),
                            ),
                            onTap: () async {
                              FocusScope.of(context).unfocus();

                              DateTime? pickedDate = await showDatePicker(
                                context: context,
                                initialDate: tanggalSelesai ?? DateTime.now(),
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
                            validator: (value) => value == null || value.isEmpty
                                ? 'Wajib pilih tanggal selesai'
                                : null,
                          ),
                          const SizedBox(height: 20),
                          ElevatedButton(
                            onPressed: () async {
                              if (formkey.currentState!.validate()) {
                                if (tanggalMulai != null &&
                                    tanggalSelesai != null) {
                                  await _pengajuanCutiController.ajukanCuti(
                                    username ?? 'User',
                                    id ?? '0',
                                    jabatan ?? 'karyawan',
                                    tanggalMulai!,
                                    tanggalSelesai!,
                                    _alasanCutiController.text,
                                  );
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                        content:
                                            Text('Pengajuan cuti berhasil.')),
                                  );
                                  Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => Homekaryawan()),
                                  );
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                        content: Text(
                                            'Tanggal cuti belum lengkap.')),
                                  );
                                }
                              }
                            },
                            child: const Text('Ajukan Cuti'),
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
    );
  }
}
