import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:messenger/domain/entities/message.dart';
import 'package:messenger/domain/entities/user.dart';
import 'package:messenger_app/dialogs/cubit/chat_cubit.dart';
import 'package:messenger_app/dialogs/cubit/chat_state.dart';
import 'package:messenger_app/dialogs/translate_dialog.dart';
import 'package:messenger_app/lang/locale_keys.g.dart';
import 'package:messenger_app/profile/user_page.dart';

class ChatPage extends StatefulWidget {
  final User user;

  const ChatPage({super.key, required this.user});

  @override
  ChatPageState createState() => ChatPageState();
}

class ChatPageState extends State<ChatPage> {
  final messages = [];

  TextEditingController _textEditingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            CircleAvatar(
              backgroundImage: NetworkImage(widget.user.photoUrl ?? 'https://static.vecteezy.com/system/resources/previews/009/292/244/original/default-avatar-icon-of-social-media-user-vector.jpg'),
            ),
            SizedBox(width: 8),
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => UserProfilePage(user: widget.user),
                  ),
                );
              },
              child: Text(
                widget.user.name,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
      body: BlocBuilder<ChatCubit, ChatState>(
        builder: (context, state) {
          final messages = state.currentDialog?.messages ?? [];
            return Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: messages.length,
                    itemBuilder: (context, index) {
                      final message = messages[index];
                      final isUserMessage = message.isMine;
                      return GestureDetector(
                        onLongPress: () {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return TranslateDialog(originText: message.text);
                            },
                          );
                        },
                        child: Container(
                          alignment: isUserMessage
                              ? Alignment.centerRight
                              : Alignment.centerLeft,
                          child: Container(
                            padding: const EdgeInsets.all(8),
                            margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                            decoration: BoxDecoration(
                              color: isUserMessage
                                  ? const Color(0xFF008a8b)
                                  : Colors.grey,
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  message.text,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                  ),
                                ),
                                SizedBox(height: 4),
                                Text(
                                  DateFormat('yyyy-MM-dd HH:mm')
                                      .format(message.dateTime),
                                  style: TextStyle(
                                    color: Colors.white70,
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _textEditingController,
                          decoration: InputDecoration(
                            hintText: LocaleKeys.message.tr(),
                          ),
                        ),
                      ),
                      IconButton(
                        icon: Icon(Icons.send),
                        onPressed: () async {
                          String messageText = _textEditingController.text;
                          await context.read<ChatCubit>().sendMessage(widget.user.id, messageText, dialogId: state.currentDialog?.id);
                          setState(() {
                            messages.add(Message(
                              isMine: true,
                              dateTime: DateTime.now(),
                              text: messageText,
                            ));
                          });
                          _textEditingController.clear();
                        },
                      ),
                    ],
                  ),
                ),
              ],
            );
        },
      ),
    );
  }
}
