import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:messenger_app/auth/cubit/auth_cubit.dart';
import 'package:messenger_app/lang/locale_keys.g.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  ProfilePageState createState() => ProfilePageState();
}

class ProfilePageState extends State<ProfilePage> {
  final TextEditingController _nameController =
      TextEditingController(text: 'John Doe');
  final TextEditingController _emailController =
      TextEditingController(text: 'example@example.com');
  final TextEditingController _phoneController =
      TextEditingController(text: '1234567890');
  final TextEditingController _birthdayController =
      TextEditingController(text: '01/01/2000');
  String _selectedLanguage = 'en';
  DateTime? _selectedDate = DateTime(2000);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(LocaleKeys.profile.tr()),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            CircleAvatar(
              radius: 70,
              backgroundImage: NetworkImage('https://images.pexels.com/photos/91227/pexels-photo-91227.jpeg'),
            ),
            TextField(
              decoration: InputDecoration(
                labelText: LocaleKeys.name.tr(),
              ),
              controller: _nameController,
            ),
            const SizedBox(height: 16.0),
            TextField(
              decoration: InputDecoration(
                labelText: LocaleKeys.email.tr(),
              ),
              enabled: false,
              controller: _emailController,
            ),
            const SizedBox(height: 16.0),
            TextField(
              decoration: InputDecoration(
                labelText: LocaleKeys.phone.tr(),
              ),
              controller: _phoneController,
            ),
            const SizedBox(height: 16.0),
            TextFormField(
              controller: _birthdayController,
              decoration: InputDecoration(
                labelText: LocaleKeys.birthday.tr(),
              ),
              onTap: () async {
                _selectedDate = await showDatePicker(
                  context: context,
                  initialDate: _selectedDate,
                  firstDate: DateTime(1900),
                  lastDate: DateTime(2010),
                );
                if (_selectedDate != null) {
                  DateFormat dateFormat = DateFormat('dd-MM-yyyy');
                  _birthdayController.text = dateFormat.format(_selectedDate!);
                }
              },
            ),
            const SizedBox(height: 16.0),
            DropdownButton<String>(
              value: _selectedLanguage,
              onChanged: (value) {
                setState(() {
                  _selectedLanguage = value!;
                });
              },
              items: [
                DropdownMenuItem(
                  value: 'en',
                  child: Text(LocaleKeys.english.tr()),
                ),
                DropdownMenuItem(
                  value: 'ru',
                  child: Text(LocaleKeys.russian.tr()),
                ),
              ],
            ),
            const SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
                // Save all data
              },
              child: Text(LocaleKeys.saveAll.tr()),
            ),
            const SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
                context.read<AuthCubit>().signOut();
              },
              child: Text(LocaleKeys.signOut.tr()),
            ),
          ],
        ),
      ),
    );
  }
}
