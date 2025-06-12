import 'package:adbo/fitur/laporan_gaji_manajer.dart';
import 'package:adbo/fitur/listKaryawan.dart';
import 'package:adbo/fitur/listPengajuanCuti.dart';
import 'package:adbo/fitur/logAbsensi.dart';
import 'package:flutter/material.dart';
import 'package:adbo/login/loginManager.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeManager extends StatefulWidget {
  const HomeManager({super.key});

  @override
  State<HomeManager> createState() => _HomeManagerState();
}

class _HomeManagerState extends State<HomeManager> {
  String? nama;
  String? jabatan;
  bool isLoggedIn = false;
  bool isLoading = true;

  Future<void> _checkLoginAndLoadData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool loginStatus = prefs.getBool('isLoggedIn') ?? false;
    String? savedNama = prefs.getString('nama');

    if (!loginStatus || savedNama == null || savedNama.isEmpty) {
      _redirectToLogin();
      return;
    }

    setState(() {
      nama = savedNama;
      jabatan = prefs.getString('jabatan') ?? '';
      isLoggedIn = true;
      isLoading = false;
    });
  }

  Future<void> _redirectToLogin() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('nama');
    await prefs.remove('jabatan');
    await prefs.setBool('isLoggedIn', false);

    if (mounted) {
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => const LoginManager()),
        (route) => false,
      );
    }
  }

  Future<void> _logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear();

    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (context) => const LoginManager()),
      (route) => false,
    );
  }

  @override
  void initState() {
    super.initState();
    _checkLoginAndLoadData();
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    if (!isLoggedIn) {
      return const Scaffold(
        body: Center(
          child: Text('Redirecting to login...'),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Hello $nama", style: const TextStyle(fontSize: 18)),
            if (jabatan != null && jabatan!.isNotEmpty)
              Text(
                jabatan!,
                style: TextStyle(fontSize: 12, color: Colors.grey[600]),
              ),
          ],
        ),
        actions: [
          IconButton(
            onPressed: _logout,
            icon: const Icon(Icons.logout),
            tooltip: 'Logout',
          ),
        ],
        automaticallyImplyLeading: false,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Dashboard Manager',
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    const SizedBox(height: 8),
                    const Text('Selamat datang di sistem manajemen ADBO'),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                children: [
                  _buildMenuCard(
                    context,
                    'Kelola Karyawan',
                    Icons.people,
                    Colors.blue,
                    () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Kelola Karyawan')),
                      );
                    },
                  ),
                  _buildMenuCard(
                    context,
                    'Kelola Absensi',
                    Icons.access_time,
                    Colors.green,
                    () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => Logabsensi(),
                          ));
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Kelola Absensi')),
                      );
                    },
                  ),
                  _buildMenuCard(
                    context,
                    'Kelola Cuti',
                    Icons.calendar_today,
                    Colors.orange,
                    () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => Listpengajuancuti(),
                          ));
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Kelola Cuti')),
                      );
                    },
                  ),
                  _buildMenuCard(
                    context,
                    'Laporan Gaji',
                    Icons.attach_money,
                    Colors.purple,
                    () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const LaporanGajiManager(),
                        ),
                      );
                    },
                  ),
                  _buildMenuCard(
                    context,
                    'Penilaian',
                    Icons.star_rate,
                    Colors.red,
                    () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const Listkaryawan(),
                          ));
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Penilaian')),
                      );
                    },
                  ),
                  _buildMenuCard(
                    context,
                    'Laporan',
                    Icons.assessment,
                    Colors.teal,
                    () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Laporan')),
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuCard(
    BuildContext context,
    String title,
    IconData icon,
    Color color,
    VoidCallback onTap,
  ) {
    return Card(
      elevation: 4,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 48,
                color: color,
              ),
              const SizedBox(height: 12),
              Text(
                title,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
