import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mobile_wallet/core/services/auth_service.dart';
import 'package:mobile_wallet/library/common_widgets/snack_bar.dart';

import '../../../library/common_widgets/app_logo.dart';
import '../../widgets/custom_widgets.dart';

class RegisterForm extends StatefulWidget {
  const RegisterForm({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _RegisterFormState createState() => _RegisterFormState();
}

class _RegisterFormState extends State<RegisterForm> {
  String? _idBackFileName;
  String? _idFrontFileName;
  String? _sodeciFileName;
  String? _minorDocumentFileName;
  String? _birthCertificateFileName;
  String? _identityDocumentFilename;

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
  File? _sodeciImageUrl;
  File? _minorDocument;
  File? _birthCertificate;
  File? _identityDocument;

  final ImagePicker _picker = ImagePicker();

  int _selectedDay = 1;
  int _selectedMonth = 1;
  int _selectedYear = DateTime.now().year;
  String _selectedIdType = 'CNI'; // Type de pièce par défaut
  final FocusNode _passwordFocusNode = FocusNode();
  String _passwordErrorMessage = 'Saisissez un mot de passe de 6 chiffres';

  bool _obscureText = true;
  bool _obscureTextConfirm = true;

  @override
  void initState() {
    super.initState();
    _passwordFocusNode.addListener(_onFocusChange);
  }

  @override
  void dispose() {
    _passwordFocusNode.dispose();
    _passwordController.dispose();
    super.dispose();
  }

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
        print('_selfieImageUrl $_selfieImageUrl');

        _selfieImageUrl = File(pickedFile.path);

        print('_selfieImageUrl $_selfieImageUrl');
      });
    }
  }

  Widget _buildUploadButton(String text, Function(File) onFilePicked,
      {bool disabled = false,
      String? fileName,
      required String fileType,
      required Color iconColor}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: ElevatedButton(
        onPressed: disabled
            ? null
            : () async {
                final pickedFile =
                    await _picker.pickImage(source: ImageSource.gallery);
                if (pickedFile != null) {
                  setState(() {
                    if (fileType == 'sodeci') {
                      _sodeciFileName = pickedFile.name;
                    } else if (fileType == 'idFront') {
                      _idFrontFileName = pickedFile.name;
                    } else if (fileType == 'idBack') {
                      _idBackFileName = pickedFile.name;
                    } else if (fileType == 'minorDocument') {
                      _minorDocumentFileName = pickedFile.name;
                    } else if (fileType == 'identityDocument') {
                      _identityDocumentFilename = pickedFile.name;
                    } else if (fileType == 'birthCertificate') {
                      _birthCertificateFileName = pickedFile.name;
                    }
                  });
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
            Icon(
              fileName != null
                  ? Icons.check_circle
                  : Icons
                      .cloud_upload, // Changez l'icône si un fichier est sélectionné
              color: fileName != null ? Colors.green : Colors.white,
            ),
            const SizedBox(width: 10),
            Text(
              fileName ??
                  text, // Affichez le nom du fichier s'il est sélectionné, sinon affichez le texte par défaut
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16.0,
                fontWeight: FontWeight.w300,
              ),
            ),
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
    print('_selfieImageUrl $_selfieImageUrl');
    if (_selectedIdType == 'Passeport') {
      _idBack = _idFront;
      _idBackFileName = _idFrontFileName;
      /* debugPrint('_idFront $_idFront');
      debugPrint('_idFrontFileName $_idFrontFileName');*/
    }

    if (_formKey.currentState!.validate() && _isAccepted) {
      if (_sodeciImageUrl == null ||
          _idFront == null ||
          _idBack == null ||
          (_isMinor &&
              (_minorDocument == null ||
                  _birthCertificate == null ||
                  _identityDocument == null))) {
        print('userDocument '
            'selfie: $_selfieImageUrl \n'
            'sodeci: $_sodeciImageUrl \n'
            'recto: $_idFront \n'
            'verso: $_idBack \n'
            'parent: $_minorDocument \n'
            'extrait: $_birthCertificate \n'
            'pièce proche: $_identityDocument \n');

        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            backgroundColor: Colors.red,
            content: Text('Tous les fichiers doivent être téléversés')));
        setState(() {
          _isLoading = false; // Cacher le chargement
        });
      } else if (_selfieImageUrl == null) {
        showCustomFailedSnackBar(
            context: context,
            content:
                "Il semble que le champ selfie soit vide alors faites en un");
        setState(() {
          _isLoading = false; // Cacher le chargement
        });
        return;
      } else
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
                _identityDocument! as File);

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

  Future<bool> _verificationStep1() async {
    if (_firstNameController.text == '' ||
        _lastNameController.text == '' ||
        _idNumberController.text == '' ||
        _passwordController.text == '' ||
        _confirmPasswordController.text == '') {
      showCustomFailedSnackBar(
          context: context, content: 'Tous les champs doivent être remplis');
      return false;
    } else if (_selectedDay == 1 &&
        _selectedMonth == 1 &&
        _selectedYear == DateTime.now().year) {
      showCustomFailedSnackBar(
          context: context,
          content: 'Veuillez renseigner votre date de naissance');
      return false;
    } else if (_passwordController.text != _confirmPasswordController.text) {
      showCustomFailedSnackBar(
          context: context, content: 'Les mots de passe ne sont pas conforme');
      return false;
    } else {
      return true;
    }
  }

  void _onFocusChange() {
    if (!_passwordFocusNode.hasFocus) {
      // Champ a perdu le focus, effectuer la vérification ici
      _validatePassword();
    }
  }

  void _validatePassword() {
    String password = _passwordController.text;
    if (password.isEmpty) {
      // Message d'erreur si le mot de passe est vide
      _passwordErrorMessage = 'Veuillez entrer un mot de passe';
    } else if (password.length < 6) {
      // Message d'erreur si la taille est insuffisante
      _passwordErrorMessage = 'Veuillez entrer un mot de passe valide';
    }
    /*  else {
      _passwordErrorMessage = '';
      print('Mot de passe valide');
    } */
  }

  @override
  Widget build(BuildContext context) {
    //Taille des boutons et ecran
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Container(
          child: Theme(
            data: Theme.of(context).copyWith(
              colorScheme: const ColorScheme.light(
                primary: Color(0xFFFF0000),
              ),
              canvasColor: Colors.black, // Changez la couleur de fond ici
            ),
            child: Stepper(
              type: StepperType.horizontal,
              steps: getSteps(),
              currentStep: _currentStep,
              onStepTapped: (step) => setState(() => _currentStep = step),
              onStepContinue: () {
                final isLastStep = _currentStep == getSteps().length - 1;
                if (isLastStep) {
                  print('complet');
                } else {
                  setState(() => _currentStep += 1);
                }
              },
              onStepCancel: _currentStep == 0
                  ? null
                  : () => setState(() => _currentStep -= 1),
              controlsBuilder: (BuildContext context, ControlsDetails details) {
                final isLastStep = _currentStep == getSteps().length - 1;
                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    if (_currentStep > 0)
                      ElevatedButton(
                        onPressed: details.onStepCancel,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(50),
                          ),
                        ),
                        child: const Text(
                          'Retour',
                          style: TextStyle(color: Colors.black, fontSize: 15),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    if (!isLastStep)
                      Container(
                        width: screenWidth * 0.85,
                        //Bouton taille et longueur et lageur
                        margin: const EdgeInsets.symmetric(vertical: 8.0),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20.0, vertical: 5.0),
                        child: ElevatedButton(
                          onPressed: () async {
                            // Vérifiez si tout est correct
                            bool verification = await _verificationStep1();

                            // Appelez onStepContinue seulement si la vérification est réussie
                            if (verification) {
                              details.onStepContinue!();
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red.shade600,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(50),
                            ),
                          ),
                          child: const Padding(
                            padding: EdgeInsets.all(16.0),
                            child: Text(
                              'Suivant',
                              style:
                                  TextStyle(color: Colors.white, fontSize: 15),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                      ),
                    if (isLastStep)
                      ElevatedButton(
                        onPressed: _isAccepted ? _submitForm : null,
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              _isAccepted ? Colors.red : Colors.blue,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(50),
                          ),
                        ),
                        child:
                            _isLoading // Ajouter une condition pour afficher le chargement ou le texte
                                ? const SizedBox(
                                    width: 20,
                                    height: 20,
                                    child: CircularProgressIndicator(
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                          Colors.white),
                                      strokeWidth: 2.0,
                                    ),
                                  )
                                : const Text(
                                    'Soumettre',
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 15),
                                    textAlign: TextAlign.center,
                                  ),
                      ),
                  ],
                );
              },
            ),
          ),
        ),
      ),

      // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  List<Step> getSteps() => [
        //STEP FOR INFORMATIONS
        Step(
            state: _currentStep > 0 ? StepState.complete : StepState.indexed,
            title: const Text(
              'Informations',
              style: TextStyle(color: Colors.white),
            ),
            content: Column(
              children: [
                Image.asset('assets/images/madis_finance.png', height: 70),
                const SizedBox(height: 20),
                const Text(
                  'Inscrivez-vous !',
                  style: TextStyle(fontSize: 24, color: Colors.white),
                ),
                const SizedBox(height: 20),
                const SizedBox(height: 10),
                const Text(
                  'Gérez parfaitement vos finances - finalisez votre inscription en ajoutant les fichiers ci-dessous !',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.white),
                ),
                const SizedBox(height: 16),
                Container(
                  width: MediaQuery.of(context).size.width,
                  color: const Color(0xFF141724), // Couleur de fond noire
                  //padding: const EdgeInsets.all(16.0),
                  child: Form(
                    key: _formKey,
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      color: const Color(0xFF141724),
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          CustomWidgets.buildLeftAlignedText("Prénoms"),
                          const SizedBox(height: 8),
                          TextFormField(
                            controller: _firstNameController,
                            decoration: InputDecoration(
                              prefixIcon:
                                  const Icon(Icons.person, color: Colors.white),
                              labelText: 'Prénoms',
                              labelStyle: const TextStyle(color: Colors.white),
                              fillColor: const Color(0xFF1A1F31),
                              filled: true,
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8.0),
                                borderSide:
                                    const BorderSide(color: Colors.white),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8.0),
                                borderSide:
                                    const BorderSide(color: Colors.white),
                              ),
                            ),
                            style: const TextStyle(color: Colors.white),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Veuillez entrer votre prénom';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 16),
                          Column(
                            children: [
                              CustomWidgets.buildLeftAlignedText("Nom"),
                              const SizedBox(height: 8),
                              TextFormField(
                                controller: _lastNameController,
                                decoration: InputDecoration(
                                  prefixIcon: const Icon(Icons.person,
                                      color: Colors.white),
                                  labelText: 'Nom',
                                  labelStyle:
                                      const TextStyle(color: Colors.white),
                                  fillColor: const Color(0xFF1A1F31),
                                  filled: true,
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8.0),
                                    borderSide:
                                        const BorderSide(color: Colors.white),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8.0),
                                    borderSide:
                                        const BorderSide(color: Colors.white),
                                  ),
                                ),
                                style: const TextStyle(color: Colors.white),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Veuillez entrer votre nom';
                                  }
                                  return null;
                                },
                              ),
                            ],
                          ),
                          const SizedBox(width: 16),

                          Container(
                            //height: 50,
                            //width: 8,
                            margin: const EdgeInsets.symmetric(vertical: 16.0),
                            child: Column(
                              children: [
                                CustomWidgets.buildLeftAlignedText(
                                    "Date de naissance"),
                                const SizedBox(height: 8),
                                Row(
                                  children: [
                                    Expanded(
                                      child: DropdownButtonFormField<int>(
                                        value: _selectedDay,
                                        items: List.generate(
                                                31, (index) => index + 1)
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
                                          fillColor: Color(0xFF1A1F31),
                                          filled: true,
                                          enabledBorder: OutlineInputBorder(
                                            //borderRadius: BorderRadius.circular(8.0),
                                            borderSide:
                                                BorderSide(color: Colors.white),
                                          ),
                                        ),
                                        style: const TextStyle(
                                            color: Colors.blueGrey),
                                        onChanged: (value) {
                                          setState(() {
                                            _selectedDay =
                                                value ?? _selectedDay;
                                            _calculateAge();
                                          });
                                        },
                                      ),
                                    ),
                                    const SizedBox(width: 16),
                                    Expanded(
                                      child: DropdownButtonFormField<int>(
                                        value: _selectedMonth,
                                        items: List.generate(
                                                12, (index) => index + 1)
                                            .map((month) {
                                          return DropdownMenuItem<int>(
                                            value: month,
                                            child: Text(
                                                month
                                                    .toString()
                                                    .padLeft(2, '0'),
                                                style: const TextStyle(
                                                    color: Colors.blueGrey)),
                                          );
                                        }).toList(),
                                        decoration: const InputDecoration(
                                          labelText: 'Mois',
                                          labelStyle:
                                              TextStyle(color: Colors.white),
                                          fillColor: Color(0xFF1A1F31),
                                          filled: true,
                                          enabledBorder: OutlineInputBorder(
                                            //borderRadius: BorderRadius.circular(8.0),
                                            borderSide:
                                                BorderSide(color: Colors.white),
                                          ),
                                        ),
                                        style: const TextStyle(
                                            color: Colors.blueGrey),
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
                                          fillColor: Color(0xFF1A1F31),
                                          filled: true,
                                          enabledBorder: OutlineInputBorder(
                                            //borderRadius: BorderRadius.circular(8.0),
                                            borderSide:
                                                BorderSide(color: Colors.white),
                                          ),
                                        ),
                                        style: const TextStyle(
                                            color: Colors.blueGrey),
                                        onChanged: (value) {
                                          setState(() {
                                            _selectedYear =
                                                value ?? _selectedYear;
                                            _calculateAge();
                                          });
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 16),
                          Column(
                            children: [
                              CustomWidgets.buildLeftAlignedText(
                                  " Coix de la pièce "),
                              const SizedBox(height: 8),
                              DropdownButtonFormField<String>(
                                value: _selectedIdType,
                                items: [
                                  const DropdownMenuItem(
                                    value: 'Passeport',
                                    child: Text('Passeport',
                                        style: TextStyle(color: Colors.white)),
                                  ),
                                  const DropdownMenuItem(
                                    value: "CNI",
                                    child: Text('CNI',
                                        style: TextStyle(color: Colors.white)),
                                  ),
                                  const DropdownMenuItem(
                                    value: 'Permis de conduire',
                                    child: Text('Permis',
                                        style: TextStyle(color: Colors.white)),
                                  ),
                                ],
                                decoration: InputDecoration(
                                  labelText: 'Choix de la pièce',
                                  labelStyle:
                                      const TextStyle(color: Colors.white),
                                  fillColor: const Color(0xFF1A1F31),
                                  filled: true,
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8.0),
                                    borderSide:
                                        const BorderSide(color: Colors.white),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8.0),
                                    borderSide:
                                        const BorderSide(color: Colors.white),
                                  ),
                                ),
                                onChanged: (value) {
                                  setState(() {
                                    _selectedIdType = value!;

                                    if (_selectedIdType == 'Passeport') {
                                      debugPrint(_selectedIdType);
                                      debugPrint('_idFront $_idFront');
                                    } else {
                                      debugPrint(_selectedIdType);

                                      // Réinitialisation de l'image si la pièce n'est pas un passeport
                                      _idFront = null;
                                      debugPrint('_idFront $_idFront');
                                      _idFrontFileName =
                                          'Téléchargez le recto de votre pièce';
                                    }
                                  });
                                },
                                dropdownColor: const Color(0xFF1A1F31),
                                style: const TextStyle(color: Colors.white),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16.0),
                          // ID de la pièce
                          Column(
                            children: [
                              CustomWidgets.buildLeftAlignedText(
                                  "Numéro de votre pièce"),
                              const SizedBox(height: 8),
                              TextFormField(
                                controller: _idNumberController,
                                decoration: InputDecoration(
                                  prefixIcon: const Icon(Icons.credit_card,
                                      color: Colors.white),
                                  labelText: 'ID de votre pièce',
                                  labelStyle:
                                      const TextStyle(color: Colors.white),
                                  fillColor: const Color(0xFF1A1F31),
                                  filled: true,
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8.0),
                                    borderSide:
                                        const BorderSide(color: Colors.white),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8.0),
                                    borderSide:
                                        const BorderSide(color: Colors.white),
                                  ),
                                ),
                                style: const TextStyle(color: Colors.white),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Veuillez entrer votre numéro de pièce';
                                  }
                                  return null;
                                },
                              ),
                            ],
                          ),
                          const SizedBox(height: 16.0),
                          Column(
                            children: [
                              CustomWidgets.buildLeftAlignedText(
                                  "Mot de passe"),
                              const SizedBox(height: 8),
                              TextFormField(
                                inputFormatters: [
                                  LengthLimitingTextInputFormatter(6),
                                ],
                                obscureText: _obscureText,
                                controller: _passwordController,
                                keyboardType: TextInputType.number,
                                // Attachez le FocusNode ici
                                focusNode: _passwordFocusNode,
                                decoration: InputDecoration(
                                  labelText: 'Mot de passe',
                                  labelStyle:
                                      const TextStyle(color: Colors.white),
                                  prefixIcon: IconButton(
                                    icon: Icon(
                                        _obscureText
                                            ? Icons.lock
                                            : Icons.lock_open,
                                        color: Colors.white),
                                    onPressed: () {
                                      setState(() {
                                        _obscureText = !_obscureText;
                                      });
                                    },
                                  ),
                                  helperText: _passwordErrorMessage,
                                  helperStyle: TextStyle(
                                    color: _passwordController
                                                .text.isNotEmpty &&
                                            _passwordController.text.length < 6
                                        ? Colors.red
                                        : Colors.white,
                                  ),
                                  fillColor: const Color(0xFF1A1F31),
                                  filled: true,
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8.0),
                                    borderSide:
                                        const BorderSide(color: Colors.white),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8.0),
                                    borderSide:
                                        const BorderSide(color: Colors.white),
                                  ),
                                ),
                                style: const TextStyle(
                                  color: Colors.white,
                                ),
                                textAlign: TextAlign.center,
                                /*  validator: (value) {
                                  if (value!.isEmpty) {
                                    return 'Veuillez entrer un mot de passe';
                                  } else if (value.length < 6) {
                                    return 'Veuillez entrer la taille réquise';
                                  }
                                  return null;
                                }, */
                              ),
                            ],
                          ),
                          const SizedBox(height: 16.0),
                          Column(
                            children: [
                              CustomWidgets.buildLeftAlignedText(
                                  "Confirmation du mot de passe"),
                              const SizedBox(height: 8),
                              TextFormField(
                                inputFormatters: [
                                  LengthLimitingTextInputFormatter(6),
                                ],
                                controller: _confirmPasswordController,
                                obscureText: _obscureTextConfirm,
                                //keyboardType: TextInputType.number,
                                decoration: InputDecoration(
                                  prefixIcon: IconButton(
                                    icon: Icon(
                                        _obscureTextConfirm
                                            ? Icons.lock
                                            : Icons.lock_open,
                                        color: Colors.white),
                                    onPressed: () {
                                      setState(() {
                                        _obscureTextConfirm =
                                            !_obscureTextConfirm;
                                      });
                                    },
                                  ),
                                  labelText: 'Confirmez votre mot de passe',
                                  labelStyle:
                                      const TextStyle(color: Colors.white),
                                  fillColor: const Color(0xFF1A1F31),
                                  filled: true,
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8.0),
                                    borderSide:
                                        const BorderSide(color: Colors.white),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8.0),
                                    borderSide:
                                        const BorderSide(color: Colors.white),
                                  ),
                                ),
                                style: const TextStyle(color: Colors.white),
                                textAlign: TextAlign.center,
                                /*   validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Veuillez confirmer votre mot de passe';
                                  }
                                  if (value != _passwordController.text) {
                                    return 'Les mots de passe ne correspondent pas';
                                  }
                                  return null;
                                }, */
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            // permets de savoir si l'étape est active ou non
            isActive: _currentStep >= 0),
        // STEP FOR UPLOADS
        Step(
          state: _currentStep > 1 ? StepState.complete : StepState.indexed,
          title: const Text(
            'Téléverser',
            style: TextStyle(color: Colors.white),
          ),
          content: SingleChildScrollView(
            child: Container(
              color: const Color(0xFF000000), // Couleur de fond noire
              //padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Image.asset('assets/images/madis_finance.png', height: 70),
                  const SizedBox(height: 10),
                  const Text(
                    'Inscrivez-vous !',
                    style: TextStyle(fontSize: 24, color: Colors.white),
                  ),
                  const SizedBox(height: 15),
                  //const SizedBox(height: 10),
                  const Text(
                    'Gérez parfaitement vos finances - finalisez votre inscription en ajoutant les fichiers ci-dessous !',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.white),
                  ),
                  const SizedBox(height: 15),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(16.0),
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      color: const Color(0xFF141724),
                      padding: const EdgeInsets.all(10.0),
                      child: Column(
                        children: [
                          Container(
                            child: Center(
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
                                  const Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.info_outline,
                                        color: Colors.red,
                                        size: 16.0,
                                      ),
                                      SizedBox(
                                          width:
                                              4.0), // Espacement entre l'icône et le texte
                                      Text(
                                        'Cliquez sur le cercle afin de charger votre photo \nqui sera utilisée comme votre photo de profil',
                                        style: TextStyle(
                                          color: Colors.white70,
                                          fontSize: 12.0,
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 20.0),
                                ],
                              ),
                            ),
                          ),

                          const SizedBox(height: 5),
                          Column(
                            children: [
                              if (_selectedIdType == 'Passeport') ...[
                                CustomWidgets.buildLeftAlignedText1(
                                    "Ajout de votre pièce"),
                                _buildUploadButton(
                                  "Téléchargez votre pièce",
                                  (file) => _idFront = file,
                                  fileName: _idFrontFileName,
                                  fileType: 'idFront',
                                  iconColor: _idFront != null
                                      ? Colors.green
                                      : Colors.white,
                                ),
                              ],
                              if (_selectedIdType != 'Passeport') ...[
                                CustomWidgets.buildLeftAlignedText1(
                                    "Ajout de votre pièce recto"),
                                _buildUploadButton(
                                  "Téléchargez le recto de votre pièce",
                                  (file) => _idFront = file,
                                  fileName: _idFrontFileName,
                                  fileType: 'idFront',
                                  iconColor: _idFront != null
                                      ? Colors.green
                                      : Colors.white,
                                ),
                                CustomWidgets.buildLeftAlignedText1(
                                    "Ajout de la pièce verso"),
                                _buildUploadButton(
                                  "Téléchargez le verso de votre pièce",
                                  (file) => setState(() => _idBack = file),
                                  fileName: _idBackFileName,
                                  fileType: 'idBack',
                                  iconColor: _idBack != null
                                      ? Colors.green
                                      : Colors.white,
                                ),
                              ],

                              /* if (_selectedIdType != 'Passeport') ...[
                        CustomWidgets.buildLeftAlignedText1("Ajout de la pièce verso"),
                        _buildUploadButton(
                          "Téléchargez le verso de votre pièce",
                              (file) => setState(() => _idBack = file),
                          fileName: _idBackFileName,
                          fileType: 'idBack',
                          iconColor: _idBack != null ? Colors.green : Colors.white,
                        ),
                      ],*/
                            ],
                          ),
                          //const SizedBox(height: 8), // Espacement entre le texte et le bouton

                          const SizedBox(
                              height:
                                  5), // Espacement entre le texte et le bouton
                          Column(
                            children: [
                              CustomWidgets.buildLeftAlignedText1(
                                  "Ajout de facture"),
                              _buildUploadButton(
                                'Téléversez la facture Sodeci ou Cie',
                                (file) => _sodeciImageUrl = file,
                                fileName: _sodeciFileName,
                                fileType: 'sodeci',
                                iconColor: _idBack != null
                                    ? Colors.green
                                    : Colors.white,
                              ),
                            ],
                          ),
                          const SizedBox(
                              height:
                                  5), // Espacement entre le texte et le bouton
                          Column(
                            children: [
                              CustomWidgets.buildLeftAlignedText1(
                                  "Ajout de pièce d'un parent"),
                              _buildUploadButton(
                                "Document d'autorisation",
                                (file) => _minorDocument = file,
                                disabled: !_isMinor,
                                fileName: _minorDocumentFileName,
                                fileType: 'minorDocument',
                                iconColor: _idBack != null
                                    ? Colors.green
                                    : Colors.white,
                              ),
                            ],
                          ),

                          const SizedBox(
                              height:
                                  5), // Espacement entre le texte et le bouton
                          Column(
                            children: [
                              CustomWidgets.buildLeftAlignedText1(
                                  "Ajout extrait de naissance"),
                              _buildUploadButton(
                                "Téléchargez l'extrait de naissance",
                                (file) => _birthCertificate = file,
                                disabled: !_isMinor,
                                fileName: _birthCertificateFileName,
                                fileType: 'birthCertificate',
                                iconColor: _idBack != null
                                    ? Colors.green
                                    : Colors.white,
                              ),
                            ],
                          ),
                          const SizedBox(
                              height:
                                  5), // Espacement entre le texte et le bouton
                          Column(
                            children: [
                              CustomWidgets.buildLeftAlignedText1(
                                  "Ajout de pièce d'un proche"),
                              _buildUploadButton(
                                "Téléchargez de pièce d'un proche",
                                (file) => _identityDocument = file,
                                disabled: !_isMinor,
                                fileName: _identityDocumentFilename,
                                fileType: 'identityDocument',
                                iconColor: _idBack != null
                                    ? Colors.green
                                    : Colors.white,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  CheckboxListTile(
                    title: GestureDetector(
                      onTap: () {
                        // Code pour afficher les conditions d'utilisation
                      },
                      child: Text(
                        'J\'accepte les conditions d\'utilisation',
                        style: TextStyle(
                            color: _isAccepted ? Colors.green : Colors.red,
                            fontSize: 14),
                      ),
                    ),
                    value: _isAccepted,
                    onChanged: (bool? value) {
                      setState(() {
                        _isAccepted = value ?? false;
                      });
                    },
                    side: const BorderSide(color: Colors.red, width: 1.0),
                    activeColor: Colors.green,
                    checkColor: Colors.white,
                    controlAffinity: ListTileControlAffinity.leading,
                  ),
                  //const SizedBox(height: 20),
                ],
              ),
            ),
          ),
          isActive: _currentStep >= 1,
        )
      ];
}
