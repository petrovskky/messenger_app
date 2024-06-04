import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:messenger/domain/entities/user.dart';

class UserProfilePage extends StatefulWidget {
  final User user;

  const UserProfilePage({super.key, required this.user});

  @override
  UserProfilePageState createState() => UserProfilePageState();
}

class UserProfilePageState extends State<UserProfilePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              backgroundColor:
                  widget.user.isActive ? Colors.green : Colors.grey,
              radius: 75,
              child: widget.user.photoUrl != null
                  ? Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: CircleAvatar(
                        radius: 70,
                        backgroundImage: NetworkImage(widget.user.photoUrl!),
                      ),
                    )
                  : const Icon(Icons.person),
            ),
            SizedBox(height: 20),
            Text(
              'Email: ${widget.user.email}',
              style: TextStyle(
                fontSize: 16,
              ),
            ),
            SizedBox(height: 10),
            Text(
              'Phone: ${widget.user.phone}',
              style: TextStyle(
                fontSize: 16,
              ),
            ),
            SizedBox(height: 10),
            if (widget.user.birthday != null)
              Text(
                'Birthday: ${DateFormat('dd-MM-yyyy').format(widget.user.birthday!)}',
                style: TextStyle(
                  fontSize: 16,
                ),
              ),
            SizedBox(height: 20),
            Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(horizontal: 15),
              child: ElevatedButton(
                onPressed: () {
                  // Handle button press
                },
                child: Text('Написать'),
              ),
            ),
            SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}
