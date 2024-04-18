import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconsax/iconsax.dart';
import 'package:jchatapp/pages/chat_list_screen.dart';
import 'package:jchatapp/pages/homepage.dart';
import 'package:jchatapp/services/auth/auth_service.dart';
import 'package:jchatapp/model/friends_model.dart';
import 'package:jchatapp/model/user_model.dart';
import 'package:jchatapp/services/chat/chat_service.dart';
import 'package:jchatapp/utils/constants/colours.dart';
import 'package:jchatapp/utils/constants/sizes.dart';
import 'package:jchatapp/utils/theme/theme.dart';
import 'package:provider/provider.dart';

class AddContacts extends StatefulWidget {
  const AddContacts({super.key});

  @override
  State<AddContacts> createState() => _AddContactsState();
}

class _AddContactsState extends State<AddContacts> {
  final _chatService = ChatService();
  final _authService = AuthService();

  List<UserModel> _allFriends = [];
  List<UserModel> _filteredFriends = [];

  // String searchQuery = '';
  late TextEditingController _searchController;
  Timer? _debounce;

  @override
  void initState() {
    _searchController = TextEditingController();
    _searchController.addListener(() {
      // searchQuery;
    });
    super.initState();
  }

  @override
  void dispose() {
    _debounce?.cancel();
    super.dispose();
  }

  // void _onSearchChanged() {
  //   if (_debounce?.isActive ?? false) _debounce?.cancel();
  //   _debounce = Timer(Duration(seconds: 2), () {});
  // }

  void addFriends(FriendsModel friends, String userId) {
    _authService.addNewFriends(context, friends, userId);
  }

  void filteredFriendsList(String searchQuery) {
    if (searchQuery.isNotEmpty) {
      _filteredFriends = List.of(_allFriends)
          .where((friends) =>
              friends.name!.toLowerCase().contains(searchQuery.toLowerCase()))
          .toList();
    } else {
      _filteredFriends = List.of(_allFriends);
    }
  }

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
      body: StreamBuilder(
          stream: _chatService.allUssers(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return const Text('Error somewhere');
            }
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            _allFriends = snapshot.data!;
            String searchQuery = context.watch<TestProvider>().searchQuery;

            filteredFriendsList(searchQuery);
            return Padding(
              padding: JChatSizes.pagePaddingAlternative,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Add contact',
                    style: Theme.of(context).textTheme.headlineLarge,
                  ),
                  JChatSizes.sizedBoxHeight,
                  Text(
                    'Add people who are already using the app or invite people to join',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  JChatSizes.sizedBoxHeight,
                  TextField(
                    controller: _searchController,
                    decoration: const InputDecoration(
                      suffixIcon: Icon(Iconsax.search_normal_1),
                      labelText: 'Search',
                      labelStyle: TextStyle(color: JChatColors.white),
                    ),
                    onChanged: (value) {
                      if (_debounce?.isActive ?? false) _debounce?.cancel();
                      _debounce = Timer(const Duration(seconds: 2), () {
                        context
                            .read<TestProvider>()
                            .updatedQuery(value); // Update search query
                        filteredFriendsList(
                            searchQuery); // Call your function to filter friends list
                      });
                    },
                    onTap: () {
                      // Optional: Handle onTap event
                    },
                  ),
                  JChatSizes.sizedBoxHeight,
                  JChatSizes.sizedBoxHeight,
                  Flexible(
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: _filteredFriends.length,
                      itemBuilder: (context, index) {
                        return Column(
                          children: [
                            ContactListTile(
                              name: _filteredFriends[index].name!,
                              phone: _filteredFriends[index].phoneNumber!,
                              profileImage:
                                  _filteredFriends[index].profilePicture!,
                              onTap: () {
                                final userId =
                                    _authService.auth.currentUser!.uid;
                                FriendsModel friends = FriendsModel(
                                  friendId: snapshot.data![index].id,
                                  currentUserId: userId,
                                  name: snapshot.data![index].name!,
                                  phoneNumber:
                                      snapshot.data![index].phoneNumber,
                                  profileImage:
                                      snapshot.data![index].profilePicture,
                                );

                                addFriends(friends, userId);
                              },
                            ),
                            const Divider(
                              height: 40,
                              color: JChatColors.white,
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                  Center(
                    child: Container(
                        width: double.infinity,
                        height: 65,
                        margin: const EdgeInsets.all(0),
                        child: FloatingActionButton.extended(
                            foregroundColor: JChatColors.alternateBackground,
                            backgroundColor: JChatColors.white,
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => Homepage()));
                            },
                            label: const Text(
                              'Continue',
                              style: TextStyle(
                                  fontWeight: FontWeight.w600, fontSize: 17),
                            ))),
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

  final Function() onTap;

  const ContactListTile({
    required this.name,
    super.key,
    required this.onTap,
    required this.phone,
    required this.profileImage,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      horizontalTitleGap: 10,
      titleTextStyle: Theme.of(context).textTheme.headlineSmall,
      contentPadding: const EdgeInsets.all(0),
      leading: CircleAvatar(
        radius: 30,
        backgroundImage: NetworkImage(profileImage),
      ),
      title: Text(name),
      subtitle: Text(
        phone,
        style: JChatTheme.darkThemeMode.textTheme.bodyLarge,
      ),
      trailing: SizedBox(
        height: 50,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
              backgroundColor: JChatColors.white,
              foregroundColor: JChatColors.alternateBackground),
          onPressed: onTap,
          child: const Text("Add"),
        ),
      ),
    );
  }
}

// class SearchState extends ChangeNotifier {
//   String _searchQuery = '';

//   void updatedQuery(String newQuery) {
//     _searchQuery = newQuery;
//     notifyListeners();
//   }

//   String get searchQuery => _searchQuery;
// }
