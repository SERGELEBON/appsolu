import 'package:flutter/material.dart';
import 'package:mobile_wallet/app/pages/reload_account/reload_page.dart';
import 'package:mobile_wallet/app/pages/sending_account/sending_money_page.dart';

class BalanceCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Color(0xFF1A1F31),
        borderRadius: BorderRadius.circular(16.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 20.0),
          Container(
            padding: EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: Color(0xFF2A2E43),
              borderRadius: BorderRadius.circular(16.0),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Align(
                  alignment: Alignment.centerRight,
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: Text(
                      'Solde total',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12.0,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 8.0),
                Center(
                  child: Text(
                    '359.000 FCFA',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 32.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                SizedBox(height: 20.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Column(
                      children: [
                        Icon(Icons.send, color: Colors.white, size: 32.0),
                        SizedBox(height: 4.0),
                        Center(
                          child: GestureDetector(
                            onTap: () {
                              // Quand on clique sur 'Recharge', on est redirigé vers la page de recharge
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => SendingMoneyPage()),
                              );
                            },
                            child: Text(
                              'Envoi',
                              style: TextStyle(
                                color: Colors.white70,
                                fontSize: 14.0,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Column(
                      children: [
                        Icon(Icons.add, color: Colors.white, size: 32.0),
                        SizedBox(height: 4.0),
                        Center( child: GestureDetector(
                          onTap: () {
                            // Quand on clique sur 'Recharge', on est redirigé vers la page de recharge
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => ReloadPage()),
                            );
                          },
                          child: Text(
                            'Recharge',
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 14.0,
                            ),
                          ),
                        ),
                        ),
                      ],
                    ),
                    Column(
                      children: [
                        Icon(Icons.more_horiz, color: Colors.white, size: 32.0),
                        SizedBox(height: 4.0),
                        Text(
                          'Plus',
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: 14.0,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
