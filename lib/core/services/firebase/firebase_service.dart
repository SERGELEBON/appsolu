/*import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  //final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<void> signInWithPhone(String phoneNumber,
      void Function(PhoneAuthCredential) verificationCompleted,
      void Function(FirebaseAuthException) verificationFailed,
      void Function(String, int?) codeSent,
      void Function(String) codeAutoRetrievalTimeout) async {
    await _auth.verifyPhoneNumber(
      phoneNumber: phoneNumber,
      verificationCompleted: verificationCompleted,
      verificationFailed: verificationFailed,
      codeSent: codeSent,
      codeAutoRetrievalTimeout: codeAutoRetrievalTimeout,
    );
  }

}
 */
