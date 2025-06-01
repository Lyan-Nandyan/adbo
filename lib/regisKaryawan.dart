import 'package:adbo/loginKaryawan.dart';
import 'package:adbo/models/boxes.dart';
import 'package:adbo/models/karyawan.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

class RegisKaryawan extends StatefulWidget {
  const RegisKaryawan({super.key});

  @override
  State<RegisKaryawan> createState() => _RegisKaryawanState();
}

class _RegisKaryawanState extends State<RegisKaryawan> {
  final _usernameCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  Future<bool> registerUser(String username, String password) async {
    var box = Hive.box<Karyawan>(HiveBox.karyawan);
    bool exists = box.values.any((karyawan) => karyawan.nama == username);
    if (exists) return false;
    await box.add(Karyawan(
        nama: username,
        password: password,
        jabatan: "karyawan",
        cuti: "tidak"));
    return true;
  }

  Future<void> _register() async {
    if (_formKey.currentState!.validate()) {
      bool success = await registerUser(_usernameCtrl.text, _passwordCtrl.text);
      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Registrasi Berhasil Silahkan Login"),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const LoginKaryawan(),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Usename Sudah Terdaftar"),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  void dispose() {
    _usernameCtrl.dispose();
    _passwordCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Register')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _usernameCtrl,
                decoration: const InputDecoration(labelText: 'Username'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter username';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _passwordCtrl,
                decoration: const InputDecoration(labelText: 'Password'),
                obscureText: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter password';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _register,
                child: const Text('Register'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const LoginKaryawan(),
                    ),
                  );
                },
                child: const Text('Already have account? Login'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
