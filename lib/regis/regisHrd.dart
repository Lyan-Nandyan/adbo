import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:adbo/login/loginHrd.dart'; 
import 'package:adbo/models/boxes.dart';
import 'package:adbo/models/hrd.dart'; 

class Regishrd extends StatefulWidget {
  const Regishrd({super.key});

  @override
  State<Regishrd> createState() => _RegishrdState();
}

class _RegishrdState extends State<Regishrd>
    with SingleTickerProviderStateMixin {
  final _usernameCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
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

  Future<bool> registerHrd(
      String username, String password, String email) async {
    var box = Hive.box<Hrd>(HiveBox.hrd);
    bool exists = box.values.any((hrd) => hrd.nama == username);
    if (exists) return false;
    int key = await box.add(Hrd(
        nama: username,
        password: password,
        jabatan: "hrd",
        email: email)); 
    Hrd? newHrd = box.get(key);
    if (newHrd != null) {
      newHrd.id = key.toString();
      await newHrd.save();
    }
    return true;
  }

  Future<void> _register() async {
    if (_formKey.currentState!.validate()) {
      bool success = await registerHrd(
        _usernameCtrl.text.trim(),
        _passwordCtrl.text, 
        _emailCtrl.text.trim(),
      );

    

      if (mounted) {
     
        if (success) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text("Registrasi Berhasil. Silahkan Login."),
              backgroundColor: Colors.green.shade700,
              behavior: SnackBarBehavior.floating,
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
            SnackBar(
              content: const Text(
                  "Username sudah terdaftar. Silahkan gunakan username lain."),
              backgroundColor: Colors.red.shade700,
              behavior: SnackBarBehavior.floating,
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
    _emailCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
     
      appBar: AppBar(
        title: const Text('Registrasi Akun HRD',
            style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor:
            theme.primaryColor, 
        foregroundColor:
            theme.colorScheme.onPrimary, 
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
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: SlideTransition(
              position: _slideAnimation,
              child: FadeTransition(
                opacity: _fadeAnimation,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
               
                    Icon(
                      Icons
                          .business_center, 
                      size: screenHeight * 0.12,
                      color: theme.primaryColor,
                    ),
                    SizedBox(height: screenHeight * 0.02),
                    Text(
                      "Buat Akun Baru",
                      textAlign: TextAlign.center,
                      style: theme.textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: theme.primaryColorDark,
                      ),
                    ),
                    SizedBox(height: screenHeight * 0.01),
                    Text(
                      "Isi data diri Anda untuk melanjutkan.",
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
                              hintText: 'Masukkan username Anda',
                              prefixIcon: Icon(Icons.person_outline,
                                  color: theme.primaryColor),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12.0),
                              ),
                              filled: true,
                              fillColor: Colors.white.withOpacity(0.9),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Username tidak boleh kosong';
                              }
                              if (value.length < 4) {
                                return 'Username minimal 4 karakter';
                              }
                              return null;
                            },
                          ),
                          SizedBox(height: screenHeight * 0.02),

                    
                          TextFormField(
                            controller: _passwordCtrl,
                            decoration: InputDecoration(
                              labelText: 'Password',
                              hintText: 'Masukkan password Anda',
                              prefixIcon: Icon(Icons.lock_outline,
                                  color: theme.primaryColor),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12.0),
                              ),
                              filled: true,
                              fillColor: Colors.white.withOpacity(0.9),
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
                          SizedBox(height: screenHeight * 0.02),

         
                          TextFormField(
                            controller: _emailCtrl,
                            decoration: InputDecoration(
                              labelText: 'Email',
                              hintText: 'Masukkan alamat email Anda',
                              prefixIcon: Icon(Icons.email_outlined,
                                  color: theme.primaryColor),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12.0),
                              ),
                              filled: true,
                              fillColor: Colors.white.withOpacity(0.9),
                            ),
                            keyboardType: TextInputType.emailAddress,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Email tidak boleh kosong';
                              }
                              if (!RegExp(r'^[^@]+@[^@]+\.[^@]+')
                                  .hasMatch(value)) {
                                return 'Masukkan format email yang valid';
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
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 50, vertical: 15),
                              textStyle: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12.0),
                              ),
                              elevation: 5.0, // Efek timbul
                            ),
                            child: const Text('REGISTER AKUN'),
                          ),
                          SizedBox(height: screenHeight * 0.02),

                     
                          TextButton(
                            onPressed: () {
                              Navigator.pushReplacement(
                                context,
                                PageRouteBuilder(
            
                                  pageBuilder: (context, animation,
                                          secondaryAnimation) =>
                                      const Loginhrd(),
                                  transitionsBuilder: (context, animation,
                                      secondaryAnimation, child) {
                                    const begin = Offset(1.0, 0.0);
                                    const end = Offset.zero;
                                    const curve = Curves.easeInOut;
                                    var tween = Tween(begin: begin, end: end)
                                        .chain(CurveTween(curve: curve));
                                    return SlideTransition(
                                      position: animation.drive(tween),
                                      child: child,
                                    );
                                  },
                                ),
                              );
                            },
                            child: RichText(
                              text: TextSpan(
                                text: 'Sudah punya akun? ',
                                style: TextStyle(color: Colors.grey.shade700),
                                children: <TextSpan>[
                                  TextSpan(
                                    text: 'Login di sini',
                                    style: TextStyle(
                                      color: theme.primaryColorDark,
                                      fontWeight: FontWeight.bold,
                                      decoration: TextDecoration.underline,
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
