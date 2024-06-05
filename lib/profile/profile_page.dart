import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:messenger/data/data_sources/interfaces/i_preference_data_source.dart';
import 'package:messenger/domain/entities/language.dart';
import 'package:messenger/presentation/di/injector.dart';
import 'package:messenger_app/auth/cubit/auth_cubit.dart';
import 'package:messenger_app/lang/locale_keys.g.dart';
import 'package:messenger_app/profile/cubit/profile_cubit.dart';
import 'package:messenger_app/utils.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  ProfilePageState createState() => ProfilePageState();
}

class ProfilePageState extends State<ProfilePage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _birthdayController = TextEditingController();
  String _appLanguage = 'en';
  //Language _messagesLanguage = Language.English;
  DateTime? _selectedDate;
  File? _selectedImage;
  String? _photoUrl;
  final DateFormat _dateFormat = DateFormat('dd-MM-yyyy');

  @override
  void initState() {
    super.initState();
    _appLanguage = getIt.get<IPreferenceDataSource>().appLanguage;
    //_messagesLanguage = getIt.get<IPreferenceDataSource>().messageLanguage;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        final userData = context.read<ProfileCubit>().state.user;
        _nameController.text = userData?.name ?? '';
        _emailController.text = userData?.email ?? '';
        _phoneController.text = userData?.phone ?? '';
        _birthdayController.text =
            _dateFormat.format(userData?.birthday ?? DateTime(2010));
        _selectedDate = userData?.birthday;
        _photoUrl = userData?.photoUrl;
      });
    });
  }

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
            GestureDetector(
              onTap: () {
                Utils.showImagePicker(context, (file) {
                  setState(() {
                    _selectedImage = file;
                  });
                });
              },
              child: _selectedImage != null
                  ? CircleAvatar(
                      radius: 70,
                      backgroundImage: FileImage(_selectedImage!),
                    )
                  : _photoUrl != null
                      ? CircleAvatar(
                          radius: 70,
                          backgroundImage: NetworkImage(_photoUrl!),
                        )
                      : const SizedBox(
                          height: 70,
                          width: 70,
                          child: const Icon(Icons.add_a_photo),
                        ),
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
                  _birthdayController.text = _dateFormat.format(_selectedDate!);
                }
              },
            ),
            const SizedBox(height: 16.0),
            DropdownButton<String>(
              value: _appLanguage,
              onChanged: (value) async {
                if (value != null) {
                  getIt.get<IPreferenceDataSource>().appLanguage = value;
                  await context.setLocale(Locale(value));
                  setState(() {
                    _appLanguage = value;
                  });
                }
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
              onPressed: () async {
                await context.read<ProfileCubit>().updateUserProfile(
                      name: _nameController.text,
                      phone: _phoneController.text,
                      birthday: _selectedDate,
                      photo: _selectedImage,
                    );
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
