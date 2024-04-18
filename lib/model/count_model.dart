import 'package:cloud_firestore/cloud_firestore.dart';

class Count {
  Count(
      {this.documentId,
      required this.participantId,
      required this.unreadMessageCount});
  final String? documentId;
  final List<String> participantId;
  final Map<String, int> unreadMessageCount;

  factory Count.fromMap(DocumentSnapshot<Map<String, dynamic>> document) {
    final data = document.data();
    if (data == null) {
      return Count(
          documentId: document.id, participantId: [], unreadMessageCount: {});
    }
    return Count(
      documentId: document.id,
      participantId: List<String>.from(data['participantId'] ?? []),
      unreadMessageCount:
          Map<String, int>.from(data['unreadMessageCount'] ?? {}),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'documentId': documentId,
      'participantId': participantId,
      'unreadMessageCount': unreadMessageCount
    };
  }
}
