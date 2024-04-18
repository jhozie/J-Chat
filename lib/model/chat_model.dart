import 'dart:ffi';

import 'package:cloud_firestore/cloud_firestore.dart';

class Message {
  Message({
    this.docId,
    required this.senderId,
    required this.name,
    required this.receiverId,
    required this.message,
    required this.createdAt,
    required this.receiverName,
  });

  final String? docId;
  final String senderId;
  final String name;
  final String receiverId;
  final String message;
  final DateTime createdAt;

  final String receiverName;

  factory Message.fromMap(
      QueryDocumentSnapshot<Map<String, dynamic>> document) {
    final data = document.data();

    return Message(
      docId: document.id,
      senderId: data['senderId'] as String? ?? '',
      name: data['name'] as String? ?? '',
      receiverId: data['receiverId'] as String? ?? '',
      message: data['message'] as String? ?? '',
      createdAt: (data['createAt'] != null
          ? (data['createAt'] as Timestamp).toDate()
          : DateTime.now()),
      receiverName: data['receiverName'] as String? ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'docId': docId,
      'senderId': senderId,
      'name': name,
      'recieverId': receiverId,
      'message': message,
      'createAt': Timestamp.fromDate(createdAt),
    };
  }
}
