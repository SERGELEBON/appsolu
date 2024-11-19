import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mobile_wallet/core/services/firestore/firestore_service.dart';
import 'package:mobile_wallet/library/common_widgets/snack_bar.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../core/services/conn_service.dart'; // Remplacez par le bon chemin vers votre service

class Modifypasswordpage extends StatefulWidget {
  const Modifypasswordpage({super.key});

  @override
  _ModifypasswordpageState createState() => _ModifypasswordpageState();
}

class _ModifypasswordpageState extends State<Modifypasswordpage> {
  final loginService = LoginService();
  final userService = UserService();

  final TextEditingController _oldPasswordController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _repeatPasswordController =
      TextEditingController();

  String userId = '';
  String idNumber = '';
  String userPhoneNumber = "";

  @override
  void initState() {
    super.initState();
    _loadUserIdFromPreferences();
  }

  Future<void> _loadUserIdFromPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    final idNumber = prefs.getString('idNumber');

    if (idNumber != null) {
      setState(() {
        userId = idNumber;
      });
      updateUserPhoneNumber();
    }
  }

  Future<void> updateUserPhoneNumber() async {
    // Mettre à jour le numéro de téléphone utilisateur
    final userProfile = await userService.getUserProfile(userId);

    setState(() {
      userPhoneNumber = userProfile['userPhoneNumber'] ?? '';
      debugPrint('Phone number: $userPhoneNumber');
    });

    if (userPhoneNumber == '') {
      // Si le numéro de téléphone n'est pas disponible, vous pouvez afficher un message d'erreur
      debugPrint('Phone number not found');
      // return;
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: const Color(0x0A434740),
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        centerTitle: true,
        title: const Text('Modification de mot de passe',
            style: TextStyle(color: Colors.white, fontSize: 20)),
        backgroundColor: const Color(0x0A434740),
        elevation: 40,
      ),
      body: Center(
        child: Container(
          //width: screenWidth * 0.9,
          height: screenHeight * 0.4,
          margin: const EdgeInsets.all(20),
          padding: const EdgeInsets.symmetric(horizontal: 20),

          // width: double.infinity,
          decoration: BoxDecoration(
            color: const Color(0xFF1A1F31),
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              TextField(
                controller: _oldPasswordController,
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.lock, color: Colors.white),
                  labelText: 'Entrez l\'ancien mot de passe',
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
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () async {
                    if (_newPasswordController.text ==
                        _repeatPasswordController.text) {
                      // Appel de la fonction de réinitialisation du mot de passe
                      loginService.modifyPassword(
                        context: context,
                        phoneNumber: userPhoneNumber,
                        oldPassword: _oldPasswordController.text,
                        newPassword: _repeatPasswordController.text,
                      );
                    } else {
                      // Afficher une erreur si les mots de passe ne correspondent pas
                      showCustomFailedSnackBar(
                        context: context,
                        content: 'Les mots de passe ne correspondent pas.',
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
                    padding: EdgeInsets.symmetric(vertical: 15),
                    child: Text(
                      'Modifier',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
