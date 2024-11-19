import 'package:flutter/material.dart';

import '../../../widgets/navbar/custom_bottom_navbar.dart';

class FAQPage extends StatelessWidget {
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
              'FAQ',
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
                Icons.question_answer,
                size: 40,
                color: Colors.white,
              ),
            ),
            SizedBox(height: 20),
            Text(
              'Obtenez des réponses à certaines questions concernant Madis Finance',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.grey,
                fontSize: 16,
              ),
            ),
            SizedBox(height: 20),
            _buildFAQExpandableSection('À propos de Madis Finance',
                'Si vous avez une question, une réclamation, ou que vous souhaitez en savoir plus sur nos services et produits, n’hésitez pas à consulter cette FAQ. Nous avons rassemblé ici les questions les plus fréquemment posées et leurs réponses pour vous aider.'),
            _buildFAQQuestion('Quels sont les avantages ?'),
            _buildFAQQuestion('Comment puis-je mettre à jour mes informations de paiement ?'),
            _buildFAQQuestion('Quelles sont les options de paiement acceptées ?'),
            _buildFAQQuestion('Comment protégez-vous mes informations personnelles ?'),
            _buildFAQQuestion('Que faire en cas de soupçon d’activité frauduleuse sur mon compte ?'),
            _buildFAQQuestion('Comment gérez-vous les retours et les échanges ?'),
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

  Widget _buildFAQExpandableSection(String title, String content) {
    return ExpansionTile(
      title: Text(
        title,
        style: TextStyle(
          color: Colors.white,
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      ),
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            content,
            style: TextStyle(color: Colors.grey, fontSize: 14),
          ),
        ),
      ],
    );
  }

  Widget _buildFAQQuestion(String question) {
    return ExpansionTile(
      title: Text(
        question,
        style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
      ),
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.',
            style: TextStyle(color: Colors.grey, fontSize: 14),
          ),
        ),
      ],
    );
  }
}
