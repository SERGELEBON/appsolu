import 'package:flutter/material.dart';
import 'dart:async'; // For Future.delayed

class RechargementEnCoursPage extends StatefulWidget {
  @override
  _RechargementEnCoursPageState createState() => _RechargementEnCoursPageState();
}

class _RechargementEnCoursPageState extends State<RechargementEnCoursPage> {
  bool _isLoading = true;
  String _transactionID = "123457833555533";
  String _amount = "100.000 FCFA";
  String _fees = "1.000 FCFA";
  String _totalAmount = "101.000 FCFA";

  @override
  void initState() {
    super.initState();

    // Simulate the loading process, and after 5 seconds show the validation icon
    Future.delayed(Duration(seconds: 5), () {
      setState(() {
        _isLoading = false;
      });
    });

    // Update transaction details dynamically after 3 seconds
    Future.delayed(Duration(seconds: 3), () {
      setState(() {
        _transactionID = "987654321012345";
        _amount = "150.000 FCFA";
        _fees = "2.000 FCFA";
        _totalAmount = "152.000 FCFA";
      });
    });

    // Redirect to loading_completed.dart after 6 seconds
    Future.delayed(Duration(seconds: 6), () {
      Navigator.pushReplacementNamed(context, '/loading_completed');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF141724), // Dark background color
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 20),
            // Logo
            Center(
              child: Image.asset(
                'assets/logo.png', // Your logo path
                height: 50,
              ),
            ),
            SizedBox(height: 20),
            // Title
            RichText(
              textAlign: TextAlign.center,
              text: TextSpan(
                text: 'Rechargement ',
                style: TextStyle(
                  fontSize: 24,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
                children: <TextSpan>[
                  TextSpan(
                    text: 'en cours !',
                    style: TextStyle(color: Colors.redAccent),
                  ),
                ],
              ),
            ),
            SizedBox(height: 30),
            // Show loading indicator or success icon based on _isLoading state
            Center(
              child: _isLoading
                  ? CircularProgressIndicator(
                color: Colors.white54,
                strokeWidth: 5,
              )
                  : Icon(
                Icons.check_circle,
                color: Colors.greenAccent,
                size: 50, // Height and width 50
              ),
            ),
            SizedBox(height: 30),
            // Transaction Summary
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Container(
                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Color(0xFF1E2028),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Résumé',
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      'Ci-dessous, le récapitulatif de votre transaction en cours !',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.white54,
                      ),
                    ),
                    SizedBox(height: 20),
                    _buildTransactionDetail('ID TRANSACTION', _transactionID),
                    _buildTransactionDetail('MONTANT', _amount),
                    _buildTransactionDetail('FRAIS', _fees),
                    _buildTransactionDetail('MONTANT GLOBAL', _totalAmount),
                  ],
                ),
              ),
            ),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  // Helper method for building transaction details
  Widget _buildTransactionDetail(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: TextStyle(
              color: Colors.white54,
              fontSize: 16,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
