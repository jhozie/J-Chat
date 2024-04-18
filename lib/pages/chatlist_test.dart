import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconsax/iconsax.dart';
// ignore: unused_import
import 'package:jchatapp/pages/add_contact_screen.dart';
import 'package:jchatapp/pages/chat_screen.dart';
import 'package:jchatapp/pages/homepage.dart';
import 'package:jchatapp/services/auth/auth_service.dart';
import 'package:jchatapp/model/friends_model.dart';
import 'package:jchatapp/services/chat/chat_service.dart';
import 'package:jchatapp/utils/constants/colours.dart';
import 'package:jchatapp/utils/constants/sizes.dart';
import 'package:jchatapp/utils/helper_functions/helper_functions.dart';
import 'package:jchatapp/utils/theme/custom_theme/text_theme.dart';
import 'package:timeago/timeago.dart' as timeago;

class CList extends StatefulWidget {
  const CList({
    super.key,
    this.receiverId = '',
  });

  final String receiverId;

  @override
  State<CList> createState() => _CListState();
}

class _CListState extends State<CList> {
  final _chatService = ChatService();
  final _authService = AuthService();

  List<FriendsModel> _allFriends = [];
  List<FriendsModel> _searchList = [];
  late TextEditingController _searchController;

  Timer? _debounce;

  @override
  void initState() {
    _searchController = TextEditingController();

    super.initState();
  }

  filteredList(String searchQuery) {
    if (searchQuery.isNotEmpty) {
      _searchList = List.of(_allFriends)
          .where((friends) =>
              friends.name!.toLowerCase().contains(searchQuery.toLowerCase()))
          .toList();
    } else {
      _searchList = List.of(_allFriends);
    }
  }

  Future<void> clearMessageCount(
      String receiverId, String currentUserId) async {
    await _chatService.clearCount(receiverId, currentUserId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Text(''),
      ),
      floatingActionButton: SizedBox(
        width: 80,
        height: 80,
        child: FloatingActionButton(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(40)),
          mini: false,
          onPressed: () {
            showModalBottomSheet(
                isScrollControlled: true,
                backgroundColor: Colors.white,
                context: context,
                builder: (BuildContext context) {
                  return Container(
                      height: MediaQuery.of(context).size.height * 0.8,
                      child: addContact(context));
                });
          },
          child: const Icon(
            Iconsax.message,
            size: 30,
          ),
        ),
      ),
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

            _allFriends = snapshot.data!;
            String searchQuery = context.watch<TestProvider>().searchQuery2;
            filteredList(searchQuery);
            return Padding(
              padding: JChatSizes.pagePaddingAlternative,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Message',
                      style: JChatTextTheme.textThemeLightMode.headlineLarge),
                  JChatSizes.sizedBoxHeight,
                  TextField(
                    controller: _searchController,
                    style: JChatTextTheme.textThemeLightMode.titleMedium,
                    decoration: InputDecoration(
                      suffixIcon: const Icon(Iconsax.search_normal_1),
                      labelText: 'Search',
                      labelStyle: JChatTextTheme.textThemeLightMode.labelLarge,
                    ),
                    onChanged: (value) {
                      if (_debounce?.isActive ?? false) _debounce?.cancel();
                      _debounce = Timer(const Duration(seconds: 2), () {
                        context
                            .read<TestProvider>()
                            .updatedQuery2(value); // Update search query
                        filteredList(
                            searchQuery); // Call your function to filter friends list
                      });
                    },
                  ),
                  JChatSizes.sizedBoxHeight,
                  JChatSizes.sizedBoxHeight,
                  Expanded(
                    child: ListView.builder(
                      itemCount: _searchList.length,
                      itemBuilder: (context, index) {
                        final name = _searchList[index].name!;
                        final receiverId = _searchList[index].friendId!;
                        final userId = _searchList[index].currentUserId!;
                        final profileImage =
                            _authService.auth.currentUser!.photoURL;
                        final profileImage2 = _searchList[index].profileImage!;
                        final currentUserId =
                            _authService.auth.currentUser!.uid;

                        return StreamBuilder(
                            stream: _chatService.getLatestMessageStream(
                                userId, receiverId),
                            builder: (context, messageSnapshot) {
                              if (messageSnapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return Container();
                              }
                              if (messageSnapshot.hasError) {
                                return Text('Error: ${messageSnapshot.error}');
                              } else {
                                final latestMessage =
                                    messageSnapshot.data!.message;
                                final DateTime latestTime =
                                    messageSnapshot.data!.createdAt;

                                final formattedTime = timeago.format(
                                  latestTime,
                                  locale: 'en_short',
                                  allowFromNow: true,
                                );
                                return FutureBuilder(
                                    future: _chatService.getCounts(
                                        receiverId, currentUserId),
                                    builder: (context, unreadCountsnapshot) {
                                      if (unreadCountsnapshot.connectionState ==
                                          ConnectionState.waiting) {
                                        return Container();
                                      }
                                      if (unreadCountsnapshot.hasError) {
                                        return Text(
                                            'Error: ${unreadCountsnapshot.error}');
                                      }
                                      return Column(
                                        children: [
                                          ContactListTile(
                                            receiverId: userId,
                                            currentUserId: currentUserId,
                                            name: name,
                                            latesMessage: latestMessage,
                                            latestTime: formattedTime,
                                            profileImage: profileImage2,
                                            unreadCount:
                                                unreadCountsnapshot.data!,
                                            ontap: () {
                                              clearMessageCount(
                                                  receiverId, currentUserId);
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      ChatScreen(
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
                                    });
                              }
                            });
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
  final String latesMessage;
  final String latestTime;
  final String profileImage;
  final int unreadCount;
  final String receiverId;
  final String currentUserId;
  final Function() ontap;

  const ContactListTile({
    required this.name,
    super.key,
    required this.latesMessage,
    required this.ontap,
    required this.latestTime,
    required this.profileImage,
    required this.unreadCount,
    required this.receiverId,
    required this.currentUserId,
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
      leading: CircleAvatar(
        radius: 30,
        backgroundImage: NetworkImage(profileImage),
      ),
      title: Text(
        name,
        style: const TextStyle(color: JChatColors.black),
      ),
      subtitle: Text(
        latesMessage,
        style: const TextStyle(color: JChatColors.black),
      ),
      trailing: Column(
        children: [
          Text(latestTime),
          const SizedBox(height: 10),
          unreadCount != 0
              ? Container(
                  width: 30,
                  height: 30,
                  padding: const EdgeInsets.all(8.0),
                  decoration: BoxDecoration(
                    color: JChatColors.alternateBackground,
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  child: Text(
                    unreadCount.toString(),
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 10),
                  ),
                )
              : SizedBox()
        ],
      ),
    );
  }
}
