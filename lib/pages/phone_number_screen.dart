import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:jchatapp/services/auth/auth_service.dart';
import 'package:jchatapp/utils/constants/colours.dart';
import 'package:jchatapp/utils/constants/sizes.dart';
import 'package:jchatapp/utils/exceptions/exceptions.dart';
import 'package:jchatapp/utils/helper_functions/helper_functions.dart';

class PhoneNumbers extends StatefulWidget {
  const PhoneNumbers({
    super.key,
  });

  @override
  State<PhoneNumbers> createState() => _PhoneNumbersState();
}

String phoneNumber = '';

class _PhoneNumbersState extends State<PhoneNumbers> {
  TextEditingController _phoneController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: JChatColors.alternateBackground,
      body: Padding(
        padding: JChatSizes.pagePadding,
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  JChatSizes.sizedBoxHeight,
                  JChatSizes.sizedBoxHeight,
                  Text(
                    'What\'s your Number?',
                    style: Theme.of(context).textTheme.headlineLarge,
                  ),
                  JChatSizes.sizedBoxHeight,
                  Text(
                    'We will send you a code to verify your number',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  JChatSizes.sizedBoxHeight,
                  IntlPhoneField(
                    controller: _phoneController,
                    decoration: const InputDecoration(
                      hintText: '705 2555 2035',
                      hintStyle:
                          TextStyle(fontSize: 15, color: JChatColors.grey),
                      labelStyle: TextStyle(fontSize: 15),
                    ),
                    initialCountryCode: 'NG',
                    onChanged: (value) {
                      phoneNumber = value.completeNumber;
                    },
                  ),
                ],
              ),
              JChatSizes.sizedBoxHeight,
              JChatSizes.sizedBoxHeight,
              JChatSizes.sizedBoxHeight,
              JChatSizes.sizedBoxHeight,
              JChatSizes.sizedBoxHeight,
              JChatSizes.sizedBoxHeight,
              JChatSizes.sizedBoxHeight,
              JChatSizes.sizedBoxHeight,
              JChatSizes.sizedBoxHeight,
              JChatSizes.sizedBoxHeight,
              IconButton(
                onPressed: () async {
                  try {
                    sendPhoneNumber();
                  } on InvalidPhoneNumberException {
                    await showErrorDialog(context,
                        title: 'Invalid Email',
                        description:
                            'Email provided is not valid. Please check and try again');
                  } on GenericException {
                    await showErrorDialog(context,
                        title: 'Invalid kdssksksk',
                        description:
                            'Email provided is not valid. Please check and try again');
                  }
                },
                style: IconButton.styleFrom(
                    backgroundColor: JChatColors.white,
                    padding: const EdgeInsets.all(20)),
                icon: const Icon(
                  Iconsax.arrow_right_1,
                  color: JChatColors.alternateBackground,
                  size: 40,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  void sendPhoneNumber() {
    final authService = AuthService();
    authService.signInWithPhone(context, phoneNumber);
  }
}
