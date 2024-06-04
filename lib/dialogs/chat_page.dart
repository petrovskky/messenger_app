import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:messenger/domain/entities/user.dart';
import 'package:messenger_app/dialogs/translate_dialog.dart';
import 'package:messenger_app/profile/user_page.dart';

import 'dart:convert';
import 'package:http/http.dart' as http;

class ChatPage extends StatefulWidget {
  final User user;

  const ChatPage({super.key, required this.user});

  @override
  ChatPageState createState() => ChatPageState();
}

class ChatPageState extends State<ChatPage> {
  final messages = [
    Message(
      dateTime: DateTime.now().subtract(Duration(hours: 2)),
      text: 'Какие планы на выходные?',
      userImage:
          'https://images.pexels.com/photos/91227/pexels-photo-91227.jpeg',
    ),
    Message(
      dateTime: DateTime.now().subtract(Duration(hours: 1)),
      text: 'Я думаю пойти в поход.',
      userImage:
          'https://henderson.ru/uimages/catalog/product/HT-0254/HT-0254-DNAVY-6-1.jpg',
    ),
    Message(
      dateTime: DateTime.now(),
      text: 'Звучит замечательно! Может, присоединюсь к тебе.',
      userImage:
          'https://images.pexels.com/photos/91227/pexels-photo-91227.jpeg',
    ),
    Message(
      dateTime: DateTime.now().add(Duration(minutes: 10)),
      text: 'Это было бы здорово!',
      userImage:
          'https://henderson.ru/uimages/catalog/product/HT-0254/HT-0254-DNAVY-6-1.jpg',
    ),
    Message(
      dateTime: DateTime.now().add(Duration(minutes: 20)),
      text: 'У тебя есть другие планы?',
      userImage:
          'https://henderson.ru/uimages/catalog/product/HT-0254/HT-0254-DNAVY-6-1.jpg',
    ),
    Message(
      dateTime: DateTime.now().add(Duration(minutes: 30)),
      text: 'Я планирую навестить семью',
      userImage:
          'https://images.pexels.com/photos/91227/pexels-photo-91227.jpeg',
    ),
    Message(
      dateTime: DateTime.now().add(Duration(minutes: 40)),
      text: 'Звучит круто 👍',
      userImage:
          'https://henderson.ru/uimages/catalog/product/HT-0254/HT-0254-DNAVY-6-1.jpg',
    ),
    Message(
      dateTime: DateTime.now().add(Duration(minutes: 50)),
      text: 'Спасибо! Хороших выходных!',
      userImage:
          'https://images.pexels.com/photos/91227/pexels-photo-91227.jpeg',
    ),
    Message(
      dateTime: DateTime.now().add(Duration(minutes: 55)),
      text: 'И тебе 😀',
      userImage:
          'https://henderson.ru/uimages/catalog/product/HT-0254/HT-0254-DNAVY-6-1.jpg',
    ),
    Message(
      dateTime: DateTime.now().add(Duration(minutes: 60)),
      text: 'Увидимся в понедельник 👋',
      userImage:
          'https://images.pexels.com/photos/91227/pexels-photo-91227.jpeg',
    ),
  ];

  TextEditingController _textEditingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            CircleAvatar(
              backgroundImage: NetworkImage(
                  'https://henderson.ru/uimages/catalog/product/HT-0254/HT-0254-DNAVY-6-1.jpg'),
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
                'Mark Johnson',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: messages.length,
              itemBuilder: (context, index) {
                final message = messages[index];
                final isUserMessage = message.userImage == widget.user.photoUrl;
                return GestureDetector(
                  onLongPress: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return TranslateDialog(originText: message.text, lang: ,);
                      },
                    );
                  },
                  child: Container(
                    alignment: isUserMessage
                        ? Alignment.centerRight
                        : Alignment.centerLeft,
                    child: Container(
                      padding: EdgeInsets.all(8),
                      margin: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
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
                      hintText: 'Введите сообщение...',
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.send),
                  onPressed: () {
                    String messageText = _textEditingController.text;
                    // Add logic to send the message
                    _textEditingController.clear();
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<String> translate(String message, String target) async {
    final url = Uri.parse('https://translate-plus.p.rapidapi.com/translate');
    final body = jsonEncode({
      'text': message,
      'source': 'auto',
      'target': target,
    });

    final response = await http.post(
      url,
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
        'x-rapidapi-ua': 'RapidAPI-Playground',
        'x-rapidapi-key': '45187f901amsh6f0709b3adc1a84p14da17jsnd75099fdda7f',
        'x-rapidapi-host': 'translate-plus.p.rapidapi.com',
        'specificMethodHeaders': '[object Object]'
      },
      body: body,
    );

    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body);
      return jsonResponse;
    } else {
      print('Request failed with status code: ${response.statusCode}');
    }
    return message;
  }
}

class Message {
  final DateTime dateTime;
  final String text;
  final String userImage;

  Message({
    required this.dateTime,
    required this.text,
    required this.userImage,
  });
}
