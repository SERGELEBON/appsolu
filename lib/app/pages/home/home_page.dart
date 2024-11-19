import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../core/services/firestore/firestore_service.dart';
import '../../widgets/navbar/custom_bottom_navbar.dart';
import '../profils_pages/profile_drawer.dart';
import 'mes_pages_home/balance_card.dart';
import 'mes_pages_home/madistore_section.dart';
import 'mes_pages_home/market_news_section.dart';
import 'mes_pages_home/patrimoine_section.dart';
import 'mes_pages_home/promo_section.dart';
import 'mes_pages_home/recent_activities.dart';

class HomePage extends StatefulWidget {
  String idNumber;

  HomePage({super.key, required this.idNumber});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with WidgetsBindingObserver {
  String _selfieImageUrl = '';
  String _userName = '';
  Timer? _pauseTimer;

  @override
  void initState() {
    super.initState();
    _loadUserProfile();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.paused:
        debugPrint('application en pause');
        _startPauseTimer();
        break;

      case AppLifecycleState.detached:
        debugPrint('application detachée');
        _startPauseTimer();
        break;

      case AppLifecycleState.hidden:
        debugPrint('application masquée');
        _startPauseTimer();
        break;

      case AppLifecycleState.resumed:
        debugPrint('application reprise');

        // Annulation du timer si l'application reprend
        _pauseTimer?.cancel();
        break;

      case AppLifecycleState.inactive:
        // Réinitialisation du timer si l'application est inactive
        _pauseTimer?.cancel();
        break;

      default:
    }
  }

  void _startPauseTimer() {
    // Réinitialisation du timer avant de démarrer un nouveau
    _pauseTimer?.cancel();

    // Fermer l'application après 15 secondes d'inactivité
    _pauseTimer = Timer(const Duration(seconds: 15), () {
      _closeApp();
    });
  }

  // Fermerture de l'application
  void _closeApp() {
    SystemNavigator.pop();
  }

  Future<void> _loadUserProfile() async {
    final prefs = await SharedPreferences.getInstance();
    final savedIdNumber = prefs.getString('idNumber') ?? widget.idNumber;

    if (savedIdNumber.isNotEmpty) {
      final userService = UserService();
      final userProfile = await userService.getUserProfile(savedIdNumber);

      setState(() {
        _selfieImageUrl = userProfile['selfieImageUrl'] ?? '';
        _userName = userProfile['userName'] ?? '';
      });

      if (kDebugMode) {
        print('User ID: $savedIdNumber');
        print('User Name: $_userName');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: const Color(0xFF0A434740),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const ProfileDrawer(),
                              ),
                            );
                          },
                          child: _selfieImageUrl.isNotEmpty
                              ? CircleAvatar(
                                  backgroundImage:
                                      NetworkImage(_selfieImageUrl),
                                  radius: 24.0,
                                )
                              : const Icon(Icons.person,
                                  color: Colors.white, size: 48.0),
                        ),
                        const SizedBox(width: 8.0),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Bienvenu (e),',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16.0,
                              ),
                            ),
                            Text(
                              _userName,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 16.0,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    IconButton(
                      icon: Stack(
                        children: [
                          const Icon(Icons.notifications, color: Colors.white),
                          Positioned(
                            right: 0,
                            child: Container(
                              padding: const EdgeInsets.all(1),
                              decoration: BoxDecoration(
                                color: Colors.red,
                                borderRadius: BorderRadius.circular(6),
                              ),
                              constraints: const BoxConstraints(
                                minWidth: 12,
                                minHeight: 12,
                              ),
                              child: const Text(
                                '4',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 8,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                        ],
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const NotificationsPage(),
                          ),
                        );
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                BalanceCard(),
                const SizedBox(height: 20),
                RecentActivities(),
                const SizedBox(height: 20),
                SectionPatrimoine(),
                const SizedBox(height: 20),
                MadistoreSection(),
                const SizedBox(height: 20),
                MarketNewsSection(),
                const SizedBox(height: 20),
                PromoSection(),
              ],
            ),
          ),
        ),
        bottomNavigationBar: CustomBottomNavBar(
          currentIndex: 2,
          onTap: (index) {
            // Gérer la navigation en fonction de l'index
          },
        ),
      ),
    );
  }
}

class NotificationsPage extends StatelessWidget {
  const NotificationsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifications'),
      ),
      body: ListView(
        children: const [
          ListTile(
            title: Text('Notification 1'),
            subtitle: Text('Détails de la notification 1...'),
          ),
          ListTile(
            title: Text('Notification 2'),
            subtitle: Text('Détails de la notification 2...'),
          ),
          ListTile(
            title: Text('Notification 3'),
            subtitle: Text('Détails de la notification 3...'),
          ),
          ListTile(
            title: Text('Notification 4'),
            subtitle: Text('Détails de la notification 4...'),
          ),
        ],
      ),
    );
  }
}
