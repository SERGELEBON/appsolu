import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mobile_wallet/core/services/firestore/firestore_service.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../core/services/conn_service.dart'; // Remplacez par le bon chemin vers votre service

class ResetPasswordPage extends StatefulWidget {
  const ResetPasswordPage({super.key});

  @override
  _ResetPasswordPageState createState() => _ResetPasswordPageState();
}

class _ResetPasswordPageState extends State<ResetPasswordPage> {
  // final User? userNumber = FirebaseAuth.instance.currentUser;

  final TextEditingController _codeOtpController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _repeatPasswordController =
      TextEditingController();

  String userPhoneNumber = "";

  @override
  void initState() {
    super.initState();
    updateUserPhoneNumber();
  }

  Future<void> updateUserPhoneNumber() async {
    // Mettre à jour le numéro de téléphone utilisateur
    /* final userService = UserService();
    userService.getUserProfile(idNumber); */
    final prefs = await SharedPreferences.getInstance();
    final phoneNumber = prefs.getString('phoneNumber');

    if (phoneNumber != null) {
      setState(() {
        userPhoneNumber = phoneNumber;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final loginService = LoginService();

    return Scaffold(
      backgroundColor: const Color(0x0A434740),
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text('Mot de passe oublié',
            style: TextStyle(color: Colors.white)),
        backgroundColor: const Color(0x0A434740),
        elevation: 40,
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Container(
            padding: const EdgeInsets.all(20.0),
            width: double.infinity,
            constraints: const BoxConstraints(
              maxWidth: 400.0, // Form width constraint to center it
            ),
            decoration: BoxDecoration(
              color: const Color(0xFF1A1F31),
              borderRadius: BorderRadius.circular(10.0),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(height: 16.0),
                TextField(
                  controller: _newPasswordController,
                  decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.lock, color: Colors.white),
                    labelText: 'Entrez le nouveau mot de passe',
                    labelStyle: const TextStyle(color: Colors.white),
                    fillColor: const Color(0xFF141724),
                    filled: true,
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(50.0),
                      borderSide: const BorderSide(color: Colors.white),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(50.0),
                      borderSide: const BorderSide(color: Colors.white),
                    ),
                  ),
                  obscureText: true,
                  style: const TextStyle(color: Colors.white),
                ),
                const SizedBox(height: 16.0),
                TextField(
                  controller: _repeatPasswordController,
                  decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.lock, color: Colors.white),
                    labelText: 'Répéter le nouveau mot de passe',
                    labelStyle: const TextStyle(color: Colors.white),
                    fillColor: const Color(0xFF141724),
                    filled: true,
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(50.0),
                      borderSide: const BorderSide(color: Colors.white),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(50.0),
                      borderSide: const BorderSide(color: Colors.white),
                    ),
                  ),
                  obscureText: true,
                  style: const TextStyle(color: Colors.white),
                ),
                const SizedBox(height: 50.0),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () async {
                      if (_newPasswordController.text ==
                          _repeatPasswordController.text) {
                        // Appel de la fonction de réinitialisation du mot de passe
                        loginService.resetPassword(
                          context: context,
                          newPassword: _repeatPasswordController.text,
                          phoneNumber: userPhoneNumber,
                        );
                      } else {
                        // Afficher une erreur si les mots de passe ne correspondent pas
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content: Text(
                                  'Les mots de passe ne correspondent pas.')),
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red.shade600,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(50),
                      ),
                    ),
                    child: const Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: 50.0, vertical: 12.0),
                      child: Text(
                        'Valider',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
