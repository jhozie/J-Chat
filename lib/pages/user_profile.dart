import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:jchatapp/pages/settings.dart';
import 'package:jchatapp/services/auth/auth_service.dart';
import 'package:jchatapp/services/chat/chat_service.dart';
import 'package:jchatapp/utils/constants/colours.dart';
import 'package:jchatapp/utils/constants/sizes.dart';
import 'package:jchatapp/utils/helper_functions/helper_functions.dart';
import 'package:jchatapp/utils/theme/custom_theme/text_theme.dart';

class UserProfile extends StatefulWidget {
  const UserProfile({
    super.key,
    this.receiverId = '',
  });

  final String receiverId;

  @override
  State<UserProfile> createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
  final _chatService = ChatService();
  final _authService = AuthService();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const Text(''),
      ),
      backgroundColor: JChatColors.alternateBackground,
      body: StreamBuilder(
          stream: _chatService.getFriendsData(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return const Text(
                'error...',
                style: TextStyle(color: Colors.black),
              );
            }
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            return Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Center(
                  child: CircleAvatar(
                    backgroundColor: JChatColors.warning,
                    radius: 73,
                    child: CircleAvatar(
                      radius: 70,
                      backgroundImage: NetworkImage(
                          'https://t4.ftcdn.net/jpg/00/64/67/63/360_F_64676383_LdbmhiNM6Ypzb3FM4PPuFP9rHe7ri8Ju.jpg'),
                    ),
                  ),
                ),
                Center(
                  child: Text('Message',
                      style: JChatTextTheme.textThemeDarkMode.headlineLarge),
                ),
                JChatSizes.sizedBoxHeight,
                Container(
                    padding: const EdgeInsets.all(20),
                    decoration: const BoxDecoration(
                        color: JChatColors.white,
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(20),
                            topRight: Radius.circular(20))),
                    height: MediaQuery.of(context).size.height * 0.4,
                    child: ListTile(
                      titleTextStyle: JChatTextTheme
                          .textThemeLightModeAlternative.headlineSmall,
                      subtitleTextStyle: JChatTextTheme
                          .textThemeLightModeAlternative.labelLarge,
                      contentPadding: const EdgeInsets.all(0),
                      leading: SizedBox(
                        height: 60,
                        width: 60,
                        child: IconButton(
                          style: IconButton.styleFrom(
                            backgroundColor: JChatColors.alternateBackground,
                          ),
                          color: JChatColors.white,
                          onPressed: () {},
                          icon: const Icon(Iconsax.add),
                        ),
                      ),
                      title: const Text(
                        'Phone Number',
                        style: TextStyle(color: Colors.black),
                      ),
                      subtitle: const Text(
                        'name',
                        style: TextStyle(color: Colors.black),
                      ),
                    ))
              ],
            );
          }),
    );
  }
}
