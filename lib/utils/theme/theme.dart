import 'package:flutter/material.dart';
import 'package:jchatapp/utils/constants/colours.dart';
import 'package:jchatapp/utils/theme/custom_theme/appbar_theme.dart';
import 'package:jchatapp/utils/theme/custom_theme/bottom_sheet.dart';
import 'package:jchatapp/utils/theme/custom_theme/elevated_buttons.dart';
import 'package:jchatapp/utils/theme/custom_theme/floating_action_button.dart';
import 'package:jchatapp/utils/theme/custom_theme/outlined_button.dart';
import 'package:jchatapp/utils/theme/custom_theme/text_field.dart';
import 'package:jchatapp/utils/theme/custom_theme/text_theme.dart';

class JChatTheme {
  JChatTheme._();

  static ThemeData lightThemeMode = ThemeData(
      brightness: Brightness.light,
      textTheme: JChatTextTheme.textThemeDarkMode,
      scaffoldBackgroundColor: JChatColors.white,
      fontFamily: 'Poppins',
      primaryColor: JChatColors.primaryColor,
      useMaterial3: true,
      appBarTheme: JChatAppBarTheme.lightAppBarTheme,
      floatingActionButtonTheme:
          JChatFloatingActionButton.lightFloatingActionButton,
      elevatedButtonTheme: JchatElevatedButton.lightElevatedButtons,
      outlinedButtonTheme: JChatOutlineButton.lightOutlineButton,
      bottomSheetTheme: JChatBSheet.lightBottomSheet,
      inputDecorationTheme: JChatTextField.lightTextField);

  static ThemeData lightThemeModeAlt = ThemeData(
      brightness: Brightness.light,
      textTheme: JChatTextTheme.textThemeLightMode,
      scaffoldBackgroundColor: JChatColors.white,
      fontFamily: 'Poppins',
      primaryColor: JChatColors.primaryColor,
      useMaterial3: true,
      appBarTheme: JChatAppBarTheme.lightAppBarTheme,
      floatingActionButtonTheme:
          JChatFloatingActionButton.lightFloatingActionButton,
      elevatedButtonTheme: JchatElevatedButton.lightElevatedButtons,
      outlinedButtonTheme: JChatOutlineButton.lightOutlineButton,
      bottomSheetTheme: JChatBSheet.lightBottomSheet,
      inputDecorationTheme: JChatTextField.lightTextField);

  //Dark Mode

  static ThemeData darkThemeMode = ThemeData(
      brightness: Brightness.dark,
      textTheme: JChatTextTheme.textThemeDarkMode,
      scaffoldBackgroundColor: JChatColors.black,
      fontFamily: 'Poppins',
      primaryColor: JChatColors.primaryColor,
      useMaterial3: true,
      appBarTheme: JChatAppBarTheme.darkAppBarTheme,
      floatingActionButtonTheme:
          JChatFloatingActionButton.darkFloatingActionButton,
      elevatedButtonTheme: JchatElevatedButton.darkElevatedButtons,
      outlinedButtonTheme: JChatOutlineButton.darkOutlineButton,
      bottomSheetTheme: JChatBSheet.lightBottomSheet,
      inputDecorationTheme: JChatTextField.lightTextField);
}
