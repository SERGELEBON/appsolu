import 'package:flutter/material.dart';

class PromoSection extends StatelessWidget {
  final List<PromoItem> promoItems = [
    PromoItem(
      title: 'Black Friday',
      discount: '-30%',
      buttonText: 'Profiter',
      route: PromoDetailPage(title: 'Black Friday'),
    ),
    PromoItem(
      title: 'Offres du jour',
      discount: '-10%',
      buttonText: 'Profiter',
      route: PromoDetailPage(title: 'Offres du jour'),
    ),
    PromoItem(
      title: 'Nouvelle Année',
      discount: '-20%',
      buttonText: 'Profiter',
      route: PromoDetailPage(title: 'Nouvelle Année'),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Promo et remise',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 10.0),
        SizedBox(
          height: 150.0,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: promoItems.length,
            itemBuilder: (context, index) {
              final promoItem = promoItems[index];
              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => promoItem.route),
                  );
                },
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.6,
                  margin: EdgeInsets.all(5.0),
                  decoration: BoxDecoration(
                    color: Colors.grey[900],
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(10.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          promoItem.title,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          promoItem.discount,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 24.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Align(
                          alignment: Alignment.bottomRight,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              foregroundColor: Colors.black, backgroundColor: Colors.white,
                            ),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => promoItem.route,
                                ),
                              );
                            },
                            child: Text(promoItem.buttonText),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

class PromoItem {
  final String title;
  final String discount;
  final String buttonText;
  final Widget route;

  PromoItem({required this.title, required this.discount, required this.buttonText, required this.route});
}

class PromoDetailPage extends StatelessWidget {
  final String title;

  PromoDetailPage({required this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: Center(
        child: Text('Détails de $title'),
      ),
    );
  }
}
