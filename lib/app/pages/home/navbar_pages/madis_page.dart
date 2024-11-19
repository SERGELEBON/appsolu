import 'package:flutter/material.dart';

class MadisPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Madis'),
        backgroundColor: Color(0xFF1A1F31),
      ),
      body: Center(
        child: Text(
          'Page Madis',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}
