import 'package:flutter/material.dart';

import '../../widgets/navbar/custom_bottom_navbar.dart';

class SendingMoneyPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Recharge'),
      ),
      body: Center(
        child: Text('Bienvenue sur la page de transfert'),
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
