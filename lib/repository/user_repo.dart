import 'package:flutter/material.dart';
import 'package:jchatapp/model/user_model.dart';

abstract class UserRepository {
  Future<void> createUserData(
    BuildContext context,
    UserModel user,
  );

  Stream<List<UserModel>> allUsers();

  Stream<UserModel> getUserdetailsAsStream(String phoneNumber);
  Future<void> updateUserDetails(UserModel user, String photoURL);
}
