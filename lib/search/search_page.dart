import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:messenger/domain/entities/user.dart';
import 'package:messenger_app/dialogs/chat_page.dart';
import 'package:messenger_app/lang/locale_keys.g.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  SearchPageState createState() => SearchPageState();
}

class SearchPageState extends State<SearchPage> {
  List<User> _users = [];
  String searchText = '';

  void updateSearchText(String text) {
    setState(() {
      searchText = text;
      _users = allUsers.where((user) => user.name.contains(searchText)).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    final users = searchText.isEmpty ? allUsers : _users;
    return Scaffold(
      appBar: AppBar(
        title: Text(LocaleKeys.userSearch.tr()),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              onChanged: updateSearchText,
              decoration: const InputDecoration(
                prefixIcon: Icon(Icons.search),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: users.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ChatPage(user: users[index]),
                      ),
                    );
                  },
                  child: ListTile(
                    leading: Padding(
                      padding: const EdgeInsets.all(2.0),
                      child: CircleAvatar(
                        backgroundColor: users[index].isActive ? Colors.green : Colors.grey,
                        radius: 30,
                        child: users[index].photoUrl != null
                            ? Padding(
                                padding: const EdgeInsets.all(4.0),
                                child: CircleAvatar(
                                  radius: 28,
                                  backgroundImage: NetworkImage(users[index].photoUrl!),
                                ),
                              )
                            : const Icon(Icons.person),
                      ),
                    ),
                    title: Text(users[index].name),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

List<User> allUsers = [
  User(
    id: '1',
    name: 'Mark Johnson',
    email: 'mark.johnson@example.com',
    isActive: true,
    phone: '+1234567890',
    birthday: DateTime(2000, 10, 15),
    photoUrl:
        'https://henderson.ru/uimages/catalog/product/HT-0254/HT-0254-DNAVY-6-1.jpg',
  ),
  User(
    id: '2',
    name: 'Jane Smith',
    email: 'janesmith@example.com',
    isActive: false,
    phone: '+9876543210',
    birthday: DateTime(2001, 5, 20),
    photoUrl: null,
  ),
  User(
    id: '3',
    name: 'Alice Johnson',
    email: 'alicejohnson@example.com',
    isActive: false,
    phone: '+5555555555',
    birthday: DateTime(2005, 12, 1),
    photoUrl:
        'https://www.aclu.org/wp-content/uploads/2020/09/jennifer_turner_small-1000x1000-1.jpg',
  ),
  User(
    id: '4',
    name: 'Bob Williams',
    email: 'bobwilliams@example.com',
    isActive: true,
    phone: '+1111111111',
    birthday: DateTime(2006, 8, 8),
    photoUrl:
        'https://pbs.twimg.com/profile_images/891998007968837634/eItGYX1S_400x400.jpg',
  ),
  User(
    id: '5',
    name: 'Emily Davis',
    email: 'emilydavis@example.com',
    isActive: false,
    phone: '+9999999999',
    birthday: DateTime(2001, 3, 25),
    photoUrl:
        'https://www.clementscenter.org/wp-content/uploads/DavisHeadshot-scaled.jpg',
  ),
];
