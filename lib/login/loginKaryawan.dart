import 'package:adbo/menu/homeKaryawan.dart';
import 'package:adbo/models/boxes.dart';
import 'package:adbo/models/karyawan.dart';
import 'package:adbo/regis/regisKaryawan.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginKaryawan extends StatefulWidget {
  const LoginKaryawan({super.key});

  @override
  State<LoginKaryawan> createState() => _LoginKaryawanState();
}

class _LoginKaryawanState extends State<LoginKaryawan> {
  final _formKey = GlobalKey<FormState>();
  final _usernameCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();
  final String jabatan = "karyawan";

  Future<bool> _checkLoginStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
    final jabatan = prefs.getString('jabatan');
    return isLoggedIn && jabatan == "karyawan";
  }

  Future<void> _login() async {
    if (_formKey.currentState!.validate()) {
      Box<Karyawan> karyawanBox = Hive.box<Karyawan>(HiveBox.karyawan);
      bool loginSuccess = karyawanBox.values.any(
        (karyawan) =>
            karyawan.nama == _usernameCtrl.text &&
            karyawan.password == _passwordCtrl.text,
      );

      if (loginSuccess) {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setBool('isLoggedIn', true);
        await prefs.setString('username', _usernameCtrl.text);
        await prefs.setString('jabatan', jabatan);
        await prefs.setString('id', karyawanBox.values.firstWhere((karyawan) => karyawan.nama == _usernameCtrl.text).key.toString());
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(
          content: Text('Login Berhasil'),
          backgroundColor: Colors.green,
        ));

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const Homekaryawan(),
          ),
        );
      } else {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(
          content: Text('username atau password salah'),
          backgroundColor: Colors.red,
        ));
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
    return FutureBuilder<bool>(
      future: _checkLoginStatus(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasData && !snapshot.data!) {
          return Scaffold(
            appBar: AppBar(title: const Text('Login Karyawan')),
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
                    ElevatedButton(onPressed: _login, child: const Text('Login')),
                    TextButton(
                      onPressed: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const RegisKaryawan(),
                          ),
                        );
                      },
                      child: const Text('Don\'t have account? Register'),
                    ),
                  ],
                ),
              ),
            ),
          );
        } else if (snapshot.hasData && snapshot.data!) {
          return Navigator(
            onGenerateRoute: (settings) {
              return MaterialPageRoute(
                builder: (context) => const Homekaryawan(),
              );
            },
          );
        } else {
          return const SizedBox.shrink();
        }
      },
    );
  }
}
