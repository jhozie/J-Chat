import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:jchatapp/pages/homepage.dart';
import 'package:jchatapp/services/auth/auth_service.dart';
import 'package:jchatapp/model/chat_model.dart';
import 'package:jchatapp/services/chat/chat_service.dart';
import 'package:jchatapp/utils/constants/colours.dart';
import 'package:jchatapp/utils/constants/sizes.dart';
import 'package:jchatapp/utils/theme/custom_theme/text_theme.dart';
import 'package:timeago/timeago.dart' as timeago;

class ChatScreen extends StatefulWidget {
  ChatScreen({
    Key? key,
    required this.name,
    required this.receiverId,
  }) : super(key: key);
  final String name;
  final String receiverId;

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

CollectionReference collectionRef =
    FirebaseFirestore.instance.collection('yourCollection');

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  final ChatService chatService = ChatService();
  final AuthService authService = AuthService();

  String receiverrId = '';
  String senderId = '';
  int unreadCount = 0;
  void sendMessage() {
    String message = _messageController.text.trim();
    if (message.isNotEmpty) {
      chatService.sendMessage1(widget.receiverId, message, widget.name);
      _messageController.clear();
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: GestureDetector(
          onTap: () {
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => Homepage()));
          },
          child: const Icon(
            Iconsax.arrow_left,
            size: 25,
            color: JChatColors.black,
          ),
        ),
        title: Text(
          widget.name,
          style: JChatTextTheme.textThemeLightMode.headlineMedium,
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: JChatSizes.pagePaddingAlternative,
        child: Column(
          children: [
            Expanded(
              child: _buildMessageList(),
            ),
            Row(
              children: [
                Expanded(
                    child: TextField(
                  controller: _messageController,
                  style: JChatTextTheme.textThemeLightMode.titleMedium,
                  keyboardType: TextInputType.text,
                  decoration: const InputDecoration(
                    hintText: 'Type something here',
                    hintStyle: TextStyle(color: JChatColors.darkGrey),
                    border: InputBorder.none,
                    filled: true,
                    fillColor: JChatColors.primaryBackground,
                  ),
                )),
                JChatSizes.sizedBoxWidth,
                SizedBox(
                  height: 60,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    onPressed: () {
                      sendMessage();
                    },
                    child: const Icon(Iconsax.send_1),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMessageList() {
    String senderId = authService.auth.currentUser!.uid;

    return StreamBuilder<List<Message>>(
      stream: chatService.getMessages(widget.receiverId, senderId),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Text(
            'Error: ${snapshot.error}',
            style: JChatTextTheme.textThemeLightMode.headlineLarge,
          );
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        List<Message> messages = snapshot.data!;
        return ListView.builder(
          itemCount: messages.length,
          itemBuilder: (context, index) {
            senderId = messages[index].senderId;
            String userid = authService.auth.currentUser!.uid;
            bool isCurrentUser = senderId == userid;
            final DateTime dateTime = messages[index].createdAt;
            String formattedTime = timeago.format(
              dateTime,
              locale: 'en_short',
              allowFromNow: true,
            );

            receiverrId = widget.receiverId;

            return Column(
              crossAxisAlignment: isCurrentUser
                  ? CrossAxisAlignment.end
                  : CrossAxisAlignment.start,
              children: [
                isCurrentUser
                    ? Container(
                        width: 270,
                        padding: const EdgeInsets.all(20),
                        decoration: const BoxDecoration(
                          color: JChatColors.softGrey,
                          borderRadius: BorderRadius.only(
                            topRight: Radius.circular(30),
                            bottomRight: Radius.zero,
                            topLeft: Radius.circular(30),
                            bottomLeft: Radius.circular(30),
                          ),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: Text(
                                messages[index].message,
                                style: JChatTextTheme
                                    .textThemeLightMode.titleMedium,
                              ),
                            ),
                            JChatSizes.sizedBoxWidth,
                            Text(
                              formattedTime,
                              style: const TextStyle(
                                  color: JChatColors.dark, fontSize: 10),
                            ),
                          ],
                        ),
                      )
                    : Container(
                        width: 270,
                        padding: const EdgeInsets.all(20),
                        decoration: const BoxDecoration(
                          color: JChatColors.accent,
                          borderRadius: BorderRadius.only(
                            topRight: Radius.circular(30),
                            bottomRight: Radius.circular(30),
                            topLeft: Radius.circular(30),
                            bottomLeft: Radius.zero,
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Expanded(
                              child: Text(
                                messages[index].message,
                                style: JChatTextTheme
                                    .textThemeDarkMode.titleMedium,
                              ),
                            ),
                            Text(
                              formattedTime,
                              style: const TextStyle(
                                  color: JChatColors.white, fontSize: 10),
                            )
                          ],
                        ),
                      ),
                JChatSizes.sizedBoxHeight
              ],
            );
          },
        );
      },
    );
  }
}
