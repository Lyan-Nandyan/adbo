import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:adbo/loginHrd.dart';

class HomeHrd extends StatelessWidget {
  const HomeHrd({super.key});

  Future<void> _logout(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear();

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const Loginhrd()),
    );
  }

  Future<String> _getNama() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('username') ?? 'HRD';
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String>(
      future: _getNama(),
      builder: (context, snapshot) {
        final nama = snapshot.data ?? '...';
        return Scaffold(
          appBar: AppBar(
            title: const Text('Home HRD'),
            automaticallyImplyLeading: false,
          ),
          body: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                children: [
                  const SizedBox(height: 40),
                  Text(
                    'Selamat datang, $nama!',
                    style: const TextStyle(fontSize: 20),
                  ),
                  const SizedBox(height: 20),
                  const Text('Ini adalah halaman home untuk HRD.'),
                  const SizedBox(height: 40),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24.0),
                    child: Column(
                      children: [
                        ElevatedButton.icon(
                          onPressed: () {
                            // Navigasi ke halaman Absensi Karyawan
                          },
                          icon: const Icon(Icons.access_time),
                          label: const Text('Absensi Karyawan'),
                          style: ElevatedButton.styleFrom(
                            minimumSize: const Size(double.infinity, 50),
                          ),
                        ),
                        const SizedBox(height: 20),
                        ElevatedButton.icon(
                          onPressed: () {
                            // Navigasi ke halaman Gaji Karyawan
                          },
                          icon: const Icon(Icons.attach_money),
                          label: const Text('Gaji Karyawan'),
                          style: ElevatedButton.styleFrom(
                            minimumSize: const Size(double.infinity, 50),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(24.0),
                child: ElevatedButton.icon(
                  onPressed: () => _logout(context),
                  icon: const Icon(Icons.logout),
                  label: const Text('Logout'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    foregroundColor: Colors.white,
                    minimumSize: const Size(double.infinity, 50),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
