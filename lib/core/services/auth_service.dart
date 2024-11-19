import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mobile_wallet/core/services/firestore/firestore_service.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  late Timer timer;

  Future<void> verifyPhoneNumber(
    String phoneNumber,
    Function(String) codeSent,
    Function(String) verificationFailed,
    Function(String) codeAutoRetrievalTimeout,
  ) async {
    await _auth.verifyPhoneNumber(
      phoneNumber: phoneNumber,
      verificationCompleted: (PhoneAuthCredential credential) async {
        await _auth.signInWithCredential(credential);
      },
      verificationFailed: (FirebaseAuthException e) {
        if (e.code == 'Code est invalide') {
          print("Le numéro entré n'est pas valide.");
        }

        // Handle other errors
      },
      codeSent: (String verificationId, int? resendToken) async {
        codeSent(verificationId);
        String smsCode = 'xxxx';
        PhoneAuthCredential credential = PhoneAuthProvider.credential(
            verificationId: verificationId, smsCode: smsCode);
        // Sign the user in (or link) with the credential
        await _auth.signInWithCredential(credential);
      },
      codeAutoRetrievalTimeout: (String verificationId) {
        codeAutoRetrievalTimeout(verificationId);
        timeout:
        const Duration(seconds: 120);
      },
    );
  }

  Future<User?> signInWithPhoneNumber(
      String verificationId, String smsCode) async {
    try {
      final AuthCredential credential = PhoneAuthProvider.credential(
        verificationId: verificationId,
        smsCode: smsCode,
      );
      final User user = (await _auth.signInWithCredential(credential)).user!;

      return user;
    } catch (e) {
      return null;
    }
  }
}

// Connexion


