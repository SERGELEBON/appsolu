import 'package:flutter/material.dart';

class CustomWidgets {
  // Fonction pour créer le widget Row avec le texte "Nom"
  static Widget buildLeftAlignedText(String text) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start, // Aligne le contenu à gauche
      children: [
        Text(
          text,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.white, // Vous pouvez changer la couleur si nécessaire
          ),
        ),
      ],
    );
  }
  // Fonction pour créer le widget Row avec le texte aligné à droite
  static Widget buildLeftAlignedText1(String text) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start, // Aligne le contenu à droite
      children: [
        Text(
          text,  style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.bold,
          color: Colors.white, // Vous pouvez changer la couleur si nécessaire
        ),),

      ],
    );
  }
}



