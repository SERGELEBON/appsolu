import 'package:flutter/material.dart';
import 'package:mobile_wallet/app/pages/login/resetpassord/otp_reset.dart';
import 'package:mobile_wallet/core/services/conn_service.dart';
import 'package:connectivity_plus/connectivity_plus.dart'; // Ajout pour vérifier la connexion Internet

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  _ForgotPasswordPageState createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final TextEditingController _phoneController = TextEditingController(text: '+225');
  bool _isLoading = false;

  // Fonction pour vérifier la connexion Internet
  Future<bool> _isConnectedToInternet() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    return connectivityResult != ConnectivityResult.none;
  }

  @override
  Widget build(BuildContext context) {
    final loginService = LoginService();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0x0A434740),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        elevation: 0,
      ),
      backgroundColor: const Color(0x0A434740),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(30.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Inscrivez votre contact maintenant et vous recevrez un code pour réinitialiser votre mot de passe !',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16, color: Colors.white),
              ),
              const SizedBox(height: 70),
              Container(
                decoration: BoxDecoration(
                  color: const Color(0xFF1A1F31),
                  borderRadius: BorderRadius.circular(60),
                ),
                child: TextField(
                  controller: _phoneController,
                  decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.phone, color: Colors.white),
                    labelText: 'Numéro de téléphone',
                    hintText: 'Entrez votre numéro de téléphone',
                    labelStyle: const TextStyle(color: Colors.white),
                    hintStyle: const TextStyle(color: Colors.white70),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(50.0),
                      borderSide: const BorderSide(color: Colors.white),
                    ),
                  ),
                  style: const TextStyle(color: Colors.white),
                  keyboardType: TextInputType.phone,
                ),
              ),
              const SizedBox(height: 70),
              _isLoading
                  ? const CircularProgressIndicator(
                color: Colors.red,
              )
                  :ElevatedButton(
                onPressed: () async {
                  if (_phoneController.text.length == 14) {
                    setState(() {
                      _isLoading = true; // Activer le chargement
                    });

                    // Vérifier la connexion Internet
                    if (!await _isConnectedToInternet()) {
                      setState(() {
                        _isLoading = false; // Désactiver le chargement
                      });
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: const Text("Erreur de connexion"),
                          content: const Text("Vous n'êtes pas connecté à Internet."),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context),
                              child: const Text("OK"),
                            ),
                          ],
                        ),
                      );
                      return; // Ne pas continuer si pas de connexion
                    }

                    try {
                      await loginService.sendOTP(context, _phoneController.text);

                      // Simule un délai pour illustrer le chargement
                      await Future.delayed(Duration(seconds: 10));

                      // Navigation vers la page suivante uniquement s'il n'y a pas d'erreur
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => ForgotPasswordPage()), // Remplacez par votre page suivante
                      ).then((_) {
                        // Désactiver le chargement après retour à cette page si nécessaire
                        setState(() {
                          _isLoading = false;
                        });
                      });
                    } catch (e) {
                      setState(() {
                        _isLoading = false; // Désactiver le chargement en cas d'erreur
                      });
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: const Text("Erreur"),
                          content: Text("Une erreur s'est produite: $e"),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context),
                              child: const Text("OK"),
                            ),
                          ],
                        ),
                      );
                    }
                  } else {
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: const Text("Numéro incorrect"),
                        content: const Text(" Votre numéro de téléphone n'est pas correct. Veuillez saisir un numéro valide."),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: const Text("OK"),
                          ),
                        ],
                      ),
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
                  padding: EdgeInsets.symmetric(horizontal: 50.0, vertical: 12.0),
                  child: Text(
                    'Suivant',
                    style: TextStyle(fontSize: 20, color: Colors.white),
                  ),
                ),
              )

          ],
          ),
        ),
      ),
    );
  }
}
