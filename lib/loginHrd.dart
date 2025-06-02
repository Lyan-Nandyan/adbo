import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:adbo/homeHrd.dart';
import 'package:adbo/regisHrd.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/boxes.dart';
import '../models/hrd.dart'; // <-- ganti import ke Hrd

class Loginhrd extends StatefulWidget {
  const Loginhrd({super.key});

  @override
  State<Loginhrd> createState() => _LoginhrdState();
}

class _LoginhrdState extends State<Loginhrd> {
  final _formKey = GlobalKey<FormState>();
  final _usernameCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();

  Future<void> _login() async {
    if (_formKey.currentState!.validate()) {
      Box<Hrd> hrdBox = Hive.box<Hrd>(HiveBox.hrd);

      bool loginSuccess = hrdBox.values.any(
        (hrd) =>
            hrd.nama == _usernameCtrl.text &&
            hrd.password == _passwordCtrl.text,
      );

      if (loginSuccess) {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setBool('isLoggedIn', true);
        await prefs.setString('username', _usernameCtrl.text);
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(
          content: Text('Login Berhasil'),
          backgroundColor: Colors.green,
        ));

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const HomeHrd(),
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
    return Scaffold(
      appBar: AppBar(title: const Text('Login')),
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
                      builder: (context) => const Regishrd(),
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
  }
}
