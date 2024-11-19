import 'package:flutter/material.dart';
import 'package:mobile_wallet/library/common_widgets/app_logo.dart';
import 'package:mobile_wallet/library/common_widgets/app_text_styles.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:mobile_wallet/app/pages/landing_page.dart';
import 'package:mobile_wallet/app/pages/login/login_password.dart';

class WrapperPage extends StatefulWidget {
  const WrapperPage({super.key});

  @override
  State<WrapperPage> createState() => _WrapperPageState();
}

class _WrapperPageState extends State<WrapperPage> {
  String? savedIdNumber;

  @override
  void initState() {
    super.initState();
    _checkAppStatusOnStart();
  }

  Future<void> _checkAppStatusOnStart() async {
    final prefs = await SharedPreferences.getInstance();
    savedIdNumber = prefs.getString('idNumber');

    // Ajout d'un délai pour afficher le splash screen avant de naviguer
    await Future.delayed(const Duration(milliseconds: 600));

    // Vérifiez si l'utilisateur est déjà inscrit et connecté
    if (savedIdNumber != null && savedIdNumber!.isNotEmpty) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => LoginPasswordPage()),
      );
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => LandingPage()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background image
          Container(
            width: MediaQuery.of(context).size.width * 1.0,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/fond2.png'), // Image de fond
                fit: BoxFit.cover,
              ),
            ),
          ),
          Center(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    'assets/images/madis_finance.png', // Assurez-vous que le chemin de l'image est correct
                    height: 400, // Ajustez la hauteur selon vos besoins
                  ),
                  const SizedBox(height: 5),
                  // Welcome text
                  const Text(
                    'Bienvenue !',
                    style: AppTextStyles.welcomeTextStyle,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
