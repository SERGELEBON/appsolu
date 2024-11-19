import 'package:flutter/material.dart';
import 'package:mobile_wallet/app/pages/reload_account/recharge_moov/pdf_file.dart';
import 'package:pdf/pdf.dart';

import '../../../widgets/navbar/custom_bottom_navbar.dart';

class LoadingCompleted extends StatelessWidget {
  const LoadingCompleted({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1A1F31), // Background color
      appBar: AppBar(
        backgroundColor: const Color(0xFF1A1F31),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            // Implement back navigation
          },
        ),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 20),
              Image.asset(
                'assets/images/madis_finance.png', // Replace with your logo asset
                height: 60,
              ),
              const SizedBox(height: 20),
              const Text(
                'Rechargement effectué !',
                style: TextStyle(
                  color: Colors.red,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 30),
              const Icon(
                Icons.check_circle,
                color: Colors.green,
                size: 80,
              ),
              const SizedBox(height: 30),
              const Text(
                'Résumé',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                'Ci-dessous, le récapitulatif de votre transaction en cours !',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFF2A2F44),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    TransactionDetailRow(
                      label: 'ID TRANSACTION',
                      value: '1234578333555533',
                    ),
                    SizedBox(height: 10),
                    TransactionDetailRow(
                      label: 'MONTANT',
                      value: '100.000 FCFA',
                    ),
                    SizedBox(height: 10),
                    TransactionDetailRow(
                      label: 'FRAIS',
                      value: '1.000 FCFA',
                    ),
                    SizedBox(height: 10),
                    TransactionDetailRow(
                      label: 'MONTANT GLOBAL',
                      value: '101.000 FCFA',
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 30),
              ElevatedButton.icon(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => TransactionDetailsPage(),
                    ),
                  ); // Implement receipt viewing
                },
                icon: const Icon(Icons.receipt),
                label: const Text('Voir le reçu',
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFEB3349), // Button color
                  padding: const EdgeInsets.symmetric(
                    vertical: 14.0,
                    horizontal: 20.0,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
              const SizedBox(height: 40),
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

class TransactionDetailRow extends StatelessWidget {
  final String label;
  final String value;

  const TransactionDetailRow({
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: Colors.grey,
            fontSize: 16,
          ),
        ),
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
          ),
        ),
      ],
    );
  }
}
