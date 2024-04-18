import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:jchatapp/firebase_options.dart';
import 'package:jchatapp/pages/verify_code.dart';
import 'package:jchatapp/services/auth/auth_repo.dart';
import 'package:jchatapp/services/auth/auth_user.dart';
import 'package:jchatapp/model/friends_model.dart';
import 'package:jchatapp/model/user_model.dart';
import 'package:jchatapp/utils/exceptions/exceptions.dart';
import 'package:jchatapp/utils/helper_functions/helper_functions.dart';

class AuthService implements AuthRepo {
  final auth = FirebaseAuth.instance;
  String? _uid;
  String? get uid => _uid;

  // Sign in with Phone

  @override
  AuthUser? get currentUser {
    final user = auth.currentUser;
    if (user != null) {
      return AuthUser.fromFirebase(user);
    } else {
      return null;
    }
  }

  @override
  Future<void> signInWithPhone(BuildContext context, String phoneNumber) async {
    try {
      await auth.setSettings(appVerificationDisabledForTesting: true);
      await auth.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        verificationCompleted: (phoneauth) async {
          await (auth.signInWithCredential(phoneauth));
        },
        verificationFailed: (error) {
          if (error.code == 'invalid-phone-number') {
            showErrorDialog(context,
                title: 'Invalid Phone Number',
                description: 'Try again with a valid phone number');
          } else {
            showErrorDialog(context,
                title: 'Error',
                description: 'Some thing went wrong. Try again');
          }
        },
        codeSent: (verificationId, forceResendingToken) async {
          await Navigator.push(context, MaterialPageRoute(builder: (context) {
            return VerifyCode(verificationId: verificationId);
          }));
        },
        codeAutoRetrievalTimeout: (verificationId) {},
      );
    } on FirebaseAuthException catch (e) {
      if (e.code == 'invalid-phone-number') {
        throw InvalidPhoneNumberException();
      } else {
        throw GenericException();
      }
    } catch (e) {
      throw GenericException();
    }
  }

  // Verify Code

  @override
  Future<void> resendOTP(BuildContext context, String phoneNumber) async {
    try {
      await auth.setSettings(appVerificationDisabledForTesting: true);
      await auth.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        verificationCompleted: (phoneAuth) async {
          await auth.signInWithCredential(phoneAuth);
        },
        verificationFailed: (error) {
          if (error.code == 'invalid-phone-number') {
            showErrorDialog(context,
                title: 'Invalid Phone Number',
                description: 'Try again with a valid phone number');
          } else {
            showErrorDialog(context,
                title: 'Error',
                description: 'Some thing went wrong. Try again');
          }
        },
        codeSent: (verificationId, forceResendingToken) {
          ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Verification code resent')));
        },
        codeAutoRetrievalTimeout: (verificationId) {},
      );
    } on FirebaseAuthException catch (e) {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(e.toString()),
          );
        },
      );
    }
  }

  @override
  Future<void> verifyOtpCode({
    required BuildContext context,
    required String verificationId,
    required String optCode,
    required Function onSuccess,
  }) async {
    try {
      PhoneAuthCredential phoneCred = PhoneAuthProvider.credential(
          verificationId: verificationId, smsCode: optCode);

      final signInCred = await auth.signInWithCredential(phoneCred);

      User? user = signInCred.user;

      if (user != null) {
        _uid = user.uid;
        onSuccess();
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'invalid-verification-code') {
        showErrorDialog(context,
            title: 'Invalid Code', description: 'Verification code not valid');
      } else {
        throw GenericException();
      }
    } catch (e) {
      throw GenericException();
    }
  }

// Create Users

  @override
  Future<void> createUserData(BuildContext context, UserModel user) async {
    try {
      final currentUser = auth.currentUser!;

      QuerySnapshot<Map<String, dynamic>> existingUser = await FirebaseFirestore
          .instance
          .collection('users')
          .where('user_id', isEqualTo: user.id)
          .limit(1)
          .get();

      if (existingUser.docs.isNotEmpty) {
        return;
      }
      await FirebaseFirestore.instance.collection('users').add(user.toMap());
      await currentUser.updateDisplayName(
        user.name,
      );
    } on FirebaseAuthException catch (e) {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(e.toString()),
          );
        },
      );
    }
  }

  // Add New Friends

  @override
  Future<void> addNewFriends(
      BuildContext context, FriendsModel friends, String userId) async {
    try {
      final existingFriends = await FirebaseFirestore.instance
          .collection('friends')
          .where('friendUserId', isEqualTo: friends.friendId)
          .where('ownerUserId', isEqualTo: userId)
          .limit(1)
          .get();

      if (existingFriends.docs.isNotEmpty) {
        return;
      }
      await FirebaseFirestore.instance
          .collection('friends')
          .add(friends.toMap());
    } on FirebaseAuthException catch (e) {}
  }

  @override
  Future<String> uploadImage(String path, File file) async {
    final ref = FirebaseStorage.instance.ref().child(path);
    final uploadTask = ref.putFile(file);

    await auth.currentUser!.updatePhotoURL(path);
    await uploadTask;
    final downloadUrl = await ref.getDownloadURL();

    return downloadUrl;
  }

  pickImage(BuildContext context) async {
    File? image;
    try {
      final pickedImage =
          await ImagePicker().pickImage(source: ImageSource.gallery);

      if (pickedImage != null) {
        image = File(pickedImage.path);
      }
    } catch (e) {
      showErrorDialog(context, title: '', description: e.toString());
    }
    return image;
  }

  @override
  Future<void> signOut() async {
    await auth.signOut();
  }

  @override
  Future<void> initialize() async {
    await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform);
  }
}
