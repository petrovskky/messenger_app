import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:messenger_app/auth/cubit/auth_cubit.dart';
import 'package:messenger_app/lang/locale_keys.g.dart';
import 'package:messenger/domain/entities/dialog.dart' as domain;
import 'package:messenger/domain/entities/user.dart';

class DialogsPage extends StatefulWidget {
  const DialogsPage({super.key});

  @override
  DialogsPageState createState() => DialogsPageState();
}

class DialogsPageState extends State<DialogsPage> {
  List<domain.Dialog> exampleDialogs = [
    domain.Dialog(
      id: '1',
      participants: ['0', '1'],
      lastMessage: 'Увидимся в понедельник 👋',
      unreadCount: 0,
      botId: null,
    ),
    domain.Dialog(
      id: '2',
      participants: ['0', '4'],
      lastMessage: 'Okay',
      unreadCount: 5,
      botId: null,
    ),
    domain.Dialog(
      id: '3',
      participants: ['0', '3'],
      lastMessage: 'Доброе утро!',
      unreadCount: 1,
      botId: '12345',
    ),
  ];

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
      id: '0',
      name: 'Emily Davis',
      email: 'emilydavis@example.com',
      isActive: false,
      phone: '+9999999999',
      birthday: DateTime(2001, 3, 25),
      photoUrl:
          'https://www.clementscenter.org/wp-content/uploads/DavisHeadshot-scaled.jpg',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(LocaleKeys.dialogs.tr()),
      ),
      body: ListView.builder(
        itemCount: exampleDialogs.length,
        itemBuilder: (context, index) {
          final dialog = exampleDialogs[index];
          final participantIds = dialog.participants;
          final participants = allUsers
              .where((user) => participantIds.contains(user.id))
              .toList();

          return ListTile(
            leading: CircleAvatar(
              backgroundImage: NetworkImage(participants[0].photoUrl ?? ''),
            ),
            title: Text(participants[0].name),
            subtitle: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(child: Text(dialog.lastMessage ?? '')),
              ],
            ),
            trailing: dialog.unreadCount > 0
                ? Text(
                  '${dialog.unreadCount}',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14
                  ),
                )
                : null,
            onTap: () {
              // Navigate to chat page
            },
          );
        },
      ),
    );
  }
}
