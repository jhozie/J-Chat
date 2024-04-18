import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:iconsax/iconsax.dart';
import 'package:jchatapp/pages/edit_profile.dart';
import 'package:jchatapp/services/auth/auth_service.dart';
import 'package:jchatapp/model/friends_model.dart';
import 'package:jchatapp/model/user_model.dart';
import 'package:jchatapp/services/chat/chat_service.dart';
import 'package:jchatapp/utils/constants/colours.dart';
import 'package:jchatapp/utils/constants/sizes.dart';
import 'package:jchatapp/utils/theme/custom_theme/text_theme.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});
  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final _auth = AuthService();
  final _chatService = ChatService();

  Future<void> updateFriends(List<FriendsModel> friends) async {
    for (var friend in friends) {
      // Update the friend data
      await _chatService.updateFriendsData(friend);
    }
  }

  void logOut() {
    _auth.signOut();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const Icon(
          Iconsax.arrow_left,
          color: JChatColors.black,
        ),
      ),
      body: StreamBuilder<UserModel>(
          stream: _chatService
              .getUserDetailsAsStream(_auth.auth.currentUser!.phoneNumber!),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return const Text('Error...');
            }
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            final user = snapshot.data!;
            return Padding(
              padding: JChatSizes.pagePaddingAlternative,
              child: StreamBuilder(
                  stream: _chatService.getAndUpdateFriendsData(),
                  builder: (context, friendSnapshot) {
                    if (friendSnapshot.hasError) {
                      return const Text(
                        'Error...',
                        style: TextStyle(color: Colors.black),
                      );
                    }
                    if (friendSnapshot.connectionState ==
                        ConnectionState.waiting) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                    // late FriendsModel friendNew;
                    final friends = friendSnapshot.data!;

                    return Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Settings',
                            style: JChatTextTheme
                                .textThemeLightMode.headlineLarge),
                        JChatSizes.sizedBoxHeight,
                        Row(
                          children: [
                            user.profilePicture == null
                                ? const CircleAvatar(
                                    radius: 70,
                                    backgroundColor: JChatColors.warning,
                                    child: Icon(Iconsax.gallery),
                                  )
                                : CircleAvatar(
                                    backgroundColor: JChatColors.accent,
                                    radius: 73,
                                    child: CircleAvatar(
                                      radius: 70,
                                      backgroundColor: Colors
                                          .transparent, // Set background color to transparent

                                      backgroundImage:
                                          NetworkImage(user.profilePicture!),
                                    ),
                                  ),
                            JChatSizes.sizedBoxWidth,
                            JChatSizes.sizedBoxWidth,
                            JChatSizes.sizedBoxWidth,
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  user.name!,
                                  style: JChatTextTheme
                                      .textThemeLightMode.headlineSmall,
                                ),
                                const SizedBox(height: 5),
                                Text(
                                  _auth.auth.currentUser!.phoneNumber!,
                                  style: const TextStyle(
                                      color: JChatColors.darkGrey,
                                      fontWeight: FontWeight.w500),
                                ),
                                JChatSizes.sizedBoxHeight,
                                SizedBox(
                                  width: 150,
                                  child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                          foregroundColor:
                                              JChatColors.darkerGrey,
                                          backgroundColor: JChatColors.white,
                                          shape: const RoundedRectangleBorder(
                                              side: BorderSide(
                                                  width: 2,
                                                  color: Colors.black))),
                                      onPressed: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  const EditProfile(),
                                            ));
                                      },
                                      child: const Text('Edit Profile')),
                                )
                              ],
                            )
                          ],
                        ),
                        JChatSizes.sizedBoxHeight,
                        Text(
                          'Bio',
                          style:
                              JChatTextTheme.textThemeLightMode.headlineSmall,
                        ),
                        Text(
                          user.bio!,
                          style: const TextStyle(color: JChatColors.darkGrey),
                        ),
                        JChatSizes.sizedBoxHeight,
                        JChatSizes.sizedBoxHeight,
                        Expanded(
                          child: SingleChildScrollView(
                            child: Column(
                              children: [
                                SettingsListTile(
                                  name: 'Notifications',
                                  icon: Iconsax.notification,
                                  color: JChatColors.darkGrey,
                                  textColor: JChatColors.darkGrey,
                                  ontap: () {},
                                ),
                                const Divider(
                                  height: 40,
                                  color: JChatColors.grey,
                                ),
                                SettingsListTile(
                                  name: 'Help',
                                  icon: Iconsax.support,
                                  color: JChatColors.darkGrey,
                                  textColor: JChatColors.darkGrey,
                                  ontap: () {},
                                ),
                                const Divider(
                                  height: 40,
                                  color: JChatColors.grey,
                                ),
                                SettingsListTile(
                                  name: 'Share',
                                  icon: Iconsax.share,
                                  ontap: () {},
                                ),
                                const Divider(
                                  height: 40,
                                  color: JChatColors.grey,
                                ),
                                SettingsListTile(
                                  name: 'Logout',
                                  icon: Iconsax.logout,
                                  color: const Color.fromARGB(255, 214, 13, 63),
                                  ontap: logOut,
                                ),
                                const Divider(
                                  height: 40,
                                  color: JChatColors.grey,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    );
                  }),
            );
          }),
    );
  }
}

class SettingsListTile extends StatelessWidget {
  final String name;
  final IconData icon;
  final Color? color;
  final Color textColor;
  final Function() ontap;
  const SettingsListTile({
    required this.name,
    required this.icon,
    this.color = JChatColors.alternateBackground,
    super.key,
    this.textColor = JChatColors.black,
    required this.ontap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: ontap,
      titleTextStyle:
          JChatTextTheme.textThemeLightModeAlternative.headlineSmall,
      subtitleTextStyle:
          JChatTextTheme.textThemeLightModeAlternative.labelLarge,
      contentPadding: const EdgeInsets.all(0),
      leading: SizedBox(
        height: 60,
        width: 60,
        child: IconButton(
          style: IconButton.styleFrom(
            backgroundColor: color,
          ),
          color: JChatColors.white,
          onPressed: () {},
          icon: Icon(icon),
        ),
      ),
      title: Text(
        name,
        style: TextStyle(color: textColor),
      ),
    );
  }
}
