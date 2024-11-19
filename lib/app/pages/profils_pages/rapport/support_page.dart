import 'package:flutter/material.dart';

import '../../../widgets/navbar/custom_bottom_navbar.dart';

class SupportPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF0A0E21),
      appBar: AppBar(
        backgroundColor: Color(0xFF0A0E21),
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        centerTitle: true,
        title: Column(
          children: [
            Image.asset(
              'assets/images/logo.png', // Remplacer par le chemin correct de votre logo
              height: 40,
            ),
            SizedBox(height: 5),
            Text(
              'Support',
              style: TextStyle(
                color: Colors.red,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            SizedBox(height: 20),
            CircleAvatar(
              radius: 40,
              backgroundColor: Colors.blueGrey,
              child: Icon(
                Icons.headset_mic,
                size: 40,
                color: Colors.white,
              ),
            ),
            SizedBox(height: 20),
            Text(
              'Nous sommes ouverts à résoudre les problèmes que vous rencontré',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.grey,
                fontSize: 16,
              ),
            ),
            SizedBox(height: 20),
            _buildSupportOptionEmail(),
            _buildSupportOptionCall(),
            _buildSupportOptionClaims(),
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

  Widget _buildSupportOptionEmail() {
    return ExpansionTile(
      title: Text(
        'Assistance par E-mail',
        style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
      ),
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              TextField(
                decoration: InputDecoration(
                  hintText: 'Nom et Prénom(s)',
                  hintStyle: TextStyle(color: Colors.grey),
                  prefixIcon: Icon(Icons.person, color: Colors.grey),
                  filled: true,
                  fillColor: Color(0xFF1A1F31),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                    borderSide: BorderSide.none,
                  ),
                ),
                style: TextStyle(color: Colors.white),
              ),
              SizedBox(height: 10),
              TextField(
                decoration: InputDecoration(
                  hintText: 'E-mail',
                  hintStyle: TextStyle(color: Colors.grey),
                  prefixIcon: Icon(Icons.email, color: Colors.grey),
                  filled: true,
                  fillColor: Color(0xFF1A1F31),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                    borderSide: BorderSide.none,
                  ),
                ),
                style: TextStyle(color: Colors.white),
              ),
              SizedBox(height: 10),
              TextField(
                maxLines: 4,
                decoration: InputDecoration(
                  hintText: 'Message',
                  hintStyle: TextStyle(color: Colors.grey),
                  filled: true,
                  fillColor: Color(0xFF1A1F31),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                    borderSide: BorderSide.none,
                  ),
                ),
                style: TextStyle(color: Colors.white),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  // Handle submit
                },
                child: Text('Envoyer', style: TextStyle(color: Colors.white)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSupportOptionCall() {
    return ExpansionTile(
      title: Text(
        'Assistance par appel',
        style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
      ),
      children: [
        _buildCallOption('Service Madis Finance', '+225 07 79 48 94 09'),
        _buildCallOption('Service Madis Invest', '+225 07 79 48 94 10'),
        _buildCallOption('Service Madis Group', '+225 07 79 48 94 11'),
      ],
    );
  }

  Widget _buildCallOption(String serviceName, String phoneNumber) {
    return ListTile(
      title: Text(
        serviceName,
        style: TextStyle(color: Colors.white, fontSize: 16),
      ),
      subtitle: Text(
        phoneNumber,
        style: TextStyle(color: Colors.grey),
      ),
      trailing: ElevatedButton(
        onPressed: () {
          // Handle call
        },
        child: Text('Appeler', style: TextStyle(color: Colors.white)),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.red,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
      ),
    );
  }

  Widget _buildSupportOptionClaims() {
    return ExpansionTile(
      title: Text(
        'Liste des réclamations',
        style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
      ),
      children: [
        _buildClaimItem('Réclamation 0001', 'Je n\'arrive pas à me connecter à mon compte. Pouvez-vous m\'aider à réinitialiser mon mot de passe ?', Icons.check_circle, 'Résolu'),
        _buildClaimItem('Réclamation 0002', 'Je reçois constamment des messages d\'erreur lorsque j\'essaie de sauvegarder mes modifications.', Icons.access_time, 'En cours'),
        _buildClaimItem('Réclamation 0003', 'Mon paiement n\'a pas été accepté, mais mon compte a été débité. Que faire ?', Icons.access_time, 'En cours'),
      ],
    );
  }

  Widget _buildClaimItem(String title, String description, IconData statusIcon, String statusText) {
    return ListTile(
      leading: Icon(Icons.headset_mic, color: Colors.white),
      title: Text(
        title,
        style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
      ),
      subtitle: Text(
        description,
        style: TextStyle(color: Colors.grey, fontSize: 14),
      ),
      trailing: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(statusIcon, color: statusText == 'Résolu' ? Colors.green : Colors.grey),
          SizedBox(height: 5),
          Text(
            statusText,
            style: TextStyle(color: Colors.grey, fontSize: 12),
          ),
        ],
      ),
      isThreeLine: true,
    );
  }
}
