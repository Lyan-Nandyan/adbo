import 'package:adbo/logic/cutiController.dart';
import 'package:adbo/models/cuti.dart';
import 'package:flutter/material.dart';

class Listpengajuancuti extends StatefulWidget {
  const Listpengajuancuti({super.key});

  @override
  State<Listpengajuancuti> createState() => _ListpengajuancutiState();
}

class _ListpengajuancutiState extends State<Listpengajuancuti> {
  final CutiController _pengajuanCutiController = CutiController();
  List<Cuti> pengajuanCutiList = [];

  Future<void> _loadPengajuanCuti() async {
    List<Cuti> data = await _pengajuanCutiController.getAllCuti();
    setState(() {
      pengajuanCutiList = data;
    });
  }

  @override
  void initState() {
    super.initState();
    _loadPengajuanCuti();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('List Pengajuan Cuti'),
      ),
      body: ListView.builder(
        itemCount: pengajuanCutiList.length,
        itemBuilder: (context, index) {
          final cuti = pengajuanCutiList[index];
          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${cuti.nama} (${cuti.jabatan})',
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  const SizedBox(height: 6),
                  Text('Mulai: ${cuti.mulai}'),
                  Text('Selesai: ${cuti.selesai}'),
                  Text('Alasan: ${cuti.alasan}'),
                  const SizedBox(height: 8),
                  Text('Status: ${cuti.status}'),
                  if (cuti.status == 'Pending') ...[
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        ElevatedButton(
                          onPressed: () async {
                            if (cuti.id != null) {
                              await _pengajuanCutiController
                                  .setujuiCuti(cuti.id ?? '');
                              setState(() {
                                pengajuanCutiList.removeAt(index);
                              });
                              Navigator.pop(context);
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
                          ),
                          child: const Text('Approve'),
                        ),
                        const SizedBox(width: 10),
                        ElevatedButton( 
                          onPressed: () async {
                            if (cuti.id != null) {
                              await _pengajuanCutiController
                                  .tolakCuti(cuti.id ?? '');
                              setState(() {
                                pengajuanCutiList.removeAt(index);
                              });
                              Navigator.pop(context);
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red,
                          ),
                          child: const Text('Reject'),
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
