import 'package:flutter/material.dart';

class TransactionListWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Activité récente', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
        SizedBox(height: 10),
        ListView.builder(
          shrinkWrap: true,
          itemCount: 3,
          itemBuilder: (context, index) {
            return ListTile(
              contentPadding: EdgeInsets.zero,
              title: Text('Shopping mensuel', style: TextStyle(color: Colors.white)),
              subtitle: Text('23 Septembre 2023', style: TextStyle(color: Colors.white54)),
              trailing: Text('-1,209,000', style: TextStyle(color: Colors.red)),
            );
          },
        ),
        TextButton(
          onPressed: () {
            // View all transactions code
          },
          child: Text('Voir plus', style: TextStyle(color: Colors.blue)),
        ),
      ],
    );
  }
}
