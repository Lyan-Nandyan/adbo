import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:adbo/login/loginHrd.dart'; // folder sudah diganti
import 'package:adbo/models/boxes.dart';
import 'package:adbo/models/hrd.dart'; // ganti dari user.dart ke hrd.dart

class Regishrd extends StatefulWidget {
  const Regishrd({super.key});

  @override
  State<Regishrd> createState() => _RegishrdState();
}

class _RegishrdState extends State<Regishrd> {
  final _usernameCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  Future<bool> registerHrd(
      String username, String password, String email) async {
    var box = Hive.box<Hrd>(HiveBox.hrd); // ganti User ke Hrd dan HiveBox.hrd
    bool exists = box.values.any((hrd) => hrd.nama == username);
    if (exists) return false;
    int key = await box.add(
        Hrd(nama: username, password: password, jabatan: "bos", email: email));
    Hrd? newHrd = box.get(key);
    if (newHrd != null) {
      newHrd.id = key.toString(); // Simpan key sebagai id
      await newHrd.save(); // Simpan perubahan
    }
    return true;
  }

  Future<void> _register() async {
    if (_formKey.currentState!.validate()) {
      bool success = await registerHrd(
        _usernameCtrl.text,
        _passwordCtrl.text,
        _emailCtrl.text,
      );
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
            builder: (context) => const Loginhrd(),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Username sudah terdaftar"),
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
    _emailCtrl.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Register HRD')),
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
              TextFormField(
                controller: _emailCtrl,
                decoration: const InputDecoration(labelText: 'Email'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Masukkan email';
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
                      builder: (context) => const Loginhrd(),
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
