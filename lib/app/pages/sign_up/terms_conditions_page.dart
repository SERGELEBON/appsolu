import 'package:flutter/material.dart';

class TermsConditionsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Conditions d\'utilisation'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Text(
            'Les conditions d\'utilisation détaillées ici...',
            style: TextStyle(fontSize: 16.0),
          ),
        ),
      ),
    );
  }
}
