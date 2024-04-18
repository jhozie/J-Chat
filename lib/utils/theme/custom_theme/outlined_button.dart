import 'package:flutter/material.dart';
import 'package:jchatapp/utils/constants/colours.dart';

class JChatOutlineButton {
  JChatOutlineButton._();

  static final lightOutlineButton = OutlinedButtonThemeData(
    style: OutlinedButton.styleFrom(
        elevation: 0,
        foregroundColor: JChatColors.dark,
        side: const BorderSide(color: JChatColors.borderPrimary),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        textStyle: const TextStyle().copyWith(
            fontSize: 16,
            color: JChatColors.black,
            fontWeight: FontWeight.w600),
        padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 20)),
  );
  static final darkOutlineButton = OutlinedButtonThemeData(
    style: OutlinedButton.styleFrom(
        elevation: 0,
        foregroundColor: JChatColors.light,
        side: const BorderSide(color: JChatColors.borderPrimary),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        textStyle: const TextStyle().copyWith(
            fontSize: 16,
            color: JChatColors.white,
            fontWeight: FontWeight.w600),
        padding: const EdgeInsets.symmetric(vertical: 18)),
  );
}
