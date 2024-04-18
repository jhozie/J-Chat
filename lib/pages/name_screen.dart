import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:jchatapp/pages/add_contact_screen.dart';
import 'package:jchatapp/services/auth/auth_service.dart';
import 'package:jchatapp/model/user_model.dart';
import 'package:jchatapp/utils/constants/colours.dart';
import 'package:jchatapp/utils/constants/sizes.dart';

class FullName extends StatefulWidget {
  const FullName({super.key});

  @override
  State<FullName> createState() => _FullNameState();
}

class _FullNameState extends State<FullName> {
  final authService = AuthService();

  TextEditingController _fullNameController = TextEditingController();
  final _auth = AuthService();
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
                    'What\'s your name?',
                    style: Theme.of(context).textTheme.headlineLarge,
                  ),
                  JChatSizes.sizedBoxHeight,
                  Text(
                    'Provide your fullname or nickname',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  JChatSizes.sizedBoxHeight,
                  TextFormField(
                    controller: _fullNameController,
                    decoration: const InputDecoration(
                        prefixIcon: Icon(Iconsax.direct_right),
                        labelText: 'Name',
                        labelStyle:
                            TextStyle(color: JChatColors.grey, fontSize: 15)),
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
                    final phone = _auth.auth.currentUser!.phoneNumber;
                    final userId = _auth.auth.currentUser!.uid;
                    final photoURL = _auth.auth.currentUser!.photoURL;
                    final user = UserModel(
                      documentId: '',
                      profilePicture: photoURL ??
                          'https://t4.ftcdn.net/jpg/00/64/67/63/360_F_64676383_LdbmhiNM6Ypzb3FM4PPuFP9rHe7ri8Ju.jpg',
                      bio: 'I am available for a chat',
                      id: userId,
                      name: _fullNameController.text.trim(),
                      phoneNumber: phone,
                    );
                    createUserData(context, user);

                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const AddContacts(),
                        ));
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

  void createUserData(BuildContext context, UserModel user) {
    authService.createUserData(context, user);
  }
}
