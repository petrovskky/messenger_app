import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:messenger_app/auth/cubit/auth_cubit.dart';
import 'package:messenger_app/auth/sign_in_page.dart';
import 'package:messenger_app/lang/locale_keys.g.dart';
import 'package:messenger_app/utils.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  SignUpPageState createState() => SignUpPageState();
}

class SignUpPageState extends State<SignUpPage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _birthdayController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();

  File? _selectedImage;
  DateTime? _selectedDate;
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          appBar: AppBar(
            title: Text(LocaleKeys.signUp.tr()),
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
                  child: Center(
                    child: Container(
                      height: 200.0,
                      width: 200.0,
                      decoration: BoxDecoration(
                        border: Border.all(),
                        shape: BoxShape.circle,
                      ),
                      child: _selectedImage != null
                          ? CircleAvatar(
                              radius: 200,
                              backgroundImage: FileImage(_selectedImage!),
                            )
                          : const Icon(Icons.add_a_photo),
                    ),
                  ),
                ),
                const SizedBox(height: 16.0),
                TextField(
                  controller: _nameController,
                  decoration: InputDecoration(
                    labelText: LocaleKeys.name.tr(),
                  ),
                ),
                TextField(
                  controller: _emailController,
                  decoration: InputDecoration(
                    labelText: LocaleKeys.email.tr(),
                  ),
                ),
                TextField(
                  controller: _passwordController,
                  decoration: InputDecoration(
                    labelText: LocaleKeys.password.tr(),
                  ),
                  obscureText: true,
                ),
                TextFormField(
                  controller: _birthdayController,
                  decoration: InputDecoration(
                    labelText: LocaleKeys.birthday.tr(),
                  ),
                  onTap: () async {
                    _selectedDate = await showDatePicker(
                      context: context,
                      initialDate: DateTime(2010),
                      firstDate: DateTime(1900),
                      lastDate: DateTime(2010),
                    );
                    if (_selectedDate != null) {
                      DateFormat dateFormat = DateFormat('dd-MM-yyyy');
                      _birthdayController.text =
                          dateFormat.format(_selectedDate!);
                    }
                  },
                ),
                TextField(
                  controller: _phoneController,
                  decoration: InputDecoration(
                    labelText: LocaleKeys.phone.tr(),
                  ),
                ),
                const SizedBox(height: 16.0),
                ElevatedButton(
                  onPressed: () async {
                    String email = _emailController.text;
                    String password = _passwordController.text;
                    String name = _nameController.text;
                    String phone = _phoneController.text;
                    DateTime? birthday = _selectedDate;
                    if (email.isEmpty ||
                        password.isEmpty ||
                        name.isEmpty ||
                        phone.isEmpty) {
                      Utils.showErrorMessage(
                          context, LocaleKeys.dataEmpty.tr());
                      return;
                    }
                    setState(() {
                      _isLoading = true;
                    });
                    final res = await context.read<AuthCubit>().signUp(
                          email: email,
                          password: password,
                          name: name,
                          phone: phone,
                          birthday: birthday,
                          photo: _selectedImage,
                        );
                    setState(() {
                      _isLoading = false;
                    });
                    if (!res) {
                      Utils.showErrorMessage(context, LocaleKeys.error.tr());
                    } else {
                      //Navigator.of(context).pop();
                    }
                  },
                  child: Text(LocaleKeys.signUp.tr()),
                ),
                const SizedBox(height: 8.0),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text(LocaleKeys.signIn.tr()),
                ),
              ],
            ),
          ),
        ),
        if (_isLoading)
          Container(
            color: Colors.grey.withOpacity(0.5),
            child: const Center(
              child: CircularProgressIndicator(),
            ),
          ),
      ],
    );
  }
}
