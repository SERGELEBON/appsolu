import 'package:flutter/material.dart';
import 'package:mobile_wallet/app/pages/reload_account/recharge_moov/loading_completed.dart';
import 'package:mobile_wallet/app/pages/reload_account/recharge_moov/loading_progress.dart';
import '../../widgets/navbar/custom_bottom_navbar.dart';

class OtpReloadgePage extends StatefulWidget {
  @override
  _OtpReloadgePageState createState() => _OtpReloadgePageState();
}

class _OtpReloadgePageState extends State<OtpReloadgePage> {
  final List<TextEditingController> otpControllers = List.generate(6, (index) => TextEditingController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF141724), // Dark background color
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 20),
            // Logo
            Container(
              height: 80,
              width: 80,
              child: Image.asset("assets/madis_finance.png", fit: BoxFit.cover, height: 150),
            ),
            SizedBox(height: 16),
            // Title
            Text(
              'Rechargement',
              style: TextStyle(
                fontSize: 24,
                color: Colors.redAccent,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10),
            // Subtitle
            Text(
              'Entrez le code OTP reçu via votre numéro Orange \nafin de continuer la transaction',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white54),
            ),
            SizedBox(height: 15),
            // OTP Fields
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: List.generate(6, (index) {
                  return Container(
                    width: 40,
                    height: 50,
                    decoration: BoxDecoration(
                      border: Border(bottom: BorderSide(color: Colors.white54, width: 2)),
                    ),
                    child: TextField(
                      controller: otpControllers[index],
                      style: TextStyle(color: Colors.white, fontSize: 24),
                      textAlign: TextAlign.center,
                      keyboardType: TextInputType.number,
                      maxLength: 1,
                      decoration: InputDecoration(
                        counterText: '',
                        border: InputBorder.none,
                      ),
                    ),
                  );
                }),
              ),
            ),
            SizedBox(height: 30),
            // Numeric Keypad
            GridView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 50),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                childAspectRatio: 1.5,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
              ),
              shrinkWrap: true, // Ensures the GridView does not take up unnecessary space
              physics: NeverScrollableScrollPhysics(), // Prevent scrolling in GridView
              itemCount: 12,
              itemBuilder: (context, index) {
                // Numeric keys
                if (index < 9) {
                  return Center(
                    child: TextButton(
                      onPressed: () {
                        _addOtpValue('${index + 1}');
                      },
                      child: Text(
                        '${index + 1}',
                        style: TextStyle(
                          fontSize: 24,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  );
                } else if (index == 9) {
                  // Empty for layout
                  return SizedBox.shrink();
                } else if (index == 10) {
                  return Center(
                    child: TextButton(
                      onPressed: () {
                        _addOtpValue('0');
                      },
                      child: Text(
                        '0',
                        style: TextStyle(
                          fontSize: 24,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  );
                } else {
                  return Center(
                    child: TextButton(
                      onPressed: _deleteOtpValue,
                      child: Icon(Icons.backspace, color: Colors.white),
                    ),
                  );
                }
              },
            ),
            // Confirm Button
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.redAccent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => RechargementEnCoursPage()),
                  );
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  child: Center(
                    child: Text(
                      'Confirmer',
                      style: TextStyle(fontSize: 18, color: Colors.white),
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: 20),
          ],
        ),
      ),
      bottomNavigationBar: CustomBottomNavBar(
        currentIndex: 0,
        onTap: (index) {
          // Gérer la navigation en fonction de l'index
        },
      ),
    );
  }

  // Method to handle OTP input
  void _addOtpValue(String value) {
    for (var controller in otpControllers) {
      if (controller.text.isEmpty) {
        setState(() {
          controller.text = value;
        });
        break;
      }
    }
  }

  // Method to handle OTP deletion
  void _deleteOtpValue() {
    for (int i = otpControllers.length - 1; i >= 0; i--) {
      if (otpControllers[i].text.isNotEmpty) {
        setState(() {
          otpControllers[i].text = '';
        });
        break;
      }
    }
  }
}
