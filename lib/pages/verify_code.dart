import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:iconsax/iconsax.dart';
import 'package:jchatapp/pages/name_screen.dart';
import 'package:jchatapp/pages/phone_number_screen.dart';
import 'package:jchatapp/services/auth/auth_service.dart';
import 'package:jchatapp/utils/constants/colours.dart';
import 'package:jchatapp/utils/constants/sizes.dart';
import 'package:jchatapp/utils/theme/custom_theme/text_theme.dart';

class VerifyCode extends StatefulWidget {
  const VerifyCode({
    super.key,
    required this.verificationId,
  });

  final String verificationId;

  @override
  State<VerifyCode> createState() => _VerifyCodeState();
}

class _VerifyCodeState extends State<VerifyCode> {
  final authservice = AuthService();

  String? otpCode;
  String? code1;
  String? code2;
  String? code3;
  String? code4;
  String? code5;
  String? code6;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: JChatColors.alternateBackground,
      appBar: AppBar(
        leading: const Icon(
          Iconsax.arrow_left,
          color: JChatColors.white,
        ),
      ),
      body: Padding(
        padding: JChatSizes.pagePadding,
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'What\'s the code?',
                    style: JChatTextTheme
                        .textThemeLightModeAlternative.headlineLarge,
                  ),
                  JChatSizes.sizedBoxHeight,
                  Row(
                    textBaseline: TextBaseline.ideographic,
                    children: [
                      Text(
                        'Enter the code we\'ve sent to',
                        style: JChatTextTheme
                            .textThemeLightModeAlternative.bodyMedium,
                      ),
                      const SizedBox(width: 5),
                      Text(
                        phoneNumber,
                        style: JChatTextTheme
                            .textThemeLightModeAlternative.titleMedium,
                      ),
                    ],
                  ),
                  JChatSizes.sizedBoxHeight,
                  Row(
                    children: [
                      SizedBox(
                        height: 54,
                        width: 50,
                        child: TextFormField(
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.headlineMedium,
                          onChanged: (value) {
                            code1 = value;
                            if (code1!.length == 1) {
                              FocusScope.of(context).nextFocus();
                            }
                          },
                          keyboardType: TextInputType.phone,
                          inputFormatters: [
                            LengthLimitingTextInputFormatter(1),
                            FilteringTextInputFormatter.digitsOnly,
                          ],
                        ),
                      ),
                      JChatSizes.sizedBoxWidth,
                      SizedBox(
                        height: 54,
                        width: 50,
                        child: TextFormField(
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.headlineMedium,
                          onChanged: (value) {
                            code2 = value;
                            if (code2!.length == 1) {
                              FocusScope.of(context).nextFocus();
                            }
                          },
                          keyboardType: TextInputType.phone,
                          inputFormatters: [
                            LengthLimitingTextInputFormatter(1),
                            FilteringTextInputFormatter.digitsOnly,
                          ],
                        ),
                      ),
                      JChatSizes.sizedBoxWidth,
                      SizedBox(
                        height: 54,
                        width: 50,
                        child: TextFormField(
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.headlineMedium,
                          onChanged: (value) {
                            code3 = value;
                            if (code3!.length == 1) {
                              FocusScope.of(context).nextFocus();
                            }
                          },
                          keyboardType: TextInputType.phone,
                          inputFormatters: [
                            LengthLimitingTextInputFormatter(1),
                            FilteringTextInputFormatter.digitsOnly,
                          ],
                        ),
                      ),
                      JChatSizes.sizedBoxWidth,
                      SizedBox(
                        height: 54,
                        width: 50,
                        child: TextFormField(
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.headlineMedium,
                          onChanged: (value) {
                            code4 = value;
                            if (code4!.length == 1) {
                              FocusScope.of(context).nextFocus();
                            }
                          },
                          keyboardType: TextInputType.phone,
                          inputFormatters: [
                            LengthLimitingTextInputFormatter(1),
                            FilteringTextInputFormatter.digitsOnly,
                          ],
                        ),
                      ),
                      JChatSizes.sizedBoxWidth,
                      SizedBox(
                        height: 54,
                        width: 50,
                        child: TextFormField(
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.headlineMedium,
                          onChanged: (value) {
                            code5 = value;
                            if (code5!.length == 1) {
                              FocusScope.of(context).nextFocus();
                            }
                          },
                          keyboardType: TextInputType.phone,
                          inputFormatters: [
                            LengthLimitingTextInputFormatter(1),
                            FilteringTextInputFormatter.digitsOnly,
                          ],
                        ),
                      ),
                      JChatSizes.sizedBoxWidth,
                      SizedBox(
                        height: 54,
                        width: 50,
                        child: TextFormField(
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.headlineMedium,
                          onChanged: (value) {
                            code6 = value;
                            if (code6!.length == 1) {
                              FocusScope.of(context).nextFocus();
                            }
                          },
                          keyboardType: TextInputType.phone,
                          inputFormatters: [
                            LengthLimitingTextInputFormatter(1),
                            FilteringTextInputFormatter.digitsOnly,
                          ],
                        ),
                      ),
                      JChatSizes.sizedBoxWidth,
                    ],
                  ),
                  JChatSizes.sizedBoxHeight,
                  Row(
                    textBaseline: TextBaseline.ideographic,
                    children: [
                      Text(
                        'Did\'nt recieve code?',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      TextButton(
                        style: TextButton.styleFrom(padding: EdgeInsets.all(5)),
                        onPressed: () {
                          resendOTP(context, phoneNumber);
                        },
                        child: Text(
                          'Send again',
                          style: JChatTextTheme
                              .textThemeLightModeAlternative.titleMedium,
                        ),
                      )
                    ],
                  )
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
                onPressed: () {
                  setState(() {
                    otpCode = '$code1$code2$code3$code4$code5$code6';
                    if (otpCode != null) {
                      verifyOtp(context, otpCode!);
                    } else {
                      // const SnackBar(content: Text('Provide 6 digit OTP'));
                    }
                  });
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

  void verifyOtp(BuildContext context, String otpCode) {
    authservice.verifyOtpCode(
      context: context,
      verificationId: widget.verificationId,
      optCode: otpCode,
      onSuccess: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const FullName(),
          ),
        );
      },
    );
  }

  void resendOTP(BuildContext context, String phoneUmber) {
    authservice.resendOTP(context, phoneNumber);
  }
}
