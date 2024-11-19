import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:mobile_wallet/core/services/conn_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OtpResetPage extends StatefulWidget {
  const OtpResetPage({super.key});

  @override
  _OtpResetPageState createState() => _OtpResetPageState();
}

class _OtpResetPageState extends State<OtpResetPage> {
  final TextEditingController _codeController = TextEditingController();
  bool isLoading = false;
  String? savedVerificationID;

  @override
  void initState() {
    super.initState();
    _loadVerification();
  }

  Future<void> _loadVerification() async {
    final prefs = await SharedPreferences.getInstance();
    savedVerificationID = prefs.getString('verificationID');

    if (kDebugMode) {
      print('savedVerificationID $savedVerificationID');
    }
  }

  @override
  Widget build(BuildContext context) {
    final loginService = LoginService();

    return Scaffold(
      backgroundColor: const Color(0xFF41724),
      appBar: AppBar(
        backgroundColor: const Color(0x0A434740),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(30.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset('assets/images/madis_finance.png', height: 150),
                  const SizedBox(height: 40),
                  const Text(
                    'Gérez parfaitement vos finances - Inscrivez-vous maintenant à notre plateforme Madis finance !',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 16, color: Colors.white),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: List.generate(6, (index) {
                      return _buildCodeBox(index);
                    }),
                  ),
                  const SizedBox(height: 30),
                  ElevatedButton(
                    onPressed: isLoading
                        ? null
                        : () async {
                      setState(() {
                        isLoading = true; // Commence le chargement
                      });

                      try {
                        await loginService.verifyOTP(
                            _codeController.text, context);
                      } catch (e) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Erreur : ${e.toString()}'),
                          ),
                        );
                      } finally {
                        setState(() {
                          isLoading = false; // Arrête le chargement
                        });
                      }
                    },
                    style:
                    ElevatedButton.styleFrom(backgroundColor: Colors.red),
                    child: const Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: 40.0, vertical: 12.0),
                      child: Text(
                        'Vérifier le code',
                        style: TextStyle(fontSize: 20, color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (isLoading)
            const Center(
              child: CircularProgressIndicator(),
            ),
        ],
      ),
    );
  }

  Widget _buildCodeBox(int index) {
    return LayoutBuilder(
      builder: (context, constraints) {
        double boxWidth = 45;
        double boxHeight = 60;

        return Container(
          width: boxWidth,
          height: boxHeight,
          decoration: BoxDecoration(
            color: const Color(0xFF1A1F31),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Center(
            child: TextField(
              textAlign: TextAlign.center,
              maxLength: 1,
              keyboardType: TextInputType.number,
              style: const TextStyle(color: Colors.white, fontSize: 25),
              decoration: const InputDecoration(
                border: InputBorder.none,
                counterText: '',
              ),
              onChanged: (value) {
                if (value.isNotEmpty && index < 5) {
                  FocusScope.of(context).nextFocus();
                } else if (value.isEmpty && index > 0) {
                  FocusScope.of(context).previousFocus();
                }
                if (_codeController.text.length <= index) {
                  _codeController.text = _codeController.text + value;
                } else {
                  _codeController.text =
                      _codeController.text.substring(0, index) +
                          value +
                          _codeController.text.substring(index + 1);
                }
              },
            ),
          ),
        );
      },
    );
  }
}
