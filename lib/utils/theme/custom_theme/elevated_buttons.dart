import 'package:flutter/material.dart';
import 'package:jchatapp/utils/constants/colours.dart';

class JchatElevatedButton {
  JchatElevatedButton._();

  static final lightElevatedButtons = ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
        elevation: 0,
        foregroundColor: JChatColors.white,
        backgroundColor: JChatColors.primaryColor,
        disabledBackgroundColor: JChatColors.darkGrey,
        disabledForegroundColor: JChatColors.darkGrey,
        side: const BorderSide(color: JChatColors.primaryColor),
        textStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: JChatColors.white),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        padding: const EdgeInsets.symmetric(
          vertical: 18,
        )),
  );

  //Dark Mode
  static final darkElevatedButtons = ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
        elevation: 0,
        foregroundColor: JChatColors.white,
        backgroundColor: JChatColors.primaryColor,
        disabledBackgroundColor: JChatColors.darkGrey,
        disabledForegroundColor: JChatColors.darkGrey,
        side: const BorderSide(color: JChatColors.primaryColor),
        textStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: JChatColors.textWhite),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        padding: const EdgeInsets.symmetric(vertical: 18)),
  );
}
