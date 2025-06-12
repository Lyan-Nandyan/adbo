import 'package:adbo/login/loginKaryawan.dart';
import 'package:adbo/models/boxes.dart';
import 'package:adbo/models/karyawan.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

class RegisKaryawan extends StatefulWidget {
  const RegisKaryawan({super.key});

  @override
  State<RegisKaryawan> createState() => _RegisKaryawanState();
}

class _RegisKaryawanState extends State<RegisKaryawan>
    with SingleTickerProviderStateMixin {
  final _usernameCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );

    _slideAnimation =
        Tween<Offset>(begin: const Offset(0, 0.2), end: Offset.zero).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );

    _animationController.forward();
  }

  Future<bool> registerUser(String username, String password) async {
    var box = Hive.box<Karyawan>(HiveBox.karyawan);

    bool exists = box.values.any(
        (karyawan) => karyawan.nama.toLowerCase() == username.toLowerCase());
    if (exists) return false;

    int key = await box.add(Karyawan(
      nama: username,
      password: password,
      jabatan: "karyawan",
      cuti: "0",
    ));
    Karyawan? newKaryawan = box.get(key);
    if (newKaryawan != null) {
      newKaryawan.id = key.toString();
      await newKaryawan.save();
    }
    return true;
  }

  Future<void> _register() async {
    if (_formKey.currentState!.validate()) {
      bool success = await registerUser(
        _usernameCtrl.text.trim(),
        _passwordCtrl.text,
      );

      if (mounted) {
        if (success) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text("Registrasi Berhasil. Silahkan Login."),
              backgroundColor: Colors.green.shade700,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              margin: const EdgeInsets.all(10),
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
            SnackBar(
              content: const Text(
                  "Username sudah terdaftar. Silahkan gunakan username lain."),
              backgroundColor: Colors.red.shade700,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              margin: const EdgeInsets.all(10),
            ),
          );
        }
      }
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    _usernameCtrl.dispose();
    _passwordCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Registrasi Akun Karyawan',
            style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: theme.primaryColor,
        foregroundColor: theme.colorScheme.onPrimary,
        elevation: 4.0,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              theme.primaryColor.withOpacity(0.1),
              theme.colorScheme.surface.withOpacity(0.1),
              Colors.white,
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(
                horizontal: screenWidth * 0.06, vertical: screenHeight * 0.03),
            child: SlideTransition(
              position: _slideAnimation,
              child: FadeTransition(
                opacity: _fadeAnimation,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Icon(
                      Icons.person_add_alt_1,
                      size: screenHeight * 0.12,
                      color: theme.primaryColor,
                    ),
                    SizedBox(height: screenHeight * 0.02),
                    Text(
                      "Buat Akun Karyawan",
                      textAlign: TextAlign.center,
                      style: theme.textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: theme.primaryColorDark,
                      ),
                    ),
                    SizedBox(height: screenHeight * 0.01),
                    Text(
                      "Daftarkan diri Anda untuk mengakses sistem.",
                      textAlign: TextAlign.center,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: Colors.grey.shade700,
                      ),
                    ),
                    SizedBox(height: screenHeight * 0.04),
                    Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          TextFormField(
                            controller: _usernameCtrl,
                            decoration: InputDecoration(
                              labelText: 'Username',
                              hintText:
                                  'Masukkan username (NIK atau ID Karyawan)',
                              prefixIcon: Icon(Icons.badge_outlined,
                                  color: theme.primaryColor),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12.0),
                                borderSide: BorderSide(
                                    color: theme.primaryColor.withOpacity(0.5)),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12.0),
                                borderSide: BorderSide(
                                    color: theme.primaryColor, width: 2),
                              ),
                              filled: true,
                              fillColor: Colors.white.withOpacity(0.95),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Username tidak boleh kosong';
                              }
                              if (value.length < 5) {
                                return 'Username minimal 5 karakter';
                              }
                              return null;
                            },
                          ),
                          SizedBox(height: screenHeight * 0.02),
                          TextFormField(
                            controller: _passwordCtrl,
                            decoration: InputDecoration(
                              labelText: 'Password',
                              hintText: 'Buat password Anda',
                              prefixIcon: Icon(Icons.lock_outline_rounded,
                                  color: theme.primaryColor),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12.0),
                                borderSide: BorderSide(
                                    color: theme.primaryColor.withOpacity(0.5)),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12.0),
                                borderSide: BorderSide(
                                    color: theme.primaryColor, width: 2),
                              ),
                              filled: true,
                              fillColor: Colors.white.withOpacity(0.95),
                            ),
                            obscureText: true,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Password tidak boleh kosong';
                              }
                              if (value.length < 6) {
                                return 'Password minimal 6 karakter';
                              }
                              return null;
                            },
                          ),
                          SizedBox(height: screenHeight * 0.04),
                          ElevatedButton(
                            onPressed: _register,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: theme.primaryColor,
                              foregroundColor: theme.colorScheme.onPrimary,
                              padding: EdgeInsets.symmetric(
                                  horizontal: screenWidth * 0.15,
                                  vertical: screenHeight * 0.018),
                              textStyle: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12.0),
                              ),
                              elevation: 5.0,
                              shadowColor: theme.primaryColor.withOpacity(0.4),
                            ),
                            child: const Text('DAFTAR SEKARANG'),
                          ),
                          SizedBox(height: screenHeight * 0.025),
                          TextButton(
                            onPressed: () {
                              Navigator.pushReplacement(
                                context,
                                PageRouteBuilder(
                                  pageBuilder: (context, animation,
                                          secondaryAnimation) =>
                                      const LoginKaryawan(),
                                  transitionsBuilder: (context, animation,
                                      secondaryAnimation, child) {
                                    const begin = Offset(1.0, 0.0);
                                    const end = Offset.zero;
                                    const curve = Curves.easeInOutCubic;
                                    var tween = Tween(begin: begin, end: end)
                                        .chain(CurveTween(curve: curve));
                                    return SlideTransition(
                                      position: animation.drive(tween),
                                      child: child,
                                    );
                                  },
                                  transitionDuration:
                                      const Duration(milliseconds: 400),
                                ),
                              );
                            },
                            child: RichText(
                              text: TextSpan(
                                text: 'Sudah punya akun? ',
                                style: TextStyle(
                                  color: Colors.grey.shade700,
                                ),
                                children: <TextSpan>[
                                  TextSpan(
                                    text: 'Login di sini',
                                    style: TextStyle(
                                      color: theme.primaryColorDark,
                                      fontWeight: FontWeight.bold,
                                      decoration: TextDecoration.underline,
                                      decorationColor: theme.primaryColorDark,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
