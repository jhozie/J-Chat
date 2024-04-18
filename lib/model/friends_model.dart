import 'package:cloud_firestore/cloud_firestore.dart';

class FriendsModel {
  FriendsModel({
    this.docId,
    this.friendId,
    this.currentUserId,
    this.name,
    this.phoneNumber,
    this.profileImage,
  });
  final String? docId;
  final String? friendId;
  final String? currentUserId;
  final String? name;
  final String? phoneNumber;
  final String? profileImage;

  factory FriendsModel.fromMap(
      QueryDocumentSnapshot<Map<String, dynamic>> document) {
    final data = document.data();
    return FriendsModel(
      docId: document.id,
      friendId: data['friendUserId'],
      currentUserId: data['ownerUserId'],
      name: data['name'],
      phoneNumber: data['phoneNumber'],
      profileImage: data['profilelmage'],
    );
  }
  Map<String, dynamic> toMap() {
    return {
      'docId': docId,
      'friendUserId': friendId,
      'ownerUserId': currentUserId,
      'name': name,
      'phoneNumber': phoneNumber,
      'profilelmage': profileImage,
    };
  }
}
