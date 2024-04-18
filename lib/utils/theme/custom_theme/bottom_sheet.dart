import 'package:flutter/material.dart';
import 'package:jchatapp/utils/constants/colours.dart';

class JChatBSheet {
  JChatBSheet._();

  static BottomSheetThemeData lightBottomSheet = BottomSheetThemeData(
    backgroundColor: JChatColors.white,
    modalBackgroundColor: JChatColors.white,
    showDragHandle: true,
    constraints: const BoxConstraints(minWidth: double.infinity),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
  );

  static BottomSheetThemeData darkBottomSheet = BottomSheetThemeData(
      showDragHandle: true,
      backgroundColor: JChatColors.black,
      modalBackgroundColor: JChatColors.black,
      constraints: const BoxConstraints(minWidth: double.infinity),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)));
}
