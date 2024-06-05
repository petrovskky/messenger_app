import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:messenger_app/auth/cubit/auth_cubit.dart';
import 'package:messenger_app/dialogs/chat_page.dart';
import 'package:messenger_app/dialogs/cubit/chat_cubit.dart';
import 'package:messenger_app/dialogs/cubit/chat_state.dart';
import 'package:messenger_app/lang/locale_keys.g.dart';
import 'package:messenger/domain/entities/dialog.dart' as domain;
import 'package:messenger/domain/entities/user.dart';

class DialogsPage extends StatefulWidget {
  const DialogsPage({super.key});

  @override
  DialogsPageState createState() => DialogsPageState();
}

class DialogsPageState extends State<DialogsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(LocaleKeys.dialogs.tr()),
      ),
      body: BlocBuilder<ChatCubit, ChatState>(
        builder: (context, state) {
          final dialogs = state.dialogs;
            final allUsers = state.users;

            return ListView.builder(
              itemCount: dialogs.length,
              itemBuilder: (context, index) {
                final dialog = dialogs[index];
                final participantIds = dialog.participants;
                final participants = allUsers
                    .where((user) => participantIds.contains(user.id))
                    .toList();

                return ListTile(
                  leading: CircleAvatar(
                    backgroundImage: NetworkImage(participants[1].photoUrl ?? ''),
                  ),
                  title: Text(participants[1].name),
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
                            fontSize: 14,
                          ),
                        )
                      : null,
                  onTap: () {
                    context.read<ChatCubit>().openDialog(dialog.id);
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ChatPage(user: participants[1],),
                        ),
                      );
                  },
                );
              },
            );
        },
      ),
    );
  }
}
