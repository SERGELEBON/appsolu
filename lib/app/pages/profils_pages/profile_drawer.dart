/* 
import 'package:mobile_wallet/app/pages/login/login_password.dart';
import '../../../library/common_widgets/app_logo.dart'; 
*/
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:mobile_wallet/app/pages/profils_pages/privacy_policy/privacy_policy_page.dart';
import 'package:mobile_wallet/app/pages/profils_pages/rapport/support_page.dart';
import 'package:mobile_wallet/core/services/firestore/firestore_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../library/common_widgets/app_logo.dart';
import '../home/home_page.dart';
import '../login/login_page.dart';
import '../sign_up/register_form.dart';
import '../sign_up/welcome_page.dart';
import 'faq_page/faq_page.dart';
import 'info_personel/personal_info_page.dart';

class ProfileDrawer extends StatefulWidget {
  const ProfileDrawer({super.key});

  @override
  State<ProfileDrawer> createState() => _ProfileDrawerState();
}

class _ProfileDrawerState extends State<ProfileDrawer> {
  String idNumber = '';
  String _userName = '';
  String userPhoneNumber = '';
  String _selfieImageUrl = '';

  @override
  void initState() {
    super.initState();
    _loadUserIdFromPreferences();
    _loadUserProfile();
  }

  Future<void> _loadUserIdFromPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    final savedIdNumber = prefs.getString('idNumber');

    if (savedIdNumber != null) {
      setState(() {
        idNumber = savedIdNumber;
      });
      _loadUserProfile();
    }
  }

  Future<void> _loadUserProfile() async {
    final userService = UserService();

    final userId = idNumber;
    if (kDebugMode) {
      print('userId on drawer page is: $userId');
    }

    final userProfile = await userService.getUserProfile(userId);

    setState(() {
      _userName = userProfile['userName'] ?? '';
      _selfieImageUrl = userProfile['selfieImageUrl'] ?? '';
      userPhoneNumber = userProfile['userPhoneNumber'] ?? '';

      if (kDebugMode) {
        print('USERNAME on drawer page is: $_userName');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

    return Drawer(
      child: Container(
        color: const Color(0xFF0A434740),
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            SingleChildScrollView(
              child: DrawerHeader(
                decoration: const BoxDecoration(
                  color: Color(0xFF1A1F31),
                ),
                child: Column(
                  children: [
                    CircleAvatar(
                      radius: 40,
                      backgroundImage:
                          const AssetImage('assets/images/profile_pic.png'),
                      child: Align(
                        alignment: Alignment.bottomRight,
                        child: GestureDetector(
                          onTap: () {
                            // Navigate to profile edit page
                          },
                          child: _selfieImageUrl.isNotEmpty
                              ? CircleAvatar(
                                  radius: 50,
                                  backgroundImage:
                                      NetworkImage(_selfieImageUrl),
                                )
                              : const Icon(Icons.person,
                                  color: Colors.white, size: 48.0),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    SingleChildScrollView(
                      child: Column(
                        children: [
                          Text(
                            _userName,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Text(
                      userPhoneNumber,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.home, color: Colors.black54),
              title:
                  const Text('Accueil', style: TextStyle(color: Colors.black)),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => HomePage(
                            idNumber: '',
                          )),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.person, color: Colors.black54),
              title: const Text('Informations personnelles',
                  style: TextStyle(color: Colors.black)),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const PersonalInfoPage()),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.account_box, color: Colors.black54),
              title: const Text('Informations du compte',
                  style: TextStyle(color: Colors.black)),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const RegisterForm()),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.work, color: Colors.black54),
              title: const Text('Espace pro',
                  style: TextStyle(color: Colors.black)),
              onTap: () {},
            ),
            ListTile(
              leading: const Icon(Icons.bar_chart, color: Colors.black54),
              title: const Text('Espace bourse',
                  style: TextStyle(color: Colors.black)),
              onTap: () {
                // Navigate to stock space page
              },
            ),
            ListTile(
              leading: const Icon(Icons.savings, color: Colors.black54),
              title: const Text('Espace Epargne +',
                  style: TextStyle(color: Colors.black)),
              onTap: () {
                // Navigate to savings space page
              },
            ),
            ListTile(
              leading: const Icon(Icons.account_balance_wallet,
                  color: Colors.black54),
              title:
                  const Text('Budget', style: TextStyle(color: Colors.black)),
              onTap: () {
                // Navigate to budget page
              },
            ),
            ListTile(
              leading: const Icon(Icons.credit_card, color: Colors.black54),
              title: const Text('Acheter du crédit',
                  style: TextStyle(color: Colors.black)),
              onTap: () {
                // Navigate to credit purchase page
              },
            ),
            ListTile(
              leading: const Icon(Icons.group_add, color: Colors.black54),
              title: const Text('Créer une cagnotte',
                  style: TextStyle(color: Colors.black)),
              onTap: () {
                // Navigate to create a kitty page
              },
            ),
            ListTile(
              leading: const Icon(Icons.question_answer, color: Colors.black54),
              title: const Text('FAQ', style: TextStyle(color: Colors.black)),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => FAQPage()),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.lock, color: Colors.black54),
              title: const Text('Politique de confidentialité',
                  style: TextStyle(color: Colors.black)),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => PrivacyPolicyPage()),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.contact_support, color: Colors.black54),
              title:
                  const Text('Support', style: TextStyle(color: Colors.black)),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SupportPage()),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.exit_to_app, color: Colors.black54),
              title: const Text('Déconnexion',
                  style: TextStyle(color: Colors.black)),
              onTap: () {
                _logout(context);
              },
            ),
            const SizedBox(height: 20),
            Center(child: AppLogo()),
          ],
        ),
      ),
    );
  }

  void _logout(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.clear();

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => LoginPage()),
    );
  }
}
