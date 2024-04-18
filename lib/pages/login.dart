import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:jchatapp/utils/constants/sizes.dart';
import 'package:jchatapp/utils/constants/text_strings.dart';
import 'package:jchatapp/utils/helper_functions/helper_functions.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: JChatSizes.pagePadding,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              JChatFunctions.isDarkMode(context)
                  ? Image.asset(
                      'assets/logos/jchat-dark.png',
                      width: 150,
                    )
                  : Image.asset(
                      'assets/logos/jchat-light.png',
                      width: 150,
                    ),
              const SizedBox(height: 15),
              Text(
                JChatText.loginTitle,
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              const SizedBox(height: 15),
              Text(
                JChatText.loginSubtitle,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: 15),
              TextFormField(
                decoration: const InputDecoration(
                  prefixIcon: Icon(Iconsax.direct_right),
                  labelText: 'Email',
                ),
              ),
              const SizedBox(height: 15),
              TextFormField(
                decoration: const InputDecoration(
                    prefixIcon: Icon(Iconsax.password_check),
                    labelText: 'Password',
                    suffixIcon: Icon(Iconsax.eye_slash)),
              ),
              const SizedBox(height: 15),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Remember Me'),
                  TextButton(
                    onPressed: () {},
                    child: const Text('Forget Password?'),
                  ),
                ],
              ),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(),
                  child: const Text('Login'),
                ),
              ),
              const SizedBox(height: 15),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(),
                  child: const Text('Create Account'),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
