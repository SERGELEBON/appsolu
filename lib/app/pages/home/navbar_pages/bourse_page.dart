import 'package:flutter/material.dart';

class BoursePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('La bourse'),
        backgroundColor: Color(0xFF1A1F31),
      ),
      body: Center(
        child: Text(
          'Page La bourse',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}
