import 'package:adbo/logic/penilaianController.dart';
import 'package:adbo/models/penilaian.dart';
import 'package:flutter/material.dart';

class Formpenilaian extends StatefulWidget {
  final idkaryawan;
  final nama;
  const Formpenilaian({super.key, this.idkaryawan, this.nama});

  @override
  State<Formpenilaian> createState() => _FormpenilaianState();
}

class _FormpenilaianState extends State<Formpenilaian> {
  final Penilaiancontroller _penilaianController = Penilaiancontroller();
  final TextEditingController _keandalan = TextEditingController();
  final TextEditingController _kualitas = TextEditingController();
  final TextEditingController _inisiatif = TextEditingController();
  final TextEditingController _komunikasi = TextEditingController();
  final TextEditingController _kerjasama = TextEditingController();
  final TextEditingController _pengetahuan = TextEditingController();
  double _score = 0;
  List<Penilaian> _logPenilaian = [];

  Future<void> _loadPenilaian() async {
    List<Penilaian> data =
        await _penilaianController.getPenilaianByKaryawan(widget.idkaryawan);
    data.sort((a, b) => (b.tanggal ?? DateTime(0))
        .compareTo(a.tanggal ?? DateTime(0))); // Sort by date descending
    setState(() {
      _logPenilaian = data;
    });
  }

  void _submitPenilaian() {
    if (_keandalan.text.isEmpty ||
        _kualitas.text.isEmpty ||
        _inisiatif.text.isEmpty ||
        _komunikasi.text.isEmpty ||
        _kerjasama.text.isEmpty ||
        _pengetahuan.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Semua field harus diisi')),
      );
      return;
    }

    setState(() {
      _score = (double.parse(_keandalan.text) +
              double.parse(_kualitas.text) +
              double.parse(_inisiatif.text) +
              double.parse(_komunikasi.text) +
              double.parse(_kerjasama.text) +
              double.parse(_pengetahuan.text)) /
          6;
    });
    _penilaianController.addPenilaian(widget.idkaryawan, _score);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Penilaian berhasil dikirim')),
    );

    Navigator.pop(context);
  }

  Widget _buildTextField(TextEditingController controller, String label) {
    return TextField(
      controller: controller,
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _loadPenilaian();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Form Penilaian Karyawan'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          child: Column(
            children: [
              Text('Penilaian untuk ${widget.nama} (${widget.idkaryawan})'),
              const SizedBox(height: 20),
              _buildTextField(_keandalan, 'Keandalan'),
              _buildTextField(_kualitas, 'Kualitas Pekerjaan'),
              _buildTextField(_inisiatif, 'Inisiatif'),
              _buildTextField(_komunikasi, 'Komunikasi'),
              _buildTextField(_kerjasama, 'Kerjasama Tim'),
              _buildTextField(_pengetahuan, 'Pengetahuan Pekerjaan'),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  _submitPenilaian();
                },
                child: const Text('Kirim Penilaian'),
              ),
              const SizedBox(height: 20),
              const Text(
                'Log Penilaian:',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: _logPenilaian.length,
                  itemBuilder: (context, index) {
                    final penilaian = _logPenilaian[index];
                    return ListTile(
                      title: Text('Score: ${penilaian.score}'),
                      subtitle: Text('Tanggal: ${penilaian.tanggal}'),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
