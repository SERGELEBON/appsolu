/*import 'package:cloud_firestore/cloud_firestore.dart';

class UserM {
  final String name;
  final DateTime dob;
  final String idType;
  final String idNumber;
  final String password;

  UserM({
    required this.name,
    required this.dob,
    required this.idType,
    required this.idNumber,
    required this.password,
  });

  factory UserM.fromMap(Map<String, dynamic> map) {
    return UserM(
      name: map['name'],
      dob: (map['dob'] as Timestamp).toDate(),
      idType: map['idType'],
      idNumber: map['idNumber'],
      password: map['password'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'dob': Timestamp.fromDate(dob),
      'idType': idType,
      'idNumber': idNumber,
      'password': password,
    };
  }
}
 */

// il regroupe le firestore et firebase storage

// models/user_model.dart
class UserModel {
  String id;
  String firstName;
  String lastName;
  String dateOfBirth;
  String idType;
  String idNumber;
  String userPhoneNumber;
  String password;
  String selfieImageUrl;
  String sodeciImageUrl;
  String idFrontUrl;
  String idBackUrl;
  String? minorDocumentUrl;
  String? birthCertificateUrl;
  String? identityDocumentUrl;

  UserModel({
    this.id = '',
    required this.userPhoneNumber,
    required this.firstName,
    required this.lastName,
    required this.dateOfBirth,
    required this.idType,
    required this.idNumber,
    required this.password,
    required this.selfieImageUrl,
    required this.sodeciImageUrl,
    required this.idFrontUrl,
    required this.idBackUrl,
    this.minorDocumentUrl,
    this.birthCertificateUrl,
    this.identityDocumentUrl,
  });

  Map<String, dynamic> toMap() {
    return {
      'firstName': firstName,
      'lastName': lastName,
      'dateOfBirth': dateOfBirth,
      'idType': idType,
      'idNumber': idNumber,
      'userPhoneNumber': userPhoneNumber,
      'password': password,
      'sodeciImageUrl': sodeciImageUrl.isNotEmpty ? sodeciImageUrl : 'aaa',
      'selfieUrl': selfieImageUrl.isNotEmpty ? selfieImageUrl : 'aaa',
      'idFrontUrl': idFrontUrl.isNotEmpty ? idFrontUrl : 'aaa',
      'idBackUrl': idBackUrl.isNotEmpty ? idBackUrl : 'aaa',
      'minorDocumentUrl': minorDocumentUrl,
      'birthCertificateUrl': birthCertificateUrl,
      'identityDocumentUrl': identityDocumentUrl,
    };
  }

  static UserModel fromMap(Map<String, dynamic> map) {
    return UserModel(
      id: map['id'] ?? '',
      firstName: map['firstName'] ?? '',
      lastName: map['lastName'] ?? '',
      dateOfBirth: map['dateOfBirth'] ?? '',
      idType: map['idType'] ?? '',
      idNumber: map['idNumber'] ?? '',
      userPhoneNumber: map['userPhoneNumber'] ?? '',
      password: map['password'] ?? '',
      selfieImageUrl: map['selfieImageUrl'] ?? '',
      sodeciImageUrl: map['sodeciImageUrl'] ?? '',
      idFrontUrl: map['idFrontUrl'] ?? '',
      idBackUrl: map['idBackUrl'] ?? '',
      minorDocumentUrl: map['minorDocumentUrl'],
      birthCertificateUrl: map['birthCertificateUrl'],
      identityDocumentUrl: map['identityDocumentUrl'],
    );
  }
}
