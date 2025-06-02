import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:adbo/loginManager.dart';
import 'package:adbo/models/boxes.dart';
import 'package:adbo/models/manager.dart';

class RegisterManager extends StatefulWidget {
  const RegisterManager({super.key});

  @override
  State<RegisterManager> createState() => _RegisterManagerState();
}

class _RegisterManagerState extends State<RegisterManager> {
  final _namaCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  Future<bool> registerManager(String nama, String password) async {
    try {
      // Pastikan box sudah terbuka
      Box<Manager> box;
      if (Hive.isBoxOpen(HiveBox.manager)) {
        box = Hive.box<Manager>(HiveBox.manager);
      } else {
        box = await Hive.openBox<Manager>(HiveBox.manager);
      }
      
      // Cek apakah nama sudah ada
      bool exists = box.values.any((manager) => manager.nama == nama);
      if (exists) {
        return false;
      }
      
      // Tambahkan manager baru
      Manager newManager = Manager(nama: nama, password: password, jabatan: "Manager");
      await box.add(newManager);
      
      print('Manager berhasil ditambahkan: $nama'); // Debug log
      return true;
    } catch (e) {
      print('Error saat register: $e'); // Debug log
      return false;
    }
  }

  Future<void> _register() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      try {
        bool success = await registerManager(
          _namaCtrl.text.trim(), 
          _passwordCtrl.text.trim(), 
        );
        
        if (success) {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text("Registrasi Berhasil! Silahkan Login"),
                backgroundColor: Colors.green,
                duration: Duration(seconds: 2),
              ),
            );
            
            // Clear form
            _namaCtrl.clear();
            _passwordCtrl.clear();
            
            
            // Navigate to login
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => const LoginManager(),
              ),
            );
          }
        } else {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text("Nama Manager Sudah Terdaftar!"),
                backgroundColor: Colors.red,
                duration: Duration(seconds: 2),
              ),
            );
          }
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text("Terjadi kesalahan: $e"),
              backgroundColor: Colors.red,
              duration: const Duration(seconds: 2),
            ),
          );
        }
      } finally {
        if (mounted) {
          setState(() {
            _isLoading = false;
          });
        }
      }
    }
  }

  @override
  void dispose() {
    _namaCtrl.dispose();
    _passwordCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Register Manager'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Daftar Akun Manager',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 30),
              TextFormField(
                controller: _namaCtrl,
                decoration: const InputDecoration(
                  labelText: 'Nama Lengkap',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.person),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Nama tidak boleh kosong';
                  }
                  if (value.trim().length < 3) {
                    return 'Nama minimal 3 karakter';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _passwordCtrl,
                decoration: const InputDecoration(
                  labelText: 'Password',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.lock),
                ),
                obscureText: true,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Password tidak boleh kosong';
                  }
                  if (value.trim().length < 6) {
                    return 'Password minimal 6 karakter';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _register,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                  ),
                  child: _isLoading
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                          ),
                        )
                      : const Text(
                          'DAFTAR',
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                ),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Sudah punya akun? '),
                  TextButton(
                    onPressed: _isLoading ? null : () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const LoginManager(),
                        ),
                      );
                    },
                    child: const Text(
                      'Login di sini',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}