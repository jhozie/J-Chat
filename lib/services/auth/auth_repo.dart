import 'dart:io';

import 'package:flutter/material.dart';
import 'package:jchatapp/services/auth/auth_user.dart';
import 'package:jchatapp/model/friends_model.dart';
import 'package:jchatapp/model/user_model.dart';

abstract class AuthRepo {
  AuthUser? get currentUser;

  Future<void> signInWithPhone(
    BuildContext context,
    String phoneNumber,
  );

  Future<void> verifyOtpCode({
    required BuildContext context,
    required String verificationId,
    required String optCode,
    required Function onSuccess,
  });

  Future<void> resendOTP(
    BuildContext context,
    String phoneNumber,
  );

  Future<void> createUserData(
    BuildContext context,
    UserModel user,
  );
  Future<void> addNewFriends(
    BuildContext context,
    FriendsModel friends,
    String userId,
  );
  Future<String> uploadImage(
    String path,
    File file,
  );
  Future<void> initialize();

  Future<void> signOut();
}
