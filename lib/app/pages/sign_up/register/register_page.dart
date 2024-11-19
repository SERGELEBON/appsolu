/*import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mobile_wallet/core/services/auth_service.dart';


class RegisterForm extends StatefulWidget {
  const RegisterForm({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _RegisterFormState createState() => _RegisterFormState();
}

class _RegisterFormState extends State<RegisterForm> {
  final _formKey = GlobalKey<FormState>();
  final userAuthService = AuthService();
  final User? userNumber = FirebaseAuth.instance.currentUser;

  int _currentStep = 0;
  bool _isLoading = false; // Ajout de la variable pour l'état de chargement

  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _idNumberController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
  TextEditingController();

  bool _isAccepted = false;
  bool _isMinor = false;

  File? _selfieImageUrl;
  File? _idFront;
  File? _idBack;
  File? _minorDocument;
  File? _birthCertificate;
  File? _identityDocument;
  File? _sodeciImageUrl;

  final ImagePicker _picker = ImagePicker();

  int _selectedDay = 1;
  int _selectedMonth = 1;
  int _selectedYear = DateTime.now().year;
  String _selectedIdType = 'CNI'; // Type de pièce par défaut

  void _calculateAge() {
    final birthDate = DateTime(_selectedYear, _selectedMonth, _selectedDay);
    final today = DateTime.now();
    int age = today.year - birthDate.year;

    if (today.month < birthDate.month ||
        (today.month == birthDate.month && today.day < birthDate.day)) {
      age--;
    }

    setState(() {
      _isMinor = age < 18;
    });
  }

  Future<void> _takeSelfie() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.camera);
    if (pickedFile != null) {
      setState(() {
        _selfieImageUrl = File(pickedFile.path);
      });
    }
  }

  Widget _buildUploadButton(String text, Function(File) onFilePicked,
      {bool disabled = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: ElevatedButton(
        onPressed: disabled
            ? null
            : () async {
          final pickedFile =
          await _picker.pickImage(source: ImageSource.gallery);
          if (pickedFile != null) {
            onFilePicked(File(pickedFile.path));
          }
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: disabled ? Colors.grey : const Color(0xFF1A1F31),
          padding: const EdgeInsets.symmetric(vertical: 15),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
        ),
        child: Row(
          children: [
            const Icon(Icons.cloud_upload, color: Colors.white),
            const SizedBox(width: 10),
            Text(text, style: const TextStyle(color: Colors.white)),
          ],
        ),
      ),
    );
  }

  Future<String> _uploadFileToFirebase(String path, File file) async {
    try {
      final ref = FirebaseStorage.instance.ref().child(path);
      await ref.putFile(file);
      final downloadUrl = await ref.getDownloadURL();
      return downloadUrl;
    } catch (e) {
      throw Exception(
          'Erreur lors du téléversement de fichier : ${e.toString()}');
    }
  }

  Future<void> _submitForm() async {
    setState(() {
      _isLoading = true; // Afficher le chargement
    });

    if (_formKey.currentState!.validate() && _isAccepted) {
      if (_selfieImageUrl == null ||
          _sodeciImageUrl == null ||
          _idFront == null ||
          _idBack == null ||
          (_isMinor &&
              (_minorDocument == null ||
                  _birthCertificate == null ||
                  _identityDocument == null))) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text('Tous les fichiers doivent être téléversés')));
        setState(() {
          _isLoading = false; // Cacher le chargement
        });
        return;
      }

      try {
        final userDocument =
        await FirebaseFirestore.instance.collection('users').add({
          'firstName': _firstNameController.text,
          'lastName': _lastNameController.text,
          'dateOfBirth':
          '${_selectedDay.toString().padLeft(2, '0')}-${_selectedMonth.toString().padLeft(2, '0')}-${_selectedYear}',
          'idType': _selectedIdType,
          'idNumber': _idNumberController.text,
          'password': _passwordController.text,
          'userPhoneNumber': userNumber?.phoneNumber
        });

        final selfieImageUrl = await _uploadFileToFirebase(
            'users/${userDocument.id}/selfie_image.jpg', _selfieImageUrl!);
        final sodeciImageUrl = await _uploadFileToFirebase(
            'users/${userDocument.id}/sodeci_image.jpg', _sodeciImageUrl!);
        final idFrontUrl = await _uploadFileToFirebase(
            'users/${userDocument.id}/id_front.jpg', _idFront!);
        final idBackUrl = await _uploadFileToFirebase(
            'users/${userDocument.id}/id_back.jpg', _idBack!);

        if (_isMinor) {
          final minorDocumentUrl = await _uploadFileToFirebase(
              'users/${userDocument.id}/minor_document.jpg', _minorDocument!);
          final birthCertificateUrl = await _uploadFileToFirebase(
              'users/${userDocument.id}/birth_certificate.jpg',
              _birthCertificate!);
          final identityDocumentUrl = await _uploadFileToFirebase(
              'users/${userDocument.id}/identity_document.jpg',
              _identityDocument!);

          await userDocument.update({
            'selfieImageUrl': selfieImageUrl,
            'sodeciImageUrl': sodeciImageUrl,
            'idFrontUrl': idFrontUrl,
            'idBackUrl': idBackUrl,
            'minorDocumentUrl': minorDocumentUrl,
            'birthCertificateUrl': birthCertificateUrl,
            'identityDocumentUrl': identityDocumentUrl,
          });
        } else {
          await userDocument.update({
            'selfieImageUrl': selfieImageUrl,
            'sodeciImageUrl': sodeciImageUrl,
            'idFrontUrl': idFrontUrl,
            'idBackUrl': idBackUrl,
          });
        }

        Navigator.pushNamed(context, '/sign_up/welcome',
            arguments: _idNumberController.text);

        setState(() {
          _selfieImageUrl = null;
          _sodeciImageUrl = null;
          _idFront = null;
          _idBack = null;
          _minorDocument = null;
          _birthCertificate = null;
          _identityDocument = null;
          _isLoading = false; // Cacher le chargement
        });
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text('Erreur lors de la soumission : ${e.toString()}')));
        setState(() {
          _isLoading = false; // Cacher le chargement
        });
      }
    } else {
      setState(() {
        _isLoading =
        false; // Cacher le chargement si le formulaire n'est pas valide
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Container(
        height: screenHeight,
        width: screenWidth,
        color: const Color(0xFF141724),
        child:  SafeArea(
          child:  Center(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Image.asset('assets/images/madis_finance.png', height: 100),
                  const SizedBox(height: 50),
                  const Text(
                    'Madis Finance',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 20.0),
                  const Text(
                    'Gérez parfaitement vos finances - Inscrivez-vous maintenant à notre plateforme Madis finance !',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 12.0,
                    ),
                  ),
                  const SizedBox(height: 50),
                  Stepper(
                    currentStep: _currentStep,
                    onStepContinue: _currentStep < 1
                        ? () => setState(() => _currentStep += 1)
                        : _submitForm,
                    onStepCancel: _currentStep > 0
                        ? () => setState(() => _currentStep -= 1)
                        : null,
                    controlsBuilder:
                        (BuildContext context, ControlsDetails details) {
                      final isLastStep = _currentStep == 2;

                      return Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          if (_currentStep > 0)
                            ElevatedButton(
                              onPressed: details.onStepCancel,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFFFFFFFF),
                                padding: const EdgeInsets.symmetric(vertical: 15),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                              ),

                              child: Row(
                                children: const [
                                  Icon(Icons.arrow_back, color: Colors.black),
                                  SizedBox(width: 10),
                                  Center(child: Text('Retour', style: TextStyle(color: Colors.black))),
                                ],
                              ),
                            ),
                          if (_currentStep < 1)
                            ElevatedButton(
                              onPressed: details.onStepContinue,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFFFF0000),
                                padding: const EdgeInsets.symmetric(vertical: 15),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                              ),
                              child: Row(
                                children: const [
                                  Text('Continuer', style: TextStyle(color: Colors.white)),
                                  SizedBox(width: 10),
                                  Icon(Icons.arrow_forward, color: Colors.white),
                                ],
                              ),
                            ),
                          if (_currentStep == 1)
                            _isLoading
                                ? const CircularProgressIndicator()
                                : SafeArea(
                              child: ElevatedButton(
                                onPressed: _submitForm,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFFFF0000),
                                  padding: const EdgeInsets.symmetric(vertical: 15),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15.0),
                                  ),
                                ),
                                child: Row(
                                  children: const [
                                    Text('Soumettre',
                                        style: TextStyle(color: Colors.white)),
                                    SizedBox(width: 10),
                                    Icon(Icons.arrow_forward, color: Colors.white),
                                  ],
                                ),
                              ),
                            ),
                        ],
                      );
                    },
                    steps: [
                      Step(
                        title: const Text('Informations Personnelles',
                            style: TextStyle(color: Colors.white)),
                        content: Form(
                          key: _formKey,
                          child: Column(
                            children: [
                              TextFormField(
                                controller: _firstNameController,
                                decoration: const InputDecoration(
                                  labelText: 'Prénom',
                                  labelStyle: TextStyle(color: Colors.white),
                                ),
                                style: const TextStyle(color: Colors.blueGrey),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Veuillez entrer votre prénom';
                                  }
                                  return null;
                                },
                              ),
                              TextFormField(
                                controller: _lastNameController,
                                decoration: const InputDecoration(
                                  labelText: 'Nom',
                                  labelStyle: TextStyle(color: Colors.white),
                                ),
                                style: const TextStyle(color: Colors.blueGrey),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Veuillez entrer votre nom';
                                  }
                                  return null;
                                },
                              ),
                              Row(
                                children: [
                                  Expanded(
                                    child: DropdownButtonFormField<int>(
                                      value: _selectedDay,
                                      items:
                                      List.generate(31, (index) => index + 1)
                                          .map((day) {
                                        return DropdownMenuItem<int>(
                                          value: day,
                                          child: Text(
                                              day.toString().padLeft(2, '0'),
                                              style: const TextStyle(
                                                  color: Colors.blueGrey)),
                                        );
                                      }).toList(),
                                      decoration: const InputDecoration(
                                        labelText: 'Jour',
                                        labelStyle:
                                        TextStyle(color: Colors.white),
                                      ),
                                      style:
                                      const TextStyle(color: Colors.blueGrey),
                                      onChanged: (value) {
                                        setState(() {
                                          _selectedDay = value ?? _selectedDay;
                                          _calculateAge();
                                        });
                                      },
                                    ),
                                  ),
                                  const SizedBox(width: 16),
                                  Expanded(
                                    child: DropdownButtonFormField<int>(
                                      value: _selectedMonth,
                                      items:
                                      List.generate(12, (index) => index + 1)
                                          .map((month) {
                                        return DropdownMenuItem<int>(
                                          value: month,
                                          child: Text(
                                              month.toString().padLeft(2, '0'),
                                              style: const TextStyle(
                                                  color: Colors.blueGrey)),
                                        );
                                      }).toList(),
                                      decoration: const InputDecoration(
                                        labelText: 'Mois',
                                        labelStyle:
                                        TextStyle(color: Colors.white),
                                      ),
                                      style:
                                      const TextStyle(color: Colors.blueGrey),
                                      onChanged: (value) {
                                        setState(() {
                                          _selectedMonth =
                                              value ?? _selectedMonth;
                                          _calculateAge();
                                        });
                                      },
                                    ),
                                  ),
                                  const SizedBox(width: 16),
                                  Expanded(
                                    child: DropdownButtonFormField<int>(
                                      value: _selectedYear,
                                      items: List.generate(
                                          100,
                                              (index) =>
                                          DateTime.now().year - index)
                                          .map((year) {
                                        return DropdownMenuItem<int>(
                                          value: year,
                                          child: Text(year.toString(),
                                              style: const TextStyle(
                                                  color: Colors.blueGrey)),
                                        );
                                      }).toList(),
                                      decoration: const InputDecoration(
                                        labelText: 'Année',
                                        labelStyle:
                                        TextStyle(color: Colors.white),
                                      ),
                                      style:
                                      const TextStyle(color: Colors.blueGrey),
                                      onChanged: (value) {
                                        setState(() {
                                          _selectedYear = value ?? _selectedYear;
                                          _calculateAge();
                                        });
                                      },
                                    ),
                                  ),
                                ],
                              ),
                              DropdownButtonFormField<String>(
                                value: _selectedIdType,
                                items: [
                                  'CNI',
                                  'PERMIS',
                                  'PASSEPORT',
                                  'AUTRE PIECE'
                                ].map((idType) {
                                  return DropdownMenuItem<String>(
                                    value: idType,
                                    child: Text(idType,
                                        style: const TextStyle(
                                            color: Colors.blueGrey)),
                                  );
                                }).toList(),
                                decoration: const InputDecoration(
                                  labelText: 'Type de pièce',
                                  labelStyle: TextStyle(color: Colors.white),
                                ),
                                style: const TextStyle(color: Colors.black),
                                onChanged: (value) {
                                  setState(() {
                                    _selectedIdType = value ?? _selectedIdType;
                                  });
                                },
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Veuillez sélectionner un type de pièce';
                                  }
                                  return null;
                                },
                              ),
                              TextFormField(
                                controller: _idNumberController,
                                decoration: const InputDecoration(
                                  labelText: 'Numéro de pièce',
                                  labelStyle: TextStyle(color: Colors.white),
                                ),
                                style: const TextStyle(color: Colors.blueGrey),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Veuillez entrer votre numéro de pièce';
                                  }
                                  return null;
                                },
                              ),
                              TextFormField(
                                controller: _passwordController,
                                obscureText: true,
                                decoration: const InputDecoration(
                                  labelText: 'Mot de passe',
                                  labelStyle: TextStyle(color: Colors.white),
                                ),
                                style: const TextStyle(color: Colors.blueGrey),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Veuillez entrer un mot de passe';
                                  }
                                  return null;
                                },
                              ),
                              TextFormField(
                                controller: _confirmPasswordController,
                                obscureText: true,
                                decoration: const InputDecoration(
                                  labelText: 'Confirmer le mot de passe',
                                  labelStyle: TextStyle(color: Colors.white),
                                ),
                                style: const TextStyle(color: Colors.blueGrey),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Veuillez confirmer votre mot de passe';
                                  }
                                  if (value != _passwordController.text) {
                                    return 'Les mots de passe ne correspondent pas';
                                  }
                                  return null;
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                      Step(
                        title: const Text('Téléverser vos fichiers',
                            style: TextStyle(color: Colors.white)),
                        content: SingleChildScrollView(
                          child: Column(
                            children: [
                              // Nouveau widget pour afficher l'image, l'icône et le texte
                              Center(
                                child: Column(
                                  children: [
                                    GestureDetector(
                                      onTap: _takeSelfie,
                                      child: Stack(
                                        alignment: Alignment.center,
                                        children: [
                                          CircleAvatar(
                                            radius: 50,
                                            backgroundImage:
                                            _selfieImageUrl != null
                                                ? FileImage(_selfieImageUrl!)
                                                : null,
                                            backgroundColor: Colors.grey[300],
                                          ),
                                          const Positioned(
                                            bottom: 0,
                                            right: 0,
                                            child: CircleAvatar(
                                              radius: 15,
                                              backgroundColor: Colors.red,
                                              child: Icon(Icons.edit,
                                                  color: Colors.white, size: 16),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(height: 10),
                                    const Text(
                                      'Madis Finance',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 24.0,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const Padding(
                                      padding:
                                      EdgeInsets.symmetric(horizontal: 16.0),
                                      child: Text(
                                        'Cliquez sur le cercle afin de charger votre photo qui sera utilisée comme votre photo de profil',
                                        style: TextStyle(
                                          color: Colors.white70,
                                          fontSize: 12.0,
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                    const SizedBox(height: 8.0),
                                    // Titre principal
                                    // Texte explicatif
                                  ],
                                ),
                              ),
                              _buildUploadButton(
                                  'Téléchargez la facture Sodeci ou Cie',
                                      (file) => _sodeciImageUrl = file),
                              _buildUploadButton(
                                  "Téléchargez le recto de ta pièce",
                                      (file) => _idFront = file),
                              _buildUploadButton(
                                  "Téléchargez le verso de ta pièce",
                                      (file) => _idBack = file),
                              _buildUploadButton(
                                  "Téléchagez Document d'autorisation",
                                      (file) => _minorDocument = file,
                                  disabled: !_isMinor),
                              _buildUploadButton(
                                  "Téléchargez l'extrait de naissance",
                                      (file) => _birthCertificate = file,
                                  disabled: !_isMinor),
                              _buildUploadButton("Telechargez la pièce du mineur",
                                      (file) => _identityDocument = file,
                                  disabled: !_isMinor),
                              CheckboxListTile(
                                title: GestureDetector(
                                  onTap: () {
                                    // Code pour afficher les conditions d'utilisation
                                  },
                                  child: const Text(
                                    "J'accepte les condition d'utilisateurs",
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                                value: _isAccepted,
                                onChanged: (bool? value) {
                                  setState(() {
                                    _isAccepted = value ?? false;
                                  });
                                },
                                activeColor: Colors.blue,
                                checkColor: Colors.white,
                                controlAffinity: ListTileControlAffinity.leading,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
 */

