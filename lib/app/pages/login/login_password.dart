import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:mobile_wallet/core/services/conn_service.dart';
import 'package:mobile_wallet/core/services/firestore/firestore_service.dart';
import 'package:mobile_wallet/library/common_widgets/snack_bar.dart';
import 'package:shared_preferences/shared_preferences.dart';

//import 'package:provider/provider.dart';
//import '../../../library/common_widgets/app_logo.dart';

class LoginPasswordPage extends StatefulWidget {
  const LoginPasswordPage({
    super.key,
  });

  @override
  _LoginPasswordPageState createState() => _LoginPasswordPageState();
}

class _LoginPasswordPageState extends State<LoginPasswordPage> {
  final TextEditingController _passwordController = TextEditingController();
  String _selfieImageUrl = '';
  String _userName = '';
  String userPhone = "";
  String idNumber = '';
  String _password = "";
  int attemptsLeft = 5;

  // Ajout de variables pour gérer l'état de chargement
  bool _isLoadingSelfie = true;
  bool _isLoadingUserName = true;
  bool _isLoadingConnection = false;

  @override
  void initState() {
    super.initState();
    _loadUserIdFromPreferences();
    _loadUserProfile();
  }

  Future<void> _loadUserIdFromPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    final savedIdNumber = prefs.getString('idNumber');

    if (savedIdNumber != null) {
      setState(() {
        idNumber = savedIdNumber;
      });
      _loadUserProfile();
    }
  }

  Future<void> _loadUserProfile() async {
    final userService = UserService();
    final userId = idNumber;

    try {
      final userProfile = await userService.getUserProfile(userId);
      setState(() {
        _userName = userProfile['userName'] ?? '';
        _password = userProfile['password'] ?? '';
        userPhone = userProfile['userPhoneNumber'] ?? '';
        _selfieImageUrl = userProfile['selfieImageUrl'] ?? '';
        _isLoadingSelfie = false;
        _isLoadingUserName = false;
      });
    } catch (e) {
      setState(() {
        _isLoadingSelfie = false;
        _isLoadingUserName = false;
      });

      showCustomFailedSnackBar(
          // ignore: use_build_context_synchronously
          context: context,
          content: 'Erreur lors du chargement du profil: $e');
    }
  }

  void checkPassword(String inputPassword) {
    if (attemptsLeft > 0) {
      // Mot de passe correct, procédez à la suite
      if (isPasswordCorrect(inputPassword)) {
        setState(() {
          attemptsLeft = 5;
        });
      } else {
        attemptsLeft--;

        // Affichage d'une notification
        //avec le nombre de tentatives restantes
        if (attemptsLeft == 3) {
          showCustomFailedSnackBar(
            context: context,
            content: 'Tentatives restantes : $attemptsLeft',
          );
        }

        // Mot de passe incorrect, afficher un message d'erreur
        if (!isPasswordCorrect(inputPassword)) {
          showCustomFailedSnackBar(
            context: context,
            content: 'Mot de passe incorrect veuillez réessayer',
          );
        }
      }
    } else {
      // Affichage du message
      // et redirection vers
      // à la page de réinitialisation du mot de passe
      _showLockoutMessage();

      //reinitialisation de la valeur
      setState(() {
        attemptsLeft = 5;
      });
    }
  }

  bool isPasswordCorrect(String inputPassword) {
    //vérification du mot de passe
    return _password == inputPassword;
  }

  void _showLockoutMessage() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Tentatives épuisée"),
        content: const Text(
          "Nous allons procéder à la réinitialisation de votre mot de passe",
          textAlign: TextAlign.center,
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pushNamed(context, '/login/forgot_password_page');
            },
            child: const Text("OK"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final loginService = LoginService();
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

    print('screenHeight, $screenHeight');

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
                'Bienvenu(e) !',
                style: TextStyle(fontSize: 24, color: Colors.white),
              ),
              const SizedBox(height: 20),
              _buildProfileSection(),
              const SizedBox(height: 16),
              _buildPasswordTextField(),
              const SizedBox(height: 8),
              _isLoadingConnection
                  ? const CircularProgressIndicator(
                      color: Colors.red,
                    )
                  : Container(
                      width: screenWidth * 0.85,
                      //espacement
                      margin: const EdgeInsets.symmetric(vertical: 16.0),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 30.0, vertical: 5.0),
                      child: ElevatedButton(
                        style: ButtonStyle(
                          backgroundColor:
                              WidgetStateProperty.resolveWith<Color>(
                            (Set<WidgetState> states) {
                              return Colors.red;
                            },
                          ),
                          shape:
                              WidgetStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(100.0),
                              side: const BorderSide(color: Colors.red),
                            ),
                          ),
                        ),
                        onPressed: () async {
                          setState(() {
                            _isLoadingConnection = true;
                          });

                          try {
                            final password = _passwordController.text.trim();

                            checkPassword(_passwordController.text.trim());

                            await loginService.loginWithPhoneNumberAndPassword(
                              context,
                              userPhone,
                              password,
                            );
                          } catch (e) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                  content: Text('Erreur de connexion: $e')),
                            );
                          } finally {
                            setState(() {
                              _isLoadingConnection = false;
                            });
                          }
                        },
                        child: const Text(
                          'Connexion',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
              const SizedBox(height: 8),
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
              TextButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/login/login_page');
                },
                child: const Text(
                  'Connectez-vous à un autre compte',
                  style: TextStyle(color: Colors.blue),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProfileSection() {
    return Column(
      children: [
        _isLoadingSelfie
            ? const CircularProgressIndicator()
            : CircleAvatar(
                radius: 45,
                backgroundImage: _selfieImageUrl.isNotEmpty
                    ? NetworkImage(_selfieImageUrl) as ImageProvider
                    : const AssetImage('assets/images/profile_pic.png'),
                child: Align(
                  alignment: Alignment.bottomRight,
                  child: GestureDetector(
                    onTap: () {
                      // Navigate to profile edit page
                    },
                    // child: const Icon(Icons.person, color: Colors.white, size: 48.0),
                  ),
                ),
              ),
        const SizedBox(height: 10),
        _isLoadingUserName
            ? const CircularProgressIndicator()
            : Text(
                _userName,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                ),
              ),
      ],
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
          borderRadius: BorderRadius.circular(50.0),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.blue),
          borderRadius: BorderRadius.circular(50.0),
        ),
      ),
    );
  }
}
