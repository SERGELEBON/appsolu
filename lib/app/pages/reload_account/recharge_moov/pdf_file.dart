import 'package:flutter/material.dart';
import 'package:pdf/widgets.dart' as pdfWidgets;
import 'package:printing/printing.dart';

import '../../../widgets/navbar/custom_bottom_navbar.dart';

class TransactionDetailsPage extends StatelessWidget {
  final transactionDetails = {
    "transactionId": "1234567890201456",
    "amount": "100.0000 FCFA",
    "fees": "1000 FCFA",
    "totalAmount": "101.000 FCFA",
    "beneficiaryName": "john Doe",
    "beneficiaryPhone": "07 06 05 04 03",
    "receivedAmount": "100.000 FCFA",
    "sender": "MADIS FINANCE",
    "dateTime": "14 avr. 2024 / 12:30"
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF141724),
        title: Text("Détails transaction"),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Image.asset(
              'assets/madis_finance.png', // Assuming you have a logo
              height: 50,
            ),
            Container(
              margin: EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16.0),
              ),
              padding: EdgeInsets.all(16.0),
              child: Column(
                children: [
                  _buildHeader(),
                  Divider(),
                  _buildTransactionDetails(),
                  Divider(),
                  _buildSenderDetails(),
                ],
              ),
            ),
            _buildButtons(context),
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

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.asset(
              'assets/logo.png', // Assuming you have a logo
              height: 50,
            ),
          ],
        ),
        Text(
          "Reçu",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18.0,
          ),
        ),
      ],
    );
  }

  Widget _buildTransactionDetails() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildDetailRow("Id transaction", transactionDetails['transactionId']!),
        _buildDetailRow("Montant", transactionDetails['amount']!),
        _buildDetailRow("Frais", transactionDetails['fees']!),
        SizedBox(height: 8.0),
        _buildTotalRow("Montant global", transactionDetails['totalAmount']!, true),
        SizedBox(height: 16.0),
        Row(
          children: [
            Icon(Icons.person),
            SizedBox(width: 8.0),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(transactionDetails['beneficiaryName']!),
                Text(transactionDetails['beneficiaryPhone']!),
              ],
            ),
          ],
        ),
        SizedBox(height: 8.0),
        _buildTotalRow("Montant reçu", transactionDetails['receivedAmount']!, false),
      ],
    );
  }

  Widget _buildSenderDetails() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildDetailRow("Expéditeur", transactionDetails['sender']!),
        _buildDetailRow("Date & heure", transactionDetails['dateTime']!),
      ],
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label),
          Text(value, style: TextStyle(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Widget _buildTotalRow(String label, String value, bool isHighlighted) {
    return Container(
      color: isHighlighted ? Colors.grey[200] : Colors.transparent,
      padding: EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(fontWeight: FontWeight.bold)),
          Text(value, style: TextStyle(fontWeight: FontWeight.bold, color: Colors.red)),
        ],
      ),
    );
  }

  Widget _buildButtons(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          ElevatedButton.icon(
            onPressed: () => _generatePdf(context),
            icon: Icon(Icons.download),
            label: Text("Télécharger"),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
            ),
          ),
          ElevatedButton.icon(
            onPressed: () {},
            icon: Icon(Icons.share),
            label: Text("Partager"),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _generatePdf(BuildContext context) async {
    final pdf = pdfWidgets.Document();

    pdf.addPage(
      pdfWidgets.Page(
        build: (context) {
          return pdfWidgets.Column(
            crossAxisAlignment: pdfWidgets.CrossAxisAlignment.start,
            children: [
              pdfWidgets.Text("Reçu", style: pdfWidgets.TextStyle(fontSize: 24)),
              pdfWidgets.SizedBox(height: 20),
              pdfWidgets.Text("Transaction ID: ${transactionDetails['transactionId']}"),
              pdfWidgets.Text("Montant: ${transactionDetails['amount']}"),
              pdfWidgets.Text("Frais: ${transactionDetails['fees']}"),
              pdfWidgets.SizedBox(height: 10),
              pdfWidgets.Text("Montant global: ${transactionDetails['totalAmount']}"),
              pdfWidgets.Text("Bénéficiaire: ${transactionDetails['beneficiaryName']}"),
              pdfWidgets.Text("Montant reçu: ${transactionDetails['receivedAmount']}"),
              pdfWidgets.Text("Expéditeur: ${transactionDetails['sender']}"),
              pdfWidgets.Text("Date & heure: ${transactionDetails['dateTime']}"),
            ],
          );
        },
      ),
    );

    await Printing.layoutPdf(onLayout: (format) async => pdf.save());
  }
}
