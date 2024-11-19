import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mobile_wallet/app/pages/profils_pages/info_personel/personal_info_page.dart';
import 'package:mobile_wallet/library/common_widgets/snack_bar.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginService with ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  String _verificationId = '';
  String _phoneNumber = '';

  Future<bool> loginWithPhoneNumberAndPassword(
      BuildContext context, String phoneNumber, String password) async {
    final prefs = await SharedPreferences.getInstance();

    try {
      // Rechercher l'utilisateur avec le numéro de téléphone fourni
      final QuerySnapshot result = await firestore
          .collection('users')
          .where('userPhoneNumber', isEqualTo: phoneNumber)
          .limit(1)
          .get();

      if (result.docs.isEmpty) {
        // Si aucun utilisateur n'est trouvé avec ce numéro de téléphone
        showCustomFailedSnackBar(
            content: 'Aucun utilisateur trouvé avec ce numéro de téléphone.',
            context: context);
        /*  showErrorDialog(
            context, '); */
        return false;
      }

      // Extraire les données utilisateur
      final DocumentSnapshot userDoc = result.docs.first;
      final userData = userDoc.data() as Map<String, dynamic>;

      /*  if (kDebugMode) {
        print('idNumber is: ${userData['idNumber']}');
        print('Password is: ${userData['password']}');
      } */

      String idNumber = userData['idNumber'];
      await prefs.setString('idNumber', idNumber);
      final verificationIDNumber = prefs.getString('idNumber');

      if (kDebugMode) {
        print('ID number is: $verificationIDNumber');
      }

      // Vérifier le mot de passe
      if (userData['password'] == password) {
        // Connexion réussie, redirection vers la page d'accueil
        Navigator.pushReplacementNamed(context, '/home/HomePage');
      }
      /*  else {
        // Mot de passe incorrect
        showErrorDialog(context, 'Veuillez vérifier vos accès');
      } */
      return true;
    } catch (e) {
      // Gestion des erreurs
      showCustomFailedSnackBar(
          content: 'Erreur lors de la connexion', context: context);

      return false;
    }
  }

  // Fonction pour afficher un message d'erreur
  /* void showErrorDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Erreur'),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  } */

  Future<void> sendOTP(BuildContext context, String phoneNumber) async {
    final prefs = await SharedPreferences.getInstance();

    _phoneNumber = phoneNumber;
    try {
      await _auth.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        timeout: const Duration(seconds: 120),
        verificationCompleted: (PhoneAuthCredential credential) async {
          await _auth.signInWithCredential(credential);
          if (kDebugMode) {
            print(
                "Phone number automatically verified and user signed in: ${_auth.currentUser?.uid}");
          }
        },
        verificationFailed: (FirebaseAuthException e) {
          if (e.code == 'invalid-phone-number') {
            showCustomFailedSnackBar(
                content: 'Le numéro de téléphone fourni est invalide.',
                context: context);
          } else {
            showCustomFailedSnackBar(
                content: 'Échec de la vérification du numéro de téléphone.',
                context: context);
            /* showErrorDialog(context,
                'Échec de la vérification du numéro de téléphone. Code: ${e.code}. Message: ${e.message}'); */
          }
        },
        codeSent: (String verificationId, int? resendToken) async {
          await Future.delayed(const Duration(milliseconds: 600));

          _verificationId = verificationId;

          await prefs.setString(
            'verificationID',
            _verificationId,
          );

          final verificationID = prefs.getString('verificationID');
          if (kDebugMode) {
            print('savedVerificationID in codeSent $verificationID');
          }

          // _verificationId = verificationId;

          if (_verificationId == null) {
            /*  if (kDebugMode) {
              print('INITIALIZE _verificationId IN SEND_OTP: $_verificationId');
            } */
          }

/*           if (kDebugMode) {
            print('INITIALIZE _verificationId IN SEND_OTP: $_verificationId');
          }

          if (kDebugMode) {
            print(
                'Veuillez vérifier votre téléphone pour le code de vérification. $_verificationId');
          } */
          Navigator.pushNamed(
            context,
            '/login/otp_reset_page',
            arguments: _verificationId,
          );
        },
        codeAutoRetrievalTimeout: (String verificationId) {
          _verificationId = verificationId;
          print("Délai de récupération automatique dépassé.");
        },
      );
    } catch (e) {
      showCustomFailedSnackBar(
          context: context, content: 'Erreur lors de l\'envoi de l\'OTP ');
    }
  }

  Future<void> verifyOTP(String smsCode, BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();

    final verificationID = prefs.getString('verificationID');
    if (kDebugMode) {
      print('savedVerificationID $verificationID');
    }

    _verificationId = verificationID!;
    PhoneAuthCredential credential = PhoneAuthProvider.credential(
      verificationId: _verificationId,
      smsCode: smsCode,
    );

    if (kDebugMode) {
      print('verificationID in verifyOTP is: $verificationID');

      print('_verificationId in verifyOTP is: $_verificationId');

      print('Phone number is: $_phoneNumber');
    }

    if (kDebugMode) {
      print('OTP is: $smsCode');
    }

    if (kDebugMode) {
      print('credential is: $credential');
    }

    try {
      UserCredential userCredential =
          await _auth.signInWithCredential(credential);
      if (kDebugMode) {
        print("Utilisateur connecté avec succès: ${userCredential.user?.uid}");
      }

      User? user = _auth.currentUser;
      if (user != null) {
        if (kDebugMode) {
          print("l'utilisateur est connecté:${user.phoneNumber} ${user.uid}");
        }
        if (user.phoneNumber != null) {
          String? phone = user.phoneNumber;
          await prefs.setString(
            'phoneNumber',
            phone!,
          );
        } else {
          print('Aucun numéro trouver');
        }
        Navigator.pushNamed(
          context,
          '/login/reset_password_page',
          arguments: _verificationId,
        );
      } else {
        if (kDebugMode) {
          print("l'utilisateur n'est pas connecté");
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print("Echec de la connexion: ${e.toString()}");
      }
    }
  }

  Future<void> resetPassword({
    required BuildContext context,
    required String newPassword,
    required String phoneNumber,
  }) async {
    try {
      // Récupérer l'utilisateur actuel
      final User? user = _auth.currentUser;

      // vérification des données de l'utilisateur actuel
      if (user == null) {
        showCustomFailedSnackBar(
            content: 'Aucun utilisateur connecté.', context: context);
        //showErrorDialog(context, 'Aucun utilisateur connecté.');
        return;
      }

      // Récupérer le document utilisateur
      QuerySnapshot querySnapshot = await firestore
          .collection('users')
          .where('userPhoneNumber', isEqualTo: phoneNumber)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        DocumentSnapshot doc = querySnapshot.docs.first;
        //final data = doc.data() as Map<String, dynamic>;
        /*  String idNumber = data['idNumber'];
        await prefs.setString('idNumber', idNumber); */

        // Mettre à jour le mot de passe dans Firestore
        await doc.reference.update({'password': newPassword});

        showCustomSuccessSnackBar(
            content: 'Mot de passe réinitialisée avec succès.',
            context: context);

        //Redirection vers la page de connexion
        //pour une prémière connexion après reinitialisation
        // du mot de pass
        Navigator.pushReplacementNamed(context, '/login/login_page');
      } else {
        showCustomFailedSnackBar(
            content:
                'Aucun utilisateur trouvé échec de la réinitialisation du mot de passe',
            context: context);
      }
    } catch (e) {
      if (kDebugMode) {
        print(e.toString());
      }
    }
  }

  Future<void> modifyPassword({
    required BuildContext context,
    required String oldPassword,
    required String newPassword,
    required String phoneNumber,
  }) async {
    try {
      // Récupérer le document utilisateur
      QuerySnapshot querySnapshot = await firestore
          .collection('users')
          .where('userPhoneNumber', isEqualTo: phoneNumber)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        DocumentSnapshot doc = querySnapshot.docs.first;
        final data = doc.data() as Map<String, dynamic>;
        String password = data['password'];

        if (kDebugMode) {
          print('password: $password');
        }
        //await prefs.setString('idNumber', idNumber);

        // Mettre à jour le mot de passe dans Firestore
        if (password == oldPassword) {
          print('old password: $password');

          await doc.reference.update({'password': newPassword});

          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const PersonalInfoPage()),
          );
          showCustomSuccessSnackBar(
              context: context, content: 'Mot de passe mofidié avec succès.');
        } else {
          showCustomFailedSnackBar(
              context: context, content: 'Ancien mot de passe incorrect.');
        }
      } else {
        showCustomFailedSnackBar(
            context: context,
            content:
                'Aucun utilisateur trouvé échec de la modification du mot de passe');
        /* showErrorDialog(context,
            'Aucun utilisateur 
            trouvé échec de la 
            modification du mot de passe
            '); */
      }
    } catch (e) {
      showCustomFailedSnackBar(
          context: context,
          content:
              'Cet utilisateur n\'existe échec de la modification du mot de passe');
      if (kDebugMode) {
        print(e.toString());
      }
    }
  }
}
