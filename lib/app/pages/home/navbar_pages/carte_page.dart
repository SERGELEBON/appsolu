import 'package:flutter/material.dart';

class CartePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('La carte'),
        backgroundColor: Color(0xFF1A1F31),
      ),
      body: Center(
        child: Text(
          'Page La carte',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}
