import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mobile_wallet/app/pages/home/home_page.dart';
import 'package:mobile_wallet/app/pages/profils_pages/profile_drawer.dart';
import 'package:mobile_wallet/core/services/firestore/user_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:mobile_wallet/core/services/firestore/firestore_service.dart';

import '../../../widgets/navbar/custom_bottom_navbar.dart';

class PersonalInfoPage extends StatefulWidget {
  const PersonalInfoPage({super.key});

  @override
  _PersonalInfoPageState createState() => _PersonalInfoPageState();
}

class _PersonalInfoPageState extends State<PersonalInfoPage> {
  final _formKey = GlobalKey<FormState>();
  final userService = UserService();

  // URL de l'image téléchargée depuis la BD ou le chemin local du selfie
  String _selfieImageUrl = '';
  // Chemin local du fichier selfie, s'il est pris
  String _selfieFilePath = '';
  String _lastName = '';
  String _firstName = '';
  String userPhone = "";
  String idNumber = '';

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _surnameController = TextEditingController();

  final ImagePicker _picker = ImagePicker();
  int _selectedIndex = 0;

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

    final userProfile = await userService.getUserProfile(userId);

    setState(() {
      _lastName = userProfile['lastName'] ?? '';
      _firstName = userProfile['firstName'] ?? '';
      userPhone = userProfile['userPhoneNumber'] ?? '';
      _selfieImageUrl = userProfile['selfieImageUrl'] ?? '';
    });
  }

  Future<void> _takeSelfie() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.camera);
    if (pickedFile != null) {
      setState(() {
        _selfieFilePath =
            pickedFile.path; // Enregistrez le chemin du fichier local
      });
    }
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF141724),
      appBar: AppBar(
        backgroundColor: const Color(0xFF141724),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                builder: (context) => const ProfileDrawer(),
              ),
            );
          },
        ),
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 25.0),
          child: Column(
            children: [
              Image.asset('assets/images/madis_finance.png', height: 100),
              const SizedBox(height: 20),
              const Text(
                'Informations personnelles',
                style: TextStyle(fontSize: 20, color: Colors.white),
              ),
              const SizedBox(height: 20),
              Stack(
                children: [
                  CircleAvatar(
                    radius: 60,
                    backgroundImage: _selfieFilePath.isNotEmpty
                        ? FileImage(File(_selfieFilePath))
                        : (_selfieImageUrl.isNotEmpty
                                ? NetworkImage(_selfieImageUrl)
                                : const AssetImage(
                                    'assets/images/profile_pic.png'))
                            as ImageProvider,
                  ),
                ],
              ),
              const SizedBox(height: 20),
              _buildEditableField(
                _nameController,
                _lastName,
                TextInputType.text,
              ),
              const SizedBox(height: 20),
              _buildEditableField(
                //label: "Téléphone",
                _surnameController,
                _firstName,
                TextInputType.text,
              ),
              const SizedBox(height: 20),
              _buildEditableField(
                _phoneController,
                userPhone,
                TextInputType.phone,
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/login/modify_password_page');
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red.shade600,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Padding(
                    padding: EdgeInsets.symmetric(vertical: 15.0),
                    child: Text(
                      'Modifier mon mot de passe',
                      style: TextStyle(
                        color: Color.fromARGB(255, 255, 255, 255),
                        // fontSize: 10,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
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

  Widget _buildEditableField(
    TextEditingController controller,
    String label,
    TextInputType keyboardType,
  ) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF1A1F31), // Couleur de fond du champ de texte
        borderRadius: BorderRadius.circular(10),
      ),
      child: IgnorePointer(
        // Rendre tout son contenu non interactif
        child: TextField(
          readOnly: true, // Champ de texte non modifiable
          controller: controller,
          keyboardType: keyboardType,
          style: const TextStyle(color: Colors.white), // Couleur du texte
          decoration: InputDecoration(
            labelText: label,
            labelStyle: const TextStyle(
              color: Colors.white,
              fontSize: 15,
            ),
            fillColor: const Color(0xFF1A1F31),
            filled: true,
            enabledBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: Colors.transparent),
              borderRadius: BorderRadius.circular(10),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: Colors.transparent),
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ),
      ),
    );
  }
}
