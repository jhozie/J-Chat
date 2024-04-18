import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:iconsax/iconsax.dart';
import 'package:jchatapp/pages/chat_screen.dart';
import 'package:jchatapp/pages/chatlist_test.dart';
import 'package:jchatapp/model/friends_model.dart';
import 'package:jchatapp/services/chat/chat_service.dart';
import 'package:jchatapp/utils/constants/colours.dart';
import 'package:jchatapp/utils/constants/sizes.dart';
import 'package:jchatapp/utils/theme/custom_theme/text_theme.dart';

class ContactList extends StatefulWidget {
  const ContactList({super.key});
  @override
  State<ContactList> createState() => _ContactListState();
}

class _ContactListState extends State<ContactList> {
  final _chatService = ChatService();

  List<FriendsModel> _allFriends = [];
  List<FriendsModel> _searchedList = [];

  var _searchQuery = '';

  Timer? debounce;

  late TextEditingController _searchController;

  @override
  void initState() {
    _searchController = TextEditingController();
    super.initState();
  }

  void filteredList() {
    if (_searchQuery.isNotEmpty) {
      _searchedList = List.of(_allFriends)
          .where((friends) =>
              friends.name!.toLowerCase().contains(_searchQuery.toLowerCase()))
          .toList();
    } else {
      _searchedList = List.of(_allFriends).toList();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: const Icon(
            Iconsax.arrow_left,
            size: 25,
            color: JChatColors.black,
          ),
        ),
      ),
      body: StreamBuilder(
          stream: _chatService.getFriendsData(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return const Text('error...');
            }
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            _allFriends = snapshot.data!;
            filteredList();
            return Padding(
              padding: JChatSizes.pagePaddingAlternative,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Contacts',
                      style: JChatTextTheme.textThemeLightMode.headlineLarge),
                  JChatSizes.sizedBoxHeight,
                  TextField(
                    style: JChatTextTheme.textThemeLightMode.titleMedium,
                    controller: _searchController,
                    decoration: InputDecoration(
                        suffixIcon: const Icon(Iconsax.search_normal_1),
                        labelText: 'Search',
                        labelStyle:
                            JChatTextTheme.textThemeLightMode.labelLarge),
                    onChanged: (value) {
                      if (debounce?.isActive ?? false) debounce?.cancel();
                      debounce = Timer(Duration(seconds: 2), () {
                        setState(() {
                          _searchQuery = value;
                        });
                        filteredList();
                      });
                    },
                  ),
                  JChatSizes.sizedBoxHeight,
                  JChatSizes.sizedBoxHeight,
                  Expanded(
                    child: ListView.builder(
                      itemCount: _searchedList.length,
                      itemBuilder: (context, index) {
                        final name = _searchedList[index].name!;
                        final phone = _searchedList[index].phoneNumber!;
                        final receiverId = _searchedList[index].friendId!;
                        final profileImage = _searchedList[index].profileImage!;

                        return Column(
                          children: [
                            ContactListTile(
                              name: name,
                              phone: phone,
                              profileImage: profileImage,
                              ontap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => ChatScreen(
                                      name: name,
                                      receiverId: receiverId,
                                    ),
                                  ),
                                );
                              },
                            ),
                            const Divider(
                              height: 40,
                              color: JChatColors.grey,
                            )
                          ],
                        );
                      },
                    ),
                  ),
                ],
              ),
            );
          }),
    );
  }
}

class ContactListTile extends StatelessWidget {
  final String name;
  final String phone;
  final String profileImage;
  final Function() ontap;

  const ContactListTile({
    required this.name,
    super.key,
    required this.phone,
    required this.ontap,
    required this.profileImage,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
        titleTextStyle:
            JChatTextTheme.textThemeLightModeAlternative.headlineSmall,
        subtitleTextStyle:
            JChatTextTheme.textThemeLightModeAlternative.labelLarge,
        contentPadding: const EdgeInsets.all(0),
        leading: CircleAvatar(
          radius: 30,
          backgroundImage: NetworkImage(profileImage),
        ),
        title: Text(
          name,
          style: const TextStyle(color: JChatColors.black),
        ),
        subtitle: Text(
          phone,
          style: const TextStyle(color: JChatColors.black),
        ),
        trailing: IconButton(
            onPressed: ontap,
            icon: Container(
              height: 35,
              width: 35,
              decoration: BoxDecoration(
                  color: JChatColors.alternateBackground,
                  borderRadius: BorderRadius.circular(20)),
              child: const Icon(
                Iconsax.message,
                size: 20,
                color: JChatColors.textWhite,
              ),
            )));
  }
}
