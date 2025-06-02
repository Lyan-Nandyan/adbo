import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:adbo/menu/homeManager.dart';
import 'package:adbo/regis/registerManager.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../models/boxes.dart';
import '../../models/manager.dart';

class LoginManager extends StatefulWidget {
  const LoginManager({super.key});
  @override
  State<LoginManager> createState() => _LoginManagerState();
}

class _LoginManagerState extends State<LoginManager> {
  final _formKey = GlobalKey<FormState>();
  final _namaCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();

  Future<bool> _checkLoginStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
    final jabatan = prefs.getString('jabatan');
    return isLoggedIn && jabatan == "manager";
  }

  Future<void> _login() async {
    if (_formKey.currentState!.validate()) {
      Box<Manager> managerBox = Hive.box<Manager>(HiveBox.manager);
      Manager? loginManager = managerBox.values.cast<Manager?>().firstWhere(
            (manager) =>
                manager != null &&
                manager.nama == _namaCtrl.text &&
                manager.password == _passwordCtrl.text,
            orElse: () => null,
          );

      if (loginManager != null) {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setBool('isLoggedIn', true);
        await prefs.setString('nama', _namaCtrl.text);
        await prefs.setString('jabatan', "manager");

        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(
          content: Text('Login Berhasil'),
          backgroundColor: Colors.green,
        ));

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const HomeManager(),
          ),
        );
      } else {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(
          content: Text('Nama atau password salah'),
          backgroundColor: Colors.red,
        ));
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
    return FutureBuilder<bool>(
      future: _checkLoginStatus(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasData && !snapshot.data!) {
          return Scaffold(
            appBar: AppBar(title: const Text('Login Manager')),
            body: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    TextFormField(
                      controller: _namaCtrl,
                      decoration: const InputDecoration(labelText: 'Nama'),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter nama';
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
                        onPressed: _login, child: const Text('Login')),
                    TextButton(
                      onPressed: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const RegisterManager(),
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
                builder: (context) => const HomeManager(),
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
