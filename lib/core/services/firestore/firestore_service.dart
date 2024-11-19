import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'user_model.dart';

class UserService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  Future<String> uploadFile(String path, File file) async {
    try {
      final ref = _storage.ref().child(path);
      await ref.putFile(file);
      return await ref.getDownloadURL();
    } catch (e) {
      throw Exception('Erreur lors du téléchargement du fichier: $e');
    }
  }

  Future<void> addUser(UserModel user, List<File> files) async {
    try {
      final docRef = _firestore
          .collection('users')
          .doc(user.idNumber); // Utilisez idNumber comme ID du document

      await docRef.set(user.toMap());

      final selfieImageUrl =
          await uploadFile('users/${user.idNumber}/selfie_image.jpg', files[0]);
      final idFrontUrl =
          await uploadFile('users/${user.idNumber}/id_front.jpg', files[1]);
      final idBackUrl =
          await uploadFile('users/${user.idNumber}/id_back.jpg', files[2]);
      final sodeciImageUrl = await uploadFile(
          'users/${user.idNumber}/sodecicie_image.jpg', files[0]);

      await docRef.update({
        'selfieImageUrl': selfieImageUrl,
        'sodeciImageUrl': sodeciImageUrl,
        'idFrontUrl': idFrontUrl,
        'idBackUrl': idBackUrl,
      });

      if (user.minorDocumentUrl != null && files.length >= 6) {
        final minorDocumentUrl = await uploadFile(
            'users/${user.idNumber}/minor_document.jpg', files[3]);
        final birthCertificateUrl = await uploadFile(
            'users/${user.idNumber}/birth_certificate.jpg', files[4]);
        final identityDocumentUrl = await uploadFile(
            'users/${user.idNumber}/identity_document.jpg', files[5]);

        await docRef.update({
          'minorDocumentUrl': minorDocumentUrl,
          'birthCertificateUrl': birthCertificateUrl,
          'identityDocumentUrl': identityDocumentUrl,
        });
      }
    } catch (e) {
      throw Exception('Erreur lors de l\'ajout de l\'utilisateur: $e');
    }
  }

  /* Future<void> addUser(UserModel user, List<File> files) async {
    try {
      final docRef = await _firestore.collection('users').add(user.toMap());

      final profileImageUrl =
          await uploadFile('users/${docRef.id}/sodecicie_image.jpg', files[0]);
      final idFrontUrl =
          await uploadFile('users/${docRef.id}/id_front.jpg', files[1]);
      final idBackUrl =
          await uploadFile('users/${docRef.id}/id_back.jpg', files[2]);

      await docRef.update({
        'profileImageUrl': profileImageUrl,
        'idFrontUrl': idFrontUrl,
        'idBackUrl': idBackUrl,
      });

      if (user.minorDocumentUrl != null && files.length >= 6) {
        final minorDocumentUrl =
            await uploadFile('users/${docRef.id}/minor_document.jpg', files[3]);
        final birthCertificateUrl = await uploadFile(
            'users/${docRef.id}/birth_certificate.jpg', files[4]);
        final identityDocumentUrl = await uploadFile(
            'users/${docRef.id}/identity_document.jpg', files[5]);

        await docRef.update({
          'minorDocumentUrl': minorDocumentUrl,
          'birthCertificateUrl': birthCertificateUrl,
          'identityDocumentUrl': identityDocumentUrl,
        });
      }
    } catch (e) {
      throw Exception('Erreur lors de l\'ajout de l\'utilisateur: $e');
    }
  } */

  // Méthode pour récupérer les données de l'utilisateur
  Future<Map<String, String>> getUserProfile(String idNumber) async {
    try {
      // Rechercher l'utilisateur dans Firestore par idNumber
      QuerySnapshot querySnapshot = await _firestore
          .collection('users')
          .where('idNumber', isEqualTo: idNumber)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        DocumentSnapshot doc = querySnapshot.docs.first;
        final data = doc.data() as Map<String, dynamic>;

        final lastName = data['lastName'] ?? '';
        final password = data['password'] ?? '';
        final firstName = data['firstName'] ?? '';
        final selfieImageUrl = data['selfieImageUrl'] ?? '';
        final userPhoneNumber = data['userPhoneNumber'] ?? '';
        final userName = '${data['firstName']} ${data['lastName']}';

        return {
          'userName': userName,
          'lastName': lastName,
          'password': password,
          'firstName': firstName,
          'selfieImageUrl': selfieImageUrl,
          'userPhoneNumber': userPhoneNumber,
        };
      } else {
        return {
          'lastName': '',
          'password': '',
          'userName': '',
          'firstName': '',
          'selfieImageUrl': '',
          'userPhoneNumber': '',
        };
      }
    } catch (e) {
      throw Exception(
          'Erreur lors de la récupération du profil utilisateur: $e');
    }
  }

  // Méthode pour récupérer tous les utilisateurs
  Future<List<UserModel>> getUsers() async {
    try {
      final snapshot = await _firestore.collection('users').get();

      return snapshot.docs.map((doc) => UserModel.fromMap(doc.data())).toList();
    } catch (e) {
      throw Exception('Erreur lors de la récupération des utilisateurs: $e');
    }
  }

  // Méthode pour modifier les données de l'utilisateur
  Future<void> updateUserProfile(UserModel user, List<File> files) async {
    try {
      if (kDebugMode) {
        print('Updating user: ${user.idNumber}, files: $files');
      }
      // Récupérer le document dans Firestore par idNumber
      final docRef = _firestore.collection('users').doc(user.idNumber);
      if (kDebugMode) {
        print('docRef $docRef');
      }

      // Vérifier si le document existe
      final docSnapshot = await docRef.get();
      if (docSnapshot.exists) {
        print("Document found: ${docSnapshot.data()}");
      } else {
        throw Exception(
            'Document with idNumber ${user.idNumber} does not exist.');
      }

      // Mettre à jour le document si celui-ci existe
      await docRef.update(user.toMap());
      print('Data to update: ${user.toMap()}');

      if (user.selfieImageUrl.isNotEmpty) {
        final selfieImageUrl = await uploadFile(
            'users/${user.idNumber}/selfie_image.jpg', files[0]);
        await docRef.update({
          'selfieImageUrl': selfieImageUrl,
        });
      }
    } catch (e) {
      throw Exception(
          'Erreur lors de la modification du profil utilisateur: $e');
    }
  }
}
