import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:jchatapp/model/user_model.dart';
import 'package:jchatapp/pages/verify_code.dart';
import 'package:jchatapp/repository/user_repo.dart';
import 'package:jchatapp/utils/helper_functions/helper_functions.dart';

import '../utils/exceptions/exceptions.dart';

class FirebaseUserRepository implements UserRepository {
  final _auth = FirebaseAuth.instance;
  final _fireBasestore = FirebaseFirestore.instance;
  String? _uid;
  String? get uid => _uid;

  @override
  Stream<List<UserModel>> allUsers() {
    String userId = _auth.currentUser!.uid;

    return _fireBasestore
        .collection('users')
        .where('user_id', isNotEqualTo: userId)
        .snapshots()
        .map((snapshot) =>
            snapshot.docs.map((e) => UserModel.fromMap(e)).toList());
  }

  @override
  Future<void> createUserData(BuildContext context, UserModel user) async {
    try {
      final currentUser = _auth.currentUser!;

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

  @override
  Stream<UserModel> getUserdetailsAsStream(String phoneNumber) {
    return _fireBasestore
        .collection('users')
        .where('phoneNumber', isEqualTo: phoneNumber)
        .snapshots()
        .map((snapshot) =>
            snapshot.docs.map((doc) => UserModel.fromMap(doc)).single);
  }

  @override
  Future<void> resendOTP(BuildContext context, String phoneNumber) async {
    try {
      await _auth.setSettings(appVerificationDisabledForTesting: true);
      await _auth.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        verificationCompleted: (phone_auth) async {
          await _auth.signInWithCredential(phone_auth);
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
  Future<void> signInWithPhone(BuildContext context, String phoneNumber) async {
    try {
      await _auth.setSettings(appVerificationDisabledForTesting: true);
      await _auth.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        verificationCompleted: (phone_auth) async {
          await (_auth.signInWithCredential(phone_auth));
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

  @override
  Future<void> updateUserDetails(UserModel user, String photoURL) async {
    await _fireBasestore
        .collection('users')
        .doc(user.documentId)
        .update(user.toMap());

    await _auth.currentUser!.updatePhotoURL(photoURL);
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

      final signInCred = await _auth.signInWithCredential(phoneCred);

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
}
