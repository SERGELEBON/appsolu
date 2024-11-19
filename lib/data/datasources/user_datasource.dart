/*import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserDataSource {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> saveUserData({
    required String name,
    required DateTime dob,
    required String idType,
    required String IdNumber,
    required String password,
  }) async {
    User? user = _auth.currentUser;
    if (user != null) {
      await _firestore.collection('users').doc(user.uid).set({
        'name': name,
        'dob': dob.toIso8601String(),
        'idType': idType,
        'IdNumber': IdNumber,
        'password': password,
      });
    }
  }

  Future<DateTime?> getUserDob() async {
    User? user = _auth.currentUser;
    if (user != null) {
      DocumentSnapshot userDoc = await _firestore.collection('users').doc(
          user.uid).get();
      if (userDoc.exists) {
        return DateTime.parse(userDoc.get('dob'));
      }
    }
    return null;
  }

//récuperer user
  Future<void> getUserData() async {
    CollectionReference users = FirebaseFirestore.instance.collection('users');
    DocumentSnapshot snapshot = await users.doc('currentUser').get();
    if (snapshot.exists) {
      var userData = snapshot.data();
      // Utilisez les données utilisateur comme vous le souhaitez
    } else {
      print("User does not exist");
    }
  }
}
 */
