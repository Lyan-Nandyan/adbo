import 'package:adbo/login/loginHrd.dart';
import 'package:adbo/login/loginKaryawan.dart';
import 'package:adbo/login/loginManager.dart';
import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimationLogo;
  late List<Animation<Offset>> _slideAnimationsButtons;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration:
          const Duration(milliseconds: 1200), // Durasi animasi keseluruhan
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeIn,
      ),
    );

    _slideAnimationLogo =
        Tween<Offset>(begin: const Offset(0, -0.5), end: Offset.zero).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.0, 0.5,
            curve: Curves.elasticOut), // Animasi logo lebih dulu dan memantul
      ),
    );

    // Animasi untuk tombol-tombol dengan sedikit delay (staggered)
    _slideAnimationsButtons = List.generate(3, (index) {
      return Tween<Offset>(begin: const Offset(0, 0.5), end: Offset.zero)
          .animate(
        CurvedAnimation(
          parent: _animationController,
          curve: Interval(
            0.3 +
                (index * 0.15), // Mulai setelah logo, dengan delay antar tombol
            0.7 + (index * 0.15), // Selesai dengan delay
            curve: Curves.easeOutCubic,
          ),
        ),
      );
    });

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Widget _buildLoginButton({
    required String title,
    required IconData icon,
    required Color backgroundColor,
    required VoidCallback onPressed,
    required Animation<Offset> slideAnimation,
  }) {
    Theme.of(context);
    return SlideTransition(
      position: slideAnimation,
      child: FadeTransition(
        opacity: _fadeAnimation, // Tombol juga fade in
        child: SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            icon: Icon(icon, size: 20),
            label: Text(title),
            onPressed: onPressed,
            style: ElevatedButton.styleFrom(
              backgroundColor: backgroundColor,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
              textStyle: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                letterSpacing: 0.5,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 5.0,
              shadowColor: backgroundColor.withOpacity(0.4),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context); // Mengambil tema dari context
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor:
          theme.colorScheme.surface, // Warna latar belakang dari tema
      appBar: AppBar(
        title: Text(
          'ADBO Portal System',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: theme.colorScheme.onPrimary, // Warna teks AppBar dari tema
          ),
        ),
        centerTitle: true,
        backgroundColor: theme.primaryColor, // Warna AppBar utama dari tema
        elevation: 4.0, // Sedikit bayangan untuk AppBar
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(16),
          ),
        ),
      ),
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                theme.primaryColor.withOpacity(0.05),
                theme.colorScheme.surface.withOpacity(0.1),
                theme.colorScheme.surface,
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: Center(
            child: SingleChildScrollView(
              padding:
                  const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  SlideTransition(
                    position: _slideAnimationLogo,
                    child: Container(
                      padding: const EdgeInsets.all(25),
                      decoration: BoxDecoration(
                        color: theme.primaryColor.withOpacity(0.15),
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: theme.primaryColor.withOpacity(0.3),
                          width: 2.5,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: theme.primaryColor.withOpacity(0.2),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          )
                        ],
                      ),
                      child: Icon(
                        Icons
                            .business_center_outlined, // Ikon yang lebih relevan
                        size: screenHeight * 0.08, // Ukuran ikon responsif
                        color: theme.primaryColorDark, // Warna ikon lebih gelap
                      ),
                    ),
                  ),
                  SizedBox(height: screenHeight * 0.035),
                  Text(
                    'Selamat Datang di\nPortal Kepegawaian Perusahaan',
                    style: theme.textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: theme
                          .primaryColorDark, // Menggunakan warna primer gelap dari tema
                      height: 1.3,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: screenHeight * 0.01),
                  Text(
                    'Pilih peran Anda untuk melanjutkan',
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: Colors.grey.shade700,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: screenHeight * 0.05),
                  _buildLoginButton(
                    title: 'LOGIN SEBAGAI KARYAWAN',
                    icon: Icons.person_outline_rounded,
                    backgroundColor: theme.colorScheme
                        .secondary, // Menggunakan warna sekunder dari tema
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const LoginKaryawan(),
                        ),
                      );
                    },
                    slideAnimation: _slideAnimationsButtons[0],
                  ),
                  SizedBox(height: screenHeight * 0.02),
                  _buildLoginButton(
                    title: 'LOGIN SEBAGAI HRD',
                    icon: Icons.admin_panel_settings_outlined,
                    backgroundColor:
                        const Color(0xFF10B981), // Warna hijau yang cerah
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const Loginhrd(),
                        ),
                      );
                    },
                    slideAnimation: _slideAnimationsButtons[1],
                  ),
                  SizedBox(height: screenHeight * 0.02),
                  _buildLoginButton(
                    title: 'LOGIN SEBAGAI MANAGER',
                    icon: Icons.supervisor_account_outlined,
                    backgroundColor:
                        const Color(0xFFF59E0B), // Warna kuning/oranye
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const LoginManager(),
                        ),
                      );
                    },
                    slideAnimation: _slideAnimationsButtons[2],
                  ),
                  SizedBox(height: screenHeight * 0.05), // Jarak sebelum footer
                ],
              ),
            ),
          ),
        ),
      ),
      bottomNavigationBar: FadeTransition(
        opacity: _fadeAnimation, // Footer juga fade in
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 15.0),
          decoration: BoxDecoration(
            color: theme.colorScheme.surface,
            border: Border(
              top: BorderSide(color: Colors.grey.shade300, width: 0.5),
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Dibuat oleh Ade Lyan Hariel',
                style: TextStyle(
                  fontSize: 13,
                  color: Colors.grey.shade600,
                  fontStyle: FontStyle.italic,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 3),
              Text(
                '© 2025 ADBO Portal System. All Rights Reserved.',
                style: TextStyle(
                  fontSize: 11,
                  color: Colors.grey.shade500,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
