import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:jchatapp/firebase_options.dart';
import 'package:jchatapp/pages/homepage.dart';
import 'package:jchatapp/pages/phone_number_screen.dart';
import 'package:jchatapp/route/route.dart';
import 'package:jchatapp/utils/theme/theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  // await FirebaseAppCheck.instance.activate();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: JChatTheme.lightThemeMode,
      home: Homepage(),
      routes: {
        signInPhone: (context) => PhoneNumbers(),
        // verifyOTP: (context) => const VerifyCode(verificationID: ,)
      },
    );
  }
}
