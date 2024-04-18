import 'package:flutter/material.dart';
import 'package:jchatapp/utils/constants/colours.dart';

class JChatFloatingActionButton {
  JChatFloatingActionButton._();

  static final lightFloatingActionButton = FloatingActionButtonThemeData(
    elevation: 0,
    backgroundColor: JChatColors.primaryColor,
    foregroundColor: JChatColors.white,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
  );
  static final darkFloatingActionButton = FloatingActionButtonThemeData(
    elevation: 0,
    backgroundColor: JChatColors.primaryColor,
    foregroundColor: JChatColors.white,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
  );
}
