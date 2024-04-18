import 'package:flutter/material.dart';
import 'package:jchatapp/utils/constants/colours.dart';

class JChatTextField {
  JChatTextField._();

  static final lightTextField = InputDecorationTheme(
    errorMaxLines: 3,
    prefixIconColor: JChatColors.darkGrey,
    suffixIconColor: JChatColors.darkGrey,
    labelStyle:
        const TextStyle().copyWith(fontSize: 14, color: JChatColors.black),
    hintStyle:
        const TextStyle().copyWith(fontSize: 14, color: JChatColors.black),
    errorStyle: const TextStyle().copyWith(fontStyle: FontStyle.normal),
    floatingLabelStyle: const TextStyle().copyWith(
      color: JChatColors.black.withOpacity(0.8),
    ),
    border: const OutlineInputBorder().copyWith(
      borderSide: const BorderSide(color: JChatColors.grey, width: 1),
      borderRadius: BorderRadius.circular(14),
    ),
    enabledBorder: const OutlineInputBorder().copyWith(
      borderSide: const BorderSide(color: JChatColors.grey, width: 1),
      borderRadius: BorderRadius.circular(14),
    ),
    focusedBorder: const OutlineInputBorder().copyWith(
      borderSide: const BorderSide(color: JChatColors.dark, width: 1),
      borderRadius: BorderRadius.circular(14),
    ),
    errorBorder: const OutlineInputBorder().copyWith(
      borderSide: const BorderSide(color: JChatColors.warning, width: 1),
      borderRadius: BorderRadius.circular(14),
    ),
    focusedErrorBorder: const OutlineInputBorder().copyWith(
      borderSide: const BorderSide(color: Colors.orange, width: 1),
      borderRadius: BorderRadius.circular(14),
    ),
  );

//dark Mode

  static final darkTextField = InputDecorationTheme(
    errorMaxLines: 3,
    prefixIconColor: JChatColors.darkGrey,
    suffixIconColor: JChatColors.darkGrey,
    labelStyle:
        const TextStyle().copyWith(fontSize: 14, color: JChatColors.black),
    hintStyle:
        const TextStyle().copyWith(fontSize: 14, color: JChatColors.black),
    errorStyle: const TextStyle().copyWith(fontStyle: FontStyle.normal),
    floatingLabelStyle: const TextStyle().copyWith(
      color: JChatColors.black.withOpacity(0.8),
    ),
    border: const OutlineInputBorder().copyWith(
      borderSide: const BorderSide(color: JChatColors.grey, width: 1),
      borderRadius: BorderRadius.circular(14),
    ),
    enabledBorder: const OutlineInputBorder().copyWith(
      borderSide: const BorderSide(color: JChatColors.grey, width: 1),
      borderRadius: BorderRadius.circular(14),
    ),
    focusedBorder: const OutlineInputBorder().copyWith(
      borderSide: const BorderSide(color: Colors.white, width: 1),
      borderRadius: BorderRadius.circular(14),
    ),
    errorBorder: const OutlineInputBorder().copyWith(
      borderSide: const BorderSide(color: JChatColors.warning, width: 1),
      borderRadius: BorderRadius.circular(14),
    ),
    focusedErrorBorder: const OutlineInputBorder().copyWith(
      borderSide: const BorderSide(color: Colors.orange, width: 1),
      borderRadius: BorderRadius.circular(14),
    ),
  );
}
