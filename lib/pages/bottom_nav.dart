import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:jchatapp/utils/constants/colours.dart';

class BottomNav extends StatefulWidget {
  const BottomNav(
      {super.key, required this.selectedIndex, required this.ontapped});

  final int selectedIndex;
  final Function(int) ontapped;

  @override
  State<BottomNav> createState() => _BottomNavState();
}

class _BottomNavState extends State<BottomNav> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 70,
      decoration: BoxDecoration(boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.1),
          blurRadius: 10,
          offset: const Offset(0, -1),
        ),
      ]),
      child: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(
            icon: Icon(
              Iconsax.message,
              size: 30,
              color: JChatColors.primaryColor,
            ),
            label: 'Chats',
          ),
          // BottomNavigationBarItem(
          //     icon: Icon(
          //       Iconsax.call,
          //       size: 30,
          //       color: JChatColors.primaryColor,
          //     ),
          //     label: 'Calls'),
          BottomNavigationBarItem(
              icon: Icon(
                Iconsax.profile_2user,
                size: 30,
                color: JChatColors.primaryColor,
              ),
              label: 'Friends'),
          BottomNavigationBarItem(
              icon: Icon(
                Iconsax.setting_2,
                size: 30,
                color: JChatColors.primaryColor,
              ),
              label: 'Settings'),
        ],
        currentIndex: widget.selectedIndex,
        onTap: widget.ontapped,
        backgroundColor: JChatColors.white,
        elevation: 200,
        selectedItemColor:
            JChatColors.primaryColor, // Customize selected item color
        unselectedItemColor: Colors.black26,
        selectedLabelStyle:
            const TextStyle(fontWeight: FontWeight.bold, fontSize: 10),
        unselectedLabelStyle:
            const TextStyle(fontWeight: FontWeight.bold, fontSize: 10),
        showUnselectedLabels: true,
        showSelectedLabels: true,
      ),
    );
  }
}
