import 'dart:io';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:jchatapp/services/auth/auth_service.dart';
import 'package:jchatapp/model/user_model.dart';
import 'package:jchatapp/services/chat/chat_service.dart';
import 'package:jchatapp/utils/constants/colours.dart';
import 'package:jchatapp/utils/constants/sizes.dart';
import 'package:jchatapp/utils/theme/custom_theme/text_theme.dart';

class EditProfile extends StatefulWidget {
  const EditProfile({super.key});
  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  final chatService = ChatService();
  final auth = AuthService();

  File? image;
  String profileImage = '';
  void selectImage() async {
    image = await auth.pickImage(context);
    setState(() {});
  }

  Future<UserModel> getUser() async {
    final phoneNumber = auth.auth.currentUser!.phoneNumber!;
    return chatService.getUserDetails(phoneNumber);
  }

  updateUserDetails(UserModel user, String photoURL) {
    chatService.updateUserDetails(user, photoURL);
  }

  Future<void> updateFriendsDetails(
      Map<String, dynamic> friendData, String currentUserId) async {
    await chatService.updateFriendsList(friendData, currentUserId);
  }

  Future<void> storeData() async {
    if (image != null) {
      // final userId = auth.auth.currentUser!.uid;
      final url = await auth.uploadImage(
          '${image!.path.split('/').first}/profile_pictures/${image!.path.split('/').last}',
          image!);
      profileImage = url;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(
            Iconsax.arrow_left,
            color: JChatColors.black,
          ),
        ),
      ),
      body: StreamBuilder(
          stream: chatService
              .getUserDetailsAsStream(auth.auth.currentUser!.phoneNumber!),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            final user = snapshot.data!;
            final name = TextEditingController(text: user.name);
            final phone = TextEditingController(text: user.phoneNumber);
            final bio = TextEditingController(text: user.bio);
            return Padding(
              padding: JChatSizes.pagePaddingAlternative,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Edit Profile',
                      style: JChatTextTheme.textThemeLightMode.headlineLarge),
                  JChatSizes.sizedBoxHeight,
                  Stack(children: [
                    (image == null)
                        ? Center(
                            child: CircleAvatar(
                              backgroundColor: JChatColors.accent,
                              radius: 63,
                              child: CircleAvatar(
                                radius: 60,
                                backgroundImage:
                                    NetworkImage(user.profilePicture!),
                              ),
                            ),
                          )
                        : Center(
                            child: CircleAvatar(
                              radius: 60,
                              backgroundImage: FileImage(image!),
                            ),
                          ),
                    Positioned(
                      bottom: 10,
                      left: 200,
                      child: GestureDetector(
                        onTap: selectImage,
                        child: Container(
                          decoration: BoxDecoration(
                              color: JChatColors.white,
                              borderRadius: BorderRadius.circular(20)),
                          width: 40,
                          height: 30,
                          child: const Icon(Iconsax.gallery_add),
                        ),
                      ),
                    )
                  ]),
                  JChatSizes.sizedBoxHeight,
                  JChatSizes.sizedBoxHeight,
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Name',
                            style:
                                JChatTextTheme.textThemeLightMode.headlineSmall,
                          ),
                          const SizedBox(height: 10),
                          EditProfileTextField(
                            controller: name,
                          ),
                          JChatSizes.sizedBoxHeight,
                          Text(
                            'Phone Number',
                            style:
                                JChatTextTheme.textThemeLightMode.headlineSmall,
                          ),
                          const SizedBox(height: 10),
                          EditProfileTextField(
                            controller: phone,
                          ),
                          JChatSizes.sizedBoxHeight,
                          Text(
                            'Bio',
                            style:
                                JChatTextTheme.textThemeLightMode.headlineSmall,
                          ),
                          const SizedBox(height: 10),
                          EditProfileTextField(
                            controller: bio,
                          ),
                          JChatSizes.sizedBoxHeight,
                          JChatSizes.sizedBoxHeight,
                          JChatSizes.sizedBoxHeight,
                          SizedBox(
                            width: double.infinity,
                            height: 65,
                            child: ElevatedButton(
                              onPressed: () async {
                                await storeData();

                                final users = UserModel(
                                    documentId: user.documentId,
                                    id: user.id,
                                    name: name.text,
                                    phoneNumber: phone.text,
                                    profilePicture: image != null
                                        ? profileImage
                                        : user.profilePicture,
                                    bio: bio.text);

                                final friends = {
                                  'name': name.text,
                                  'profilelmage': profileImage
                                };
                                updateUserDetails(users, profileImage);
                                await updateFriendsDetails(
                                    friends, auth.auth.currentUser!.uid);
                              },
                              style: ElevatedButton.styleFrom(),
                              child: const Text('Save Profile'),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          }),
    );
  }
}

class EditProfileTextField extends StatelessWidget {
  const EditProfileTextField({
    super.key,
    required this.controller,
  });

  final TextEditingController controller;
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      style: JChatTextTheme.textThemeLightMode.titleMedium,
      decoration: const InputDecoration(
        border:
            OutlineInputBorder(borderSide: BorderSide(color: JChatColors.dark)),
        hintText: 'Joe Doe',
        hintStyle: TextStyle(color: JChatColors.darkGrey, fontSize: 15),
        enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: JChatColors.dark,
            ),
            borderRadius: BorderRadius.all(Radius.circular(12))),
      ),
    );
  }
}
