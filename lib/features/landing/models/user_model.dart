import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String username;
  final String email;
  final String? pin;
  final String? photoUrl;
  final String? phoneNumber;
  final String? birthDate;
  final String? bio;
  final String? address;

  final DateTime createdAt;
  final DateTime? updatedAt;

  UserModel({
    required this.username,
    required this.email,
    this.pin,
    this.photoUrl,
    this.phoneNumber,
    this.birthDate,
    this.bio,
    this.address,
    DateTime? createdAt,
    this.updatedAt,
  }) : createdAt = createdAt ?? DateTime.now();

  factory UserModel.fromMap(Map<String, dynamic> map, String documentId) {
    DateTime? parseDateTime(dynamic dateValue) {
      if (dateValue is Timestamp) {
        return dateValue.toDate();
      }
      if (dateValue is String) {
        return DateTime.tryParse(dateValue);
      }
      return null;
    }

    return UserModel(
      username: map['username'] ?? '',
      email: map['email'] ?? '',
      pin: map['pin'],
      photoUrl: map['photoUrl'],
      phoneNumber: map['phoneNumber'],
      birthDate: map['birthDate'],
      bio: map['bio'],
      address: map['address'],
      createdAt: parseDateTime(map['createdAt']),
      updatedAt: parseDateTime(map['updatedAt']),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'username': username,
      'email': email,
      'pin': pin,
      'photoUrl': photoUrl,
      'phoneNumber': phoneNumber,
      'birthDate': birthDate,
      'bio': bio,
      'address': address,
      'createdAt': FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),
    };
  }

  factory UserModel.fromUpdate(
    UserModel originalData,
    Map<String, dynamic> updateData,
  ) {
    return UserModel(
      username: updateData['username'] ?? originalData.username,
      email: updateData['email'] ?? originalData.email,
      pin: updateData['pin'] ?? originalData.pin,
      photoUrl: updateData['photoUrl'] ?? originalData.photoUrl,
      phoneNumber: updateData['phoneNumber'] ?? originalData.phoneNumber,
      birthDate: updateData['birthDate'] ?? originalData.birthDate,
      bio: updateData['bio'] ?? originalData.bio,
      address: updateData['address'] ?? originalData.address,
      createdAt: originalData.createdAt,
      updatedAt: DateTime.now(),
    );
  }
}
