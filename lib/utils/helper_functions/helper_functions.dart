import 'package:flutter/material.dart';
import 'package:jchatapp/pages/phone_number_screen.dart';
import 'package:jchatapp/services/auth/auth_service.dart';
import 'package:jchatapp/model/friends_model.dart';
import 'package:jchatapp/model/user_model.dart';
import 'package:jchatapp/services/chat/chat_service.dart';
import 'package:jchatapp/utils/constants/colours.dart';
import 'package:jchatapp/utils/constants/sizes.dart';
import 'package:jchatapp/utils/theme/custom_theme/text_theme.dart';

class JChatFunctions {
  JChatFunctions._();

  static bool isDarkMode(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark;
  }

  // static bool isdarkMode2(BuildContext context) {
  //   return Theme.of(context).textTheme ==
  //       JChatTextTheme.textThemeLightModeAlternative;
  // }
  static final fullName = PhoneNumbers();
}

Future<void> showErrowDialog(
    BuildContext context, String title, String content) async {
  return showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Text(title),
        content: Text(content),
        actions: [
          TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Ok'))
        ],
      );
    },
  );
}

void showSnackBar(String content) {
  SnackBar(
    content: Text(content),
    backgroundColor: JChatColors.warning,
  );
}

Future<void> showErrorDialog(
  BuildContext context, {
  required String title,
  required String description,
}) {
  return showDialog(
      context: context,
      builder: ((context) {
        return Container(
          height: 30,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30),
          ),
          child: AlertDialog(
            backgroundColor: JChatColors.white,
            titleTextStyle: JChatTextTheme.textThemeLightMode.headlineSmall,
            contentTextStyle: JChatTextTheme.textThemeLightMode.titleMedium,
            title: Text(title),
            content: Text(description),
            actions: [
              TextButton(
                onPressed: (() {
                  Navigator.of(context).pop();
                }),
                child: Text(
                  'Ok',
                  style: JChatTextTheme.textThemeLightMode.titleLarge,
                ),
              ),
            ],
          ),
        );
      }));
}

StreamBuilder<List<UserModel>> addContact(BuildContext context) {
  final _chatService = ChatService();
  final _authService = AuthService();

  void addFriends(FriendsModel friends, String userId) {
    _authService.addNewFriends(context, friends, userId);
  }

  return StreamBuilder(
    stream: _chatService.allUssers(),
    builder: (context, snapshot) {
      if (snapshot.hasError) {
        return const Text('Error...');
      }
      if (snapshot.connectionState == ConnectionState.waiting) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      }
      final allUsers = snapshot.data!;

      return Padding(
        padding: JChatSizes.pagePaddingAlternative,
        child: ListView.builder(
          itemCount: allUsers.length,
          itemBuilder: (context, index) {
            return Column(
              children: [
                ListTile(
                  horizontalTitleGap: 10,
                  titleTextStyle:
                      JChatTextTheme.textThemeLightMode.headlineSmall,
                  contentPadding: const EdgeInsets.all(0),
                  leading: allUsers[index].profilePicture == null
                      ? const CircleAvatar(
                          radius: 30,
                          backgroundColor: JChatColors.warning,
                        )
                      : CircleAvatar(
                          radius: 30,
                          backgroundImage:
                              NetworkImage(allUsers[index].profilePicture!),
                        ),
                  title: Text(allUsers[index].name!),
                  subtitle: Text(
                    allUsers[index].phoneNumber!,
                    style: TextStyle(color: JChatColors.darkGrey),
                  ),
                  trailing: SizedBox(
                    height: 50,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: JChatColors.alternateBackground,
                          foregroundColor: JChatColors.white),
                      onPressed: () {
                        final userId = _authService.auth.currentUser!.uid;
                        FriendsModel friends = FriendsModel(
                          friendId: snapshot.data![index].id,
                          currentUserId: userId,
                          name: snapshot.data![index].name!,
                          phoneNumber: snapshot.data![index].phoneNumber,
                          profileImage: snapshot.data![index].profilePicture,
                        );

                        addFriends(friends, userId);
                      },
                      child: const Text("Add"),
                    ),
                  ),
                ),
                const Divider(
                  height: 40,
                  color: JChatColors.grey,
                ),
              ],
            );
          },
        ),
      );
    },
  );
}
