
import 'package:flutter/material.dart';
import 'package:mobile_wallet/library/common_widgets/app_logo.dart';
import 'package:mobile_wallet/library/common_widgets/buttons.dart';

import '../../library/common_widgets/app_text_styles.dart';

class LandingPage extends StatelessWidget {
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
                  // App logo
                  AppLogo(),
                  const SizedBox(height: 5),
                  // Splash image
                  Image.asset(
                    'assets/images/splash.png', // Assurez-vous que le chemin de l'image est correct
                    height: 200, // Ajustez la hauteur selon vos besoins
                  ),
                  const SizedBox(height: 5),
                  // Welcome text
                  const Text(
                    'Bienvenue !',
                    style: AppTextStyles.welcomeTextStyle,
                  ),
                  const SizedBox(height: 10),
                  // Description text
                  const Text(
                    'Gérez parfaitement vos finances avec l\'application mobile Madis Finance',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.black, // Définit la couleur du texte en noir
                      fontSize: 16.0, // Vous pouvez ajuster la taille du texte si nécessaire
                      fontWeight: FontWeight.normal, // Vous pouvez ajuster le poids du texte si nécessaire
                    ),
                  ),
                  const SizedBox(height: 20),
                  // Inscription button
                  PrimaryButton(
                    text: 'Inscription',
                    onPressed: () {
                      Navigator.of(context).pushNamed('/sign_up/phone_input');
                    },
                  ),
                  const SizedBox(height: 15),
                  // Connexion button
                  PrimaryButton(
                    text: 'Connexion',
                    onPressed: () {
                      Navigator.pushNamed(context, '/login/login_page');
                    },
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
