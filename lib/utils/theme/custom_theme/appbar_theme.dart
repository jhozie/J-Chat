import 'package:flutter/material.dart';
import 'package:jchatapp/utils/constants/colours.dart';

class JChatAppBarTheme {
  JChatAppBarTheme._();

  static const lightAppBarTheme = AppBarTheme(
      elevation: 0,
      scrolledUnderElevation: 0,
      backgroundColor: Colors.transparent,
      surfaceTintColor: Colors.transparent,
      iconTheme: IconThemeData(
        color: JChatColors.black,
        size: 24,
      ),
      actionsIconTheme: IconThemeData(color: JChatColors.black, size: 24),
      centerTitle: false,
      titleTextStyle: TextStyle(
          fontSize: 18, fontWeight: FontWeight.w600, color: JChatColors.black));

  // Dark Mode

  static const darkAppBarTheme = AppBarTheme(
      elevation: 0,
      scrolledUnderElevation: 0,
      backgroundColor: Colors.transparent,
      surfaceTintColor: Colors.transparent,
      iconTheme: IconThemeData(
        color: JChatColors.black,
        size: 24,
      ),
      actionsIconTheme: IconThemeData(color: JChatColors.white, size: 24),
      centerTitle: false,
      titleTextStyle: TextStyle(
          fontSize: 18, fontWeight: FontWeight.w600, color: JChatColors.white));
}
