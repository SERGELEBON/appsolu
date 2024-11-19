import 'package:flutter/material.dart';

class BudgetPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Le budget'),
        backgroundColor: Color(0xFF1A1F31),
      ),
      body: Center(
        child: Text(
          'Page Le budget',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}
