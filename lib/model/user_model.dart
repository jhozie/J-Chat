import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  UserModel({
    this.documentId,
    this.id,
    this.name,
    this.phoneNumber,
    this.bio = 'Hi, I am available on JChat',
    this.profilePicture,
  });
  final String? documentId;
  final String? id;
  final String? name;
  final String? phoneNumber;
  final String? bio;
  final String? profilePicture;

  factory UserModel.fromMap(
      QueryDocumentSnapshot<Map<String, dynamic>> document) {
    final data = document.data();
    return UserModel(
        documentId: document.id,
        id: data['user_id'],
        name: data['name'] ?? '',
        phoneNumber: data['phoneNumber'] ?? '',
        bio: data['bio'] ?? '',
        profilePicture: data['profilePicture'] ?? '');
  }

  Map<String, dynamic> toMap() {
    return {
      'docId': documentId,
      'user_id': id,
      'name': name,
      'phoneNumber': phoneNumber,
      'bio': bio,
      'profilePicture': profilePicture
    };
  }
}
