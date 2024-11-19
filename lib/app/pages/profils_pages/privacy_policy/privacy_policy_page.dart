import 'package:flutter/material.dart';

import '../../../widgets/navbar/custom_bottom_navbar.dart';

class PrivacyPolicyPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Politique de Confidentialité'),
        backgroundColor: Color(0xFFFFFFFF),
      ),
      backgroundColor: Color(0xFF1A1F31),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Image.asset('assets/images/logo.png', height: 100),
            ),
            SizedBox(height: 20),
            Text(
              'Politique de Confidentialité',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 20),
            _buildSectionTitle('Introduction'),
            _buildSectionContent(
              'Qorem ipsum dolor sit amet, consectetur adipiscing elit. Etiam eu turpis '
                  'molestie, dictum est a, mattis tellus. Sed dignissim, metus nec fringilla '
                  'accumsan, risus sem sollicitudin lacus, ut interdum tellus elit sed risus. '
                  'Maecenas eget condimentum velit, sit amet feugiat lectus. Class aptent taciti '
                  'sociosqu ad litora torquent per conubia nostra, per inceptos himenaeos. '
                  'Praesent auctor purus luctus enim.',
            ),
            SizedBox(height: 20),
            _buildSectionTitle('Comment ces informations sont-elles collectées?'),
            _buildSectionContent(
              'Qorem ipsum dolor sit amet, consectetur adipiscing elit. Etiam eu turpis '
                  'molestie, dictum est a, mattis tellus. Sed dignissim, metus nec fringilla '
                  'accumsan, risus sem sollicitudin lacus, ut interdum tellus elit sed risus. '
                  'Maecenas eget condimentum velit, sit amet feugiat lectus. Class aptent taciti '
                  'sociosqu ad litora torquent per conubia nostra, per inceptos himenaeos. '
                  'Praesent auctor purus luctus enim.',
            ),
            SizedBox(height: 20),
            _buildSectionTitle('Utilisez-vous des cookies ou des technologies similaires?'),
            _buildSectionContent(
              'Qorem ipsum dolor sit amet, consectetur adipiscing elit. Etiam eu turpis '
                  'molestie, dictum est a, mattis tellus. Sed dignissim, metus nec fringilla '
                  'accumsan, risus sem sollicitudin lacus, ut interdum tellus elit sed risus. '
                  'Maecenas eget condimentum velit, sit amet feugiat lectus. Class aptent taciti '
                  'sociosqu ad litora torquent per conubia nostra, per inceptos himenaeos. '
                  'Praesent auctor purus luctus enim.',
            ),
            SizedBox(height: 20),
            _buildSectionTitle('Collecte de l\'information'),
            _buildSectionContent(
              'Qorem ipsum dolor sit amet, consectetur adipiscing elit. Etiam eu turpis '
                  'molestie, dictum est a, mattis tellus. Sed dignissim, metus nec fringilla '
                  'accumsan, risus sem sollicitudin lacus, ut interdum tellus elit sed risus. '
                  'Maecenas eget condimentum velit, sit amet feugiat lectus. Class aptent taciti '
                  'sociosqu ad litora torquent per conubia nostra, per inceptos himenaeos. '
                  'Praesent auctor purus luctus enim.',
            ),
            SizedBox(height: 20),
            _buildSectionTitle('Utilisation de l\'information'),
            _buildSectionContent(
              'Qorem ipsum dolor sit amet, consectetur adipiscing elit. Etiam eu turpis '
                  'molestie, dictum est a, mattis tellus. Sed dignissim, metus nec fringilla '
                  'accumsan, risus sem sollicitudin lacus, ut interdum tellus elit sed risus. '
                  'Maecenas eget condimentum velit, sit amet feugiat lectus. Class aptent taciti '
                  'sociosqu ad litora torquent per conubia nostra, per inceptos himenaeos. '
                  'Praesent auctor purus luctus enim.',
            ),
            SizedBox(height: 20),
            _buildSectionTitle('politique de Confidentialité'),
            _buildSectionContent(
              'Qorem ipsum dolor sit amet, consectetur adipiscing elit. Etiam eu turpis '
                  'molestie, dictum est a, mattis tellus. Sed dignissim, metus nec fringilla '
                  'accumsan, risus sem sollicitudin lacus, ut interdum tellus elit sed risus. '
                  'Maecenas eget condimentum velit, sit amet feugiat lectus. Class aptent taciti '
                  'sociosqu ad litora torquent per conubia nostra, per inceptos himenaeos. '
                  'Praesent auctor purus luctus enim.',
            ),
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

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: TextStyle(
        color: Colors.white,
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget _buildSectionContent(String content) {
    return Text(
      content,
      style: TextStyle(
        color: Colors.grey,
        fontSize: 16,
        height: 1.5,
      ),
    );
  }
}
