import 'package:flutter/material.dart';
import 'package:intl_phone_field/phone_number.dart';
import 'package:jchatapp/pages/login.dart';
import 'package:jchatapp/pages/phone_number_screen.dart';
import 'package:jchatapp/utils/constants/colours.dart';
import 'package:jchatapp/utils/constants/sizes.dart';
import 'package:jchatapp/utils/theme/custom_theme/text_theme.dart';

class GetStartedScreen extends StatefulWidget {
  const GetStartedScreen({super.key});

  @override
  State<GetStartedScreen> createState() => _GetStartedScreenState();
}

class _GetStartedScreenState extends State<GetStartedScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: JChatColors.alternateBackground,
      appBar: AppBar(),
      body: Padding(
        padding: JChatSizes.pagePaddingAlternative,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              JChatSizes.sizedBoxHeight,
              JChatSizes.sizedBoxHeight,
              JChatSizes.sizedBoxHeight,
              Center(
                child: Container(
                  child: Image.asset(
                    'assets/logos/newlogo.png',
                    width: 200,
                    fit: BoxFit.fitWidth,
                  ),
                ),
              ),
              JChatSizes.sizedBoxHeight,
              JChatSizes.sizedBoxHeight,
              JChatSizes.sizedBoxHeight,
              JChatSizes.sizedBoxHeight,
              JChatSizes.sizedBoxHeight,
              JChatSizes.sizedBoxHeight,
              JChatSizes.sizedBoxHeight,
              JChatSizes.sizedBoxHeight,
              Text(
                'Welcome to JChat Messaging App',
                style: Theme.of(context).textTheme.headlineLarge,
                textAlign: TextAlign.center,
              ),
              JChatSizes.sizedBoxHeight,
              JChatSizes.sizedBoxHeight,
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: JChatColors.white,
                      foregroundColor: JChatColors.alternateBackground),
                  onPressed: () {},
                  child: const Text('Get Started'),
                ),
              ),
              JChatSizes.sizedBoxHeight,
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                textBaseline: TextBaseline.ideographic,
                children: [
                  Text(
                    'Already a member?',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  TextButton(
                    style:
                        TextButton.styleFrom(padding: const EdgeInsets.all(5)),
                    onPressed: () {
                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => const PhoneNumbers(),
                      ));
                    },
                    child: Text(
                      'Sign in',
                      style: JChatTextTheme
                          .textThemeLightModeAlternative.titleMedium,
                    ),
                  )
                ],
              ),
            ]),
          ],
        ),
      ),
    );
  }
}
