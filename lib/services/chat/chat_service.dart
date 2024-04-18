import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:jchatapp/services/auth/auth_service.dart';
import 'package:jchatapp/model/friends_model.dart';
import 'package:jchatapp/model/user_model.dart';
import 'package:jchatapp/model/chat_model.dart';
import 'package:jchatapp/model/count_model.dart';

class ChatService {
  ChatService();

  // Get/Display Users
  final _fireBasestore = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;
  final authService = AuthService();

  // Stream<List<Map<String, dynamic>>> getUserData() {
  //   return _fireBasestore.collection('users').snapshots().map((snapshot) {
  //     return snapshot.docs.map((doc) {
  //       final user = doc.data();
  //       return user;
  //     }).toList();
  //   });
  // }

  Stream<List<UserModel>> allUssers() {
    String userId = authService.auth.currentUser!.uid;

    return _fireBasestore
        .collection('users')
        .where('user_id', isNotEqualTo: userId)
        .snapshots()
        .map((snapshot) =>
            snapshot.docs.map((e) => UserModel.fromMap(e)).toList());
  }

  Future<List<UserModel>> allUsers() async {
    final snapshot = await _fireBasestore.collection('users').get();
    final userData = snapshot.docs.map((e) => UserModel.fromMap(e)).toList();

    return userData;
  }

  Future<UserModel> getUserDetails(String phoneNumber) async {
    final snapshot = await _fireBasestore
        .collection('users')
        .where('phoneNumber', isEqualTo: phoneNumber)
        .get();

    final userDetails = snapshot.docs.map((e) => UserModel.fromMap(e)).single;
    return userDetails;
  }

  Stream<UserModel> getUserDetailsAsStream(String phoneNumber) {
    return _fireBasestore
        .collection('users')
        .where('phoneNumber', isEqualTo: phoneNumber)
        .snapshots()
        .map((snapshot) =>
            snapshot.docs.map((doc) => UserModel.fromMap(doc)).single);
  }

  Future<void> updateUserDetails(UserModel user, String photoURL) async {
    await _fireBasestore
        .collection('users')
        .doc(user.documentId)
        .update(user.toMap());

    await _auth.currentUser!.updatePhotoURL(photoURL);
  }

  Stream<UserModel> getFriendsAsStream(String phoneNumber) {
    return _fireBasestore
        .collection('users')
        .where('friendId', isEqualTo: phoneNumber)
        .snapshots()
        .map((snapshot) =>
            snapshot.docs.map((doc) => UserModel.fromMap(doc)).single);
  }

  Stream<List<FriendsModel>> getFriendsData() {
    String userId = authService.auth.currentUser!.uid;
    return _fireBasestore
        .collection('friends')
        .where('ownerUserId', isEqualTo: userId)
        .snapshots()
        .map((snapshot) =>
            snapshot.docs.map((e) => FriendsModel.fromMap(e)).toList());
  }

  Stream<List<FriendsModel>> getAndUpdateFriendsData() {
    String userId = authService.auth.currentUser!.uid;

    return _fireBasestore
        .collection('friends')
        // .where('ownerUserId', isEqualTo: userId)
        .where('friendUserId', isEqualTo: userId)
        .snapshots()
        .map((snapshot) =>
            snapshot.docs.map((e) => FriendsModel.fromMap(e)).toList());
  }

  Future<void> updateFriendsData(FriendsModel friends) async {
    _fireBasestore
        .collection('friends')
        .doc(friends.docId)
        .update(friends.toMap());
  }

  Future<Message> sendMessage(
      String receiverId, String message, String receiverName) async {
    final currentUserId = _auth.currentUser!.uid;
    final name = _auth.currentUser!.displayName!;
    final createdAt = DateTime.now();

    final List<String> ids = [receiverId, currentUserId];
    ids.sort();
    final chatRoomId = ids.join('_');

    final querySnapshot = await _fireBasestore
        .collection('chat_room')
        .doc(chatRoomId)
        .collection('messages')
        .orderBy('createAt', descending: true)
        .limit(1)
        .get();

    if (querySnapshot.docs.isEmpty) {
      final document = await _fireBasestore
          .collection('chat_room')
          .doc(chatRoomId)
          .collection('messages')
          .add({
        'senderId': currentUserId,
        'name': name,
        'receiverName': receiverName,
        'recieverId': receiverId,
        'message': message,
        'createAt': Timestamp.fromDate(createdAt),
        'fromSenderCount': 1,
        'fromReceiverCount': 1
      });

      return Message(
        docId: document.id,
        senderId: currentUserId,
        name: name,
        receiverName: receiverName,
        receiverId: receiverId,
        message: message,
        createdAt: createdAt,
      );
    }

    // int fromSender =
    //     querySnapshot.docs.map((e) => Message.fromMap(e)).first.fromSenderCount;
    // int fromReceiver = querySnapshot.docs
    //     .map((e) => Message.fromMap(e))
    //     .first
    //     .fromReceiverCount;

    String senderId =
        querySnapshot.docs.map((e) => Message.fromMap(e)).first.senderId;

    String receiverrId =
        querySnapshot.docs.map((e) => Message.fromMap(e)).first.senderId;
    String userId = _auth.currentUser!.uid;

    final document = await _fireBasestore
        .collection('chat_room')
        .doc(chatRoomId)
        .collection('messages')
        .add({
      'senderId': currentUserId,
      'name': name,
      'recieverId': receiverId,
      'message': message,
      'createAt': Timestamp.fromDate(createdAt),
    });

    await FirebaseFirestore.instance
        .collection('chat_room')
        .doc(chatRoomId)
        .collection('unreadMessages')
        .doc(userId == senderId ? receiverId : senderId)
        .set({
      'from': senderId,
      'unreadCount': FieldValue.increment(1),
    }, SetOptions(merge: true));

    return Message(
      docId: document.id,
      senderId: currentUserId,
      name: name,
      receiverName: receiverName,
      receiverId: receiverId,
      message: message,
      createdAt: createdAt,
    );
  }

  Future<Message> sendMessage1(
      String receiverId, String message, String receiverName) async {
    final currentUserId = _auth.currentUser!.uid;
    final name = _auth.currentUser!.displayName!;
    final createdAt = DateTime.now();

    final List<String> ids = [receiverId, currentUserId];
    ids.sort();
    final chatRoomId = ids.join('_');

    final document = await _fireBasestore
        .collection('chat_room')
        .doc(chatRoomId)
        .collection('messages')
        .add({
      'senderId': currentUserId,
      'name': name,
      'receiverName': receiverName,
      'recieverId': receiverId,
      'message': message,
      'createAt': Timestamp.fromDate(createdAt),
    });

    await FirebaseFirestore.instance
        .collection('chat_room')
        .doc(chatRoomId)
        .collection('unreadMessages')
        .doc(receiverId)
        .set({
      'from': currentUserId,
      'unreadCount': FieldValue.increment(1),
    }, SetOptions(merge: true));

    return Message(
      docId: document.id,
      senderId: currentUserId,
      name: name,
      receiverName: receiverName,
      receiverId: receiverId,
      message: message,
      createdAt: createdAt,
    );
  }

  Future<int> getCounts(String receiverId, String currentUserId) async {
    final List<String> ids = [receiverId, currentUserId];
    ids.sort();
    final chatRoomId = ids.join('_');

    int unreadCount = 0;

    DocumentSnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore
        .instance
        .collection('chat_room')
        .doc(chatRoomId)
        .collection('unreadMessages')
        .doc(currentUserId)
        .get();

    if (snapshot.exists) {
      unreadCount = snapshot.data()?['unreadCount'] ?? 0;
    }

    return unreadCount;
  }

  Future<void> clearCount(String receiverId, String currentUserId) async {
    final List<String> ids = [receiverId, currentUserId];

    ids.sort();
    final chatRoomId = ids.join('_');

    await FirebaseFirestore.instance
        .collection('chat_room')
        .doc(chatRoomId)
        .collection('unreadMessages')
        .doc(currentUserId)
        .set({
      // 'from': receiverId,
      'unreadCount': 0,
    }, SetOptions(merge: true));
  }

  Stream<List<Message>> getMessages(String userId, String otherUserId) {
    final List<String> ids = [userId, otherUserId];

    ids.sort();
    final chatRoomId = ids.join('_');
    return _fireBasestore
        .collection('chat_room')
        .doc(chatRoomId)
        .collection('messages')
        .orderBy('createAt', descending: false)
        .snapshots()
        .map((snapshot) =>
            snapshot.docs.map((e) => Message.fromMap(e)).toList());
  }

  Stream<Message> getMessageLatest(String userId, String otherUserId) {
    final List<String> ids = [userId, otherUserId];

    ids.sort();
    final chatRoomId = ids.join('_');
    return _fireBasestore
        .collection('chat_room')
        .doc(chatRoomId)
        .collection('messages')
        .orderBy('createAt', descending: true)
        .limit(1)
        .snapshots()
        .map((snapshot) =>
            snapshot.docs.map((e) => Message.fromMap(e)).toList().first);
  }

  Stream<Message> getMessageLatesttt(String userId, String otherUserId) {
    final List<String> ids = [userId, otherUserId];

    ids.sort();
    final chatRoomId = ids.join('_');
    return _fireBasestore
        .collection('chat_room')
        .doc(chatRoomId)
        .collection('messages')
        .orderBy('createAt', descending: true)
        .limit(1)
        .snapshots()
        .map((snapshot) {
      if (snapshot.docs.isNotEmpty) {
        return Message.fromMap(snapshot.docs.first);
      } else {
        return Message(
          createdAt: DateTime.now(),
          message: "No messages yet",
          receiverName: '',
          name: "",
          receiverId: "",
          senderId: "",
        );
      }
    });
  }

  Stream<Message> getLatestMessageStream(String receiverId, String senderId) {
    final List<String> ids = [receiverId, senderId];
    ids.sort();
    final chatRoomId = ids.join('_');

    return _fireBasestore
        .collection('chat_room')
        .doc(chatRoomId)
        .collection('messages')
        .orderBy('createAt', descending: true)
        .limit(1)
        .snapshots()
        .map((snapshot) {
      if (snapshot.docs.isNotEmpty) {
        final latestMessageData = Message.fromMap(snapshot.docs.first);
        return latestMessageData;
      } else {
        return Message(
            docId: 'No Doc Id',
            senderId: 'No Id',
            name: 'No Name',
            receiverId: 'No Id ',
            receiverName: '',
            message: 'No message yet',
            createdAt: DateTime.now());
      }
    }).handleError((error) {
      print('Error fetching latest message: $error');
      return Message(
        docId: 'No Doc Id',
        senderId: 'No Id',
        name: 'No Name',
        receiverName: '',
        receiverId: 'No Id ',
        message: 'No message yet',
        createdAt: DateTime.now(),
      );
    });
  }

  Future<Message> getLatestMessagee1(String receiverId, String senderId) async {
    final List<String> ids = [receiverId, senderId];

    ids.sort();
    final chatRoomId = ids.join('_');
    try {
      final querySnapshot = await _fireBasestore
          .collection('chat_room')
          .doc(chatRoomId)
          .collection('messages')
          .orderBy('createAt', descending: true)
          .limit(1)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        final latestMessage =
            querySnapshot.docs.map((e) => Message.fromMap(e)).first.message;
        final latestTime =
            querySnapshot.docs.map((e) => Message.fromMap(e)).first.createdAt;
        // final latestfromSenderCount = querySnapshot.docs
        //     .map((e) => Message.fromMap(e))
        //     .first
        //     .fromSenderCount;
        // final latestfromReceiverCount = querySnapshot.docs
        //     .map((e) => Message.fromMap(e))
        //     .first
        //     .fromSenderCount;
        final docId = querySnapshot.docs.map((e) => e).first.id;
        return Message(
          docId: docId,
          senderId: senderId,
          name: '',
          receiverName: '',
          receiverId: receiverId,
          message: latestMessage,
          createdAt: latestTime,
        );
      }
      return Message(
        docId: 'No Doc Id',
        senderId: 'No Id',
        name: 'No Name',
        receiverId: 'No Id ',
        receiverName: '',
        message: 'No message yet',
        createdAt: DateTime.now(),
      );
    } catch (e) {
      print('Error fetching latest message: $e');
      return Message(
        docId: 'No Doc Id',
        senderId: 'No Id',
        name: 'No Name',
        receiverId: 'No Id ',
        receiverName: '',
        message: 'No message yet',
        createdAt: DateTime.now(),
      );
    }
  }

  Future<void> updateFriendsList(
      Map<String, dynamic> friendData, String currentUserId) async {
    await FirebaseFirestore.instance
        .collection('friends')
        .where('friendUserId', isEqualTo: currentUserId)
        .get()
        .then((QuerySnapshot snapshot) {
      snapshot.docs.forEach((DocumentSnapshot document) async {
        await FirebaseFirestore.instance
            .collection('friends')
            .doc(document.id)
            .update(friendData);
      });
    });
  }
}
