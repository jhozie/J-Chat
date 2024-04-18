import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:jchatapp/pages/add_contact_screen.dart';
import 'package:jchatapp/pages/bottom_nav.dart';
import 'package:jchatapp/pages/chatlist_test.dart';
import 'package:jchatapp/pages/contacts_screen.dart';
import 'package:jchatapp/pages/get_started.dart';
import 'package:jchatapp/pages/phone_number_screen.dart';
import 'package:jchatapp/pages/settings.dart';
import 'package:jchatapp/pages/user_profile.dart';
import 'package:provider/provider.dart';

class Homepage extends StatefulWidget {
  Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  var _selectedIndex = 0;

  final List<Widget> _pages = [
    const CList(),
    const ContactList(),
    const SettingsScreen(),
  ];

  void onTappedIndex(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  final _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (BuildContext context) => TestProvider(),
      child: Scaffold(
        body: StreamBuilder(
          stream: _auth.authStateChanges(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return _pages[context.watch<TestProvider>().index];
            } else {
              return GetStartedScreen();
            }
          },
        ),
        bottomNavigationBar: StreamBuilder(
          stream: _auth.authStateChanges(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const SizedBox();
            }
            if (snapshot.hasData) {
              return BottomNav(
                selectedIndex: context.watch<TestProvider>().index,
                ontapped: context.read<TestProvider>().changed,
              );
            } else {
              return const SizedBox();
            }
          },
        ),
      ),
    );
  }
}

class TestProvider extends ChangeNotifier {
  int _index = 0;

  void changed(int data) {
    _index = data;
    notifyListeners();
  }

  int get index => _index;

  String _searchQuery = '';
  String _searchQuery2 = '';

  void updatedQuery(String newQuery) {
    _searchQuery = newQuery;
    notifyListeners();
  }

  String get searchQuery => _searchQuery;

  void updatedQuery2(String newQuery) {
    _searchQuery2 = newQuery;
    notifyListeners();
  }

  String get searchQuery2 => _searchQuery2;
}
