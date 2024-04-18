import 'package:firebase_auth/firebase_auth.dart';

class AuthUser {
  final String? phoneNumber;
  final String id;

  AuthUser({required this.phoneNumber, required this.id});

  factory AuthUser.fromFirebase(User user) {
    return AuthUser(phoneNumber: user.phoneNumber, id: user.uid);
  }
}
