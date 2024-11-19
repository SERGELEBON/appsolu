import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:mobile_wallet/app/pages/home/home_page.dart';
import 'package:mobile_wallet/library/common_widgets/app_logo.dart';
import 'package:shared_preferences/shared_preferences.dart';

class WelcomePage extends StatefulWidget {
  const WelcomePage({super.key});

  @override
  _WelcomePageState createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    final String user = ModalRoute.of(context)!.settings.arguments as String;
    if (kDebugMode) {
      print('userrrrrrrrrrrrrrrrrrrr $user');
    }

    return Scaffold(
      body: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16.0),
        color: Colors.black,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('assets/images/madis_finance.png', height: 100),
            const SizedBox(height: 20),
            Image.asset('assets/images/economies.png',
                height: 150), // Remplacez par votre image
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: const Color(
                    0xFF1A1F31), // Couleur de fond de la zone de texte
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                children: [
                  const Text(
                    'Bienvenue !',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 50,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'Madis Finance',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'Votre inscription a été enregistrée ! Veuillez vous connecter à votre compte en cliquant sur le bouton ci-dessous.',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 16, color: Colors.white),
                  ),
                  const SizedBox(height: 20),
                  _isLoading
                      ? const CircularProgressIndicator(
                          color: Colors.red,
                        )
                      : ElevatedButton(
                          onPressed: () async {
                            setState(() {
                              _isLoading = true;
                            });
                            final prefs = await SharedPreferences.getInstance();
                            await prefs.setString('idNumber', user);
                            // Naviguer vers la page d'accueil avec l'ID de l'utilisateur
                            Navigator.of(context).pushReplacement(
                              MaterialPageRoute(
                                builder: (context) => HomePage(idNumber: user),
                              ),
                            );
                            setState(() {
                              _isLoading = false;
                            });
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red, // Couleur du bouton
                          ),
                          child: const Padding(
                            padding: EdgeInsets.symmetric(
                                vertical: 16.0, horizontal: 24.0),
                            child: Text(
                              'Commencez',
                              style:
                                  TextStyle(fontSize: 15, color: Colors.white),
                            ),
                          ),
                        ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
