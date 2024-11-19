import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mobile_wallet/core/services/conn_service.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _phoneController =
      TextEditingController(text: '+225');
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;
  // Ajout de la variable pour gérer les tentatives restantes
  int _attemptsLeft = 5;
  int _attempts = 0;

  @override
  void initState() {
    super.initState();
    _phoneController.addListener(_onPhoneNumberChanged);
  }

  @override
  void dispose() {
    _phoneController.removeListener(_onPhoneNumberChanged);
    _phoneController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _onPhoneNumberChanged() {
    if (!_phoneController.text.startsWith('+225')) {
      _phoneController.text = '+225';
      _phoneController.selection = TextSelection.fromPosition(
        TextPosition(offset: _phoneController.text.length),
      );
    }
  }

  void _checkPassword(String phoneNumber, String password) async {
    if (_attemptsLeft > 0) {
      setState(() {
        _isLoading = true;
      });

      final loginService = LoginService();
      bool isSuccessful = await loginService.loginWithPhoneNumberAndPassword(
          context, phoneNumber, password);

      setState(() {
        _isLoading = false;
      });

      if (!isSuccessful) {
        setState(() {
          _attemptsLeft--;
          if (_attemptsLeft == 0) {
            _showLockoutMessage();

            setState(() {
              _attemptsLeft = 5;
            });
            // Vous pouvez désactiver le bouton ou afficher un message de blocage
          }
        });
      } else {
        // Réinitialisez les tentatives si la connexion réussit
        setState(() {
          _attemptsLeft = 5;
        });
      }
    }
  }

  void _showLockoutMessage() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Tentatives épuisées"),
        content: const Text(
          "Nous allons procéder à la réinitialisation de votre mot de passe",
        ),
        actions: [
          TextButton(
              onPressed: () {
                Navigator.pushNamed(context, '/login/forgot_password_page');
              },
              child: const Row(
                children: [Text("reinitialiser"), Icon(Icons.lock_open)],
              )),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: const Color(0x0A434740),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(25.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset('assets/images/madis_finance.png', height: 100),
              const SizedBox(height: 20),
              const Text(
                'Connectez-vous !',
                style: TextStyle(fontSize: 24, color: Colors.white),
              ),
              const SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.all(16.0),
                width: double.infinity,
                constraints: const BoxConstraints(
                  maxWidth: 400.0,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFF1A1F31),
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildPhoneTextField(),
                    const SizedBox(height: 20),
                    _buildPasswordTextField(),
                    const SizedBox(height: 8),
                    _isLoading
                        ? const CircularProgressIndicator(color: Colors.red)
                        : Container(
                            //color: Colors.white,
                            width: screenWidth * 0.85,
                            //Bouton taille et longueur et lageur
                            margin: EdgeInsets.symmetric(vertical: 8.0),
                            padding: EdgeInsets.symmetric(
                                horizontal: 30.0, vertical: 5.0),
                            child: ElevatedButton(
                              style: ButtonStyle(
                                backgroundColor:
                                    WidgetStateProperty.resolveWith<Color>(
                                  (Set<WidgetState> states) {
                                    return Colors.red;
                                  },
                                ),
                                shape: WidgetStateProperty.all<
                                    RoundedRectangleBorder>(
                                  //Bonton de connexion
                                  RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(100.0),
                                    side: const BorderSide(color: Colors.red),
                                  ),
                                ),
                              ),
                              onPressed: _attemptsLeft > 0
                                  ? () {
                                      final phoneNumber =
                                          _phoneController.text.trim();
                                      final password =
                                          _passwordController.text.trim();
                                      _checkPassword(phoneNumber, password);
                                    }
                                  : null, // Désactiver le bouton si les tentatives sont épuisées
                              child: const Text(
                                'Connexion',
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ),
                    const SizedBox(height: 8),
                    if (_attemptsLeft <= 3 || _attemptsLeft == 0)
                      Text(
                        'Tentatives restantes :  $_attemptsLeft',
                        style: const TextStyle(color: Colors.red),
                      ),
                  ],
                ),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/login/forgot_password_page');
                },
                child: const Text(
                  'Mot de passe oublié ?',
                  style: TextStyle(color: Colors.blue),
                ),
              ),
              const SizedBox(height: 8),
              const Center(
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    "Vous n'avez pas de compte Madis finance ?",
                    style: TextStyle(color: Colors.white),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/sign_up/phone_input');
                },
                child: const Text(
                  'Inscrivez-vous',
                  style: TextStyle(color: Colors.blue),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPhoneTextField() {
    return TextField(
      controller: _phoneController,
      keyboardType: TextInputType.phone,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        labelText: 'Numéro de téléphone',
        labelStyle: const TextStyle(color: Colors.white54),
        prefixIcon: const Icon(Icons.phone, color: Colors.white54),
        fillColor: const Color(0xFF141724),
        filled: true,
        enabledBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.white54),
          borderRadius: BorderRadius.circular(100.0),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.blue),
          borderRadius: BorderRadius.circular(10.0),
        ),
      ),
    );
  }

  Widget _buildPasswordTextField() {
    return TextField(
      controller: _passwordController,
      obscureText: true,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        labelText: 'Entrez votre mot de passe',
        labelStyle: const TextStyle(color: Colors.white54),
        prefixIcon: const Icon(Icons.lock, color: Colors.white54),
        fillColor: const Color(0xFF141724),
        filled: true,
        enabledBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.white54),
          borderRadius: BorderRadius.circular(100.0),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.blue),
          borderRadius: BorderRadius.circular(10.0),
        ),
      ),
    );
  }
}
