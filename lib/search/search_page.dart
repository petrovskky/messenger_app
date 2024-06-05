import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:messenger_app/dialogs/chat_page.dart';
import 'package:messenger_app/dialogs/cubit/chat_cubit.dart';
import 'package:messenger_app/dialogs/cubit/chat_state.dart';
import 'package:messenger_app/lang/locale_keys.g.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({Key? key}) : super(key: key);

  @override
  SearchPageState createState() => SearchPageState();
}

class SearchPageState extends State<SearchPage> {
  String searchText = '';

  void updateSearchText(String text) {
    setState(() {
      searchText = text;
    });
  }

  @override
  Widget build(BuildContext context) {
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
            child: BlocBuilder<ChatCubit, ChatState>(
              builder: (context, state) {
                final users = searchText.isEmpty
                    ? state.users
                    : state.users
                        .where((user) => user.name.contains(searchText))
                        .toList();
                return ListView.builder(
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
                            backgroundColor: users[index].isActive
                                ? Colors.green
                                : Colors.grey,
                            radius: 30,
                            child: users[index].photoUrl != null
                                ? Padding(
                                    padding: const EdgeInsets.all(4.0),
                                    child: CircleAvatar(
                                      radius: 28,
                                      backgroundImage:
                                          NetworkImage(users[index].photoUrl!),
                                    ),
                                  )
                                : const Icon(Icons.person),
                          ),
                        ),
                        title: Text(users[index].name),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
