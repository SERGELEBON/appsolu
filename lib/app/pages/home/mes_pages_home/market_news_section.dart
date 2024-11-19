import 'package:flutter/material.dart';

class MarketNewsSection extends StatelessWidget {
  final List<NewsItem> newsItems = [
    NewsItem(
      title: 'MARCHÉS ÉMERGENTS',
      date: '15-06-2024',
      description: 'Les économies émergentes, particulièrement en Asie et en Afrique...',
      imagePath: 'assets/images/market1.png',
      route: MarketNewsDetailPage(title: 'MARCHÉS ÉMERGENTS'),
    ),
    NewsItem(
      title: 'INTELLIGENCE ET TECHNOLOGIE',
      date: '19-01-2024',
      description: 'Les investisseurs misent sur les technologies de rupture...',
      imagePath: 'assets/images/market2.png',
      route: MarketNewsDetailPage(title: 'INTELLIGENCE ET TECHNOLOGIE'),
    ),
    NewsItem(
      title: 'NOUVELLES RÉGLEMENTATIONS',
      date: '22-03-2024',
      description: 'Les nouvelles régulations du marché financier...',
      imagePath: 'assets/images/market3.png',
      route: MarketNewsDetailPage(title: 'NOUVELLES RÉGLEMENTATIONS'),
    ),
    NewsItem(
      title: 'ANALYSE DU MARCHÉ',
      date: '08-04-2024',
      description: 'Analyse des tendances du marché financier global...',
      imagePath: 'assets/images/market4.png',
      route: MarketNewsDetailPage(title: 'ANALYSE DU MARCHÉ'),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Actualité boursière',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 10.0),
        SizedBox(
          height: 200.0,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: newsItems.length,
            itemBuilder: (context, index) {
              final newsItem = newsItems[index];
              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => newsItem.route),
                  );
                },
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.8,
                  margin: EdgeInsets.all(5.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.0),
                    image: DecorationImage(
                      image: AssetImage(newsItem.imagePath),
                      fit: BoxFit.cover,
                    ),
                  ),
                  child: Stack(
                    children: [
                      Positioned(
                        bottom: 10.0,
                        left: 10.0,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              newsItem.title,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              newsItem.date,
                              style: TextStyle(
                                color: Colors.white70,
                                fontSize: 14.0,
                              ),
                            ),
                            Text(
                              newsItem.description,
                              style: TextStyle(
                                color: Colors.white70,
                                fontSize: 14.0,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
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

class NewsItem {
  final String title;
  final String date;
  final String description;
  final String imagePath;
  final Widget route;

  NewsItem({required this.title, required this.date, required this.description, required this.imagePath, required this.route});
}

class MarketNewsDetailPage extends StatelessWidget {
  final String title;

  MarketNewsDetailPage({required this.title});

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
