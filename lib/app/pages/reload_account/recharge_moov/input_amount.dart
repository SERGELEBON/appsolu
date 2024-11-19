import 'package:flutter/material.dart';
import 'package:mobile_wallet/app/pages/reload_account/reload_page.dart';
import '../../../widgets/navbar/custom_bottom_navbar.dart';
import '../otp_reload.dart';

class InputAmount extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: const Color(0xFF141724), // Background color
      appBar: AppBar(
        backgroundColor: const Color(0xFF141724), // Match the background color
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.grey),
          onPressed: () {
            Navigator.of(context).pop(); // Go back action
          },
        ),
        title: Center(
          child: Image.asset(
            'assets/images/madis_finance.png', // Your logo image
            height: 60,
          ),
        ),
        actions: [SizedBox(width: 48)], // Empty space to balance the leading button
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            children: [
              const SizedBox(height: 20),
              const Text(
                'Rechargement',
                style: TextStyle(
                    color: Color(0xFFEB3349),
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                'Remplissez le formulaire afin d\'effectuer votre rechargement via un compte Moov Money !',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFF1D1F33), // Card background color
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  children: [
                    Stack(
                      alignment: Alignment.center,
                      children: [
                        CircleAvatar(
                          radius: 60,
                          backgroundColor:  Color(0xFFEB6608),
                        ),
                        Container(
                            height: 128,
                            width: 108,
                            decoration : const BoxDecoration(
                              image: DecorationImage(image: AssetImage( 'assets/moovfinal.jpeg'),),
                              shape: BoxShape.circle,
                              color: Color(0xFF6600),)
                        ),
                        // Edit button
                        Positioned(
                          bottom: 10,
                          right: 5,
                          child: GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => ReloadPage()),
                              ); // Action to change the payment method
                            },
                            child: Container(
                              padding: const EdgeInsets.all(6),
                              decoration: BoxDecoration(
                                color: Colors.red,
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(Icons.edit,
                                  color: Colors.white, size: 16),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Moov Money',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: const [
                        Icon(Icons.info, color: Colors.red, size: 16),
                        SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            'Cliquez sur le crayon afin de changer le moyen de rechargement !',
                            style: TextStyle(
                              color: Colors.grey,
                              fontSize: 12,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      decoration: InputDecoration(
                        labelText: 'Montant',
                        labelStyle: const TextStyle(color: Colors.grey),
                        prefixText: 'FCFA',
                        prefixStyle: const TextStyle(color: Colors.grey),
                        filled: true,
                        fillColor: const Color(0xFF292B3A),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                      ),
                      style: const TextStyle(color: Colors.white),
                      keyboardType: TextInputType.number,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 30),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => OtpReloadgePage()),
                  ); // Action when pressing next
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  backgroundColor: Colors.red, // Button background color
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: const Center(
                  child: Text(
                    'Suivant',
                    style: TextStyle(color: Colors.white, fontSize: 18),
                  ),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
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
}
