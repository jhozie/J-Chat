import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:jchatapp/pages/chat_screen.dart';
import 'package:jchatapp/model/friends_model.dart';
import 'package:jchatapp/model/chat_model.dart';
import 'package:jchatapp/services/chat/chat_service.dart';
import 'package:jchatapp/utils/constants/colours.dart';
import 'package:jchatapp/utils/constants/sizes.dart';
import 'package:jchatapp/utils/theme/custom_theme/text_theme.dart';
import 'package:timeago/timeago.dart' as timeago;

class ChatList extends StatefulWidget {
  const ChatList({super.key, this.receiverId = ''});

  final String receiverId;

  @override
  State<ChatList> createState() => _ChatListState();
}

class _ChatListState extends State<ChatList> {
  final _chatService = ChatService();

  List<FriendsModel> _allFriends = [];
  List<FriendsModel> _searchList = [];
  String searchQuery = '';
  late TextEditingController _searchController;

  Timer? _debounce;

  @override
  void initState() {
    _searchController = TextEditingController();
    _searchController.addListener(() {
      searchQuery;
    });
    super.initState();
  }

  filteredList() {
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
      String id, String receiverId, String senderId) async {
    // await _chatService.clearMessageCount(id, receiverId, senderId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: SizedBox(
        width: 80,
        height: 80,
        child: FloatingActionButton(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(40)),
          mini: false,
          onPressed: () {
            // showModalBottomSheet(
            //     backgroundColor: Colors.white,
            //     context: context,
            //     builder: (BuildContext context) {
            //       return Container();
            //     });

            FirebaseAuth.instance.signOut();
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
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            if (snapshot.hasError) {
              return const Text(
                'Error',
              );
            }

            _allFriends = snapshot.data!;
            filteredList();
            return Padding(
              padding: JChatSizes.pagePadding,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Messages',
                      style: JChatTextTheme.textThemeLightMode.headlineLarge),
                  JChatSizes.sizedBoxHeight,
                  TextField(
                    controller: _searchController,
                    style: JChatTextTheme.textThemeLightMode.titleMedium,
                    decoration: InputDecoration(
                        suffixIcon: const Icon(Iconsax.search_normal_1),
                        labelText: 'Search',
                        labelStyle:
                            JChatTextTheme.textThemeLightMode.labelLarge),
                    onChanged: (value) {
                      if (_debounce?.isActive ?? false) _debounce?.cancel();
                      _debounce = Timer(Duration(seconds: 3), () {
                        setState(() {
                          searchQuery = value;
                        });
                        filteredList();
                      });
                    },
                  ),
                  JChatSizes.sizedBoxHeight,
                  JChatSizes.sizedBoxHeight,
                  Expanded(
                    child: ListView.builder(
                      itemCount: _searchList.length,
                      itemBuilder: (context, index) {
                        final friendName = _searchList[index].name!;
                        final friendId = _searchList[index].friendId!;
                        final idd = FirebaseAuth.instance.currentUser!.uid;

                        return StreamBuilder(
                          stream: _chatService.getLatestMessageStream(
                              friendId, idd),
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
                              return Column(
                                children: [
                                  ChatListTile(
                                    latestMessage: latestMessage,
                                    latestTime: formattedTime,
                                    profileImage: '',
                                    ontap: () {
                                      // clearMessageCount(
                                      //     docId, widget.receiverId, senderId);
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => ChatScreen(
                                            name: friendName,
                                            receiverId: friendId,
                                          ),
                                        ),
                                      );
                                    },
                                    name: friendName,
                                  ),
                                  const Divider(
                                    height: 40,
                                    color: JChatColors.grey,
                                  ),
                                ],
                              );
                            }
                          },
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

class ChatListTile extends StatelessWidget {
  final String name;
  final Function() ontap;
  final String latestMessage;
  final String latestTime;
  final String profileImage;
  const ChatListTile({
    required this.name,
    super.key,
    required this.ontap,
    this.latestMessage = '',
    this.latestTime = '',
    required this.profileImage,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () {
        ontap();
      },
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
        latestMessage,
        style: const TextStyle(color: JChatColors.black),
      ),
      trailing: Column(
        children: [
          Text(latestTime),
          const SizedBox(height: 10),
          Container(
            width: 30,
            height: 30,
            padding: const EdgeInsets.all(8.0),
            decoration: BoxDecoration(
              color: JChatColors.alternateBackground,
              borderRadius: BorderRadius.circular(20.0),
            ),
            child: const Text(
              '1',
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 10),
            ),
          ),
        ],
      ),
    );
  }
}
