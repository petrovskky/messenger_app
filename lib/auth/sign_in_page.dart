import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../lang/locale_keys.g.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({super.key});

  @override
  SignInPageState createState() => SignInPageState();
}

class SignInPageState extends State<SignInPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(LocaleKeys.signIn.tr()),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _emailController,
              decoration: InputDecoration(
                labelText: LocaleKeys.email.tr(),
              ),
            ),
            const SizedBox(height: 16.0),
            TextField(
              controller: _passwordController,
              decoration: InputDecoration(
                labelText: LocaleKeys.password.tr(),
              ),
              obscureText: true,
            ),
            const SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
                //String email = _emailController.text;
                //String password = _passwordController.text;
              },
              child: Text(LocaleKeys.signIn.tr()),
            ),
            const SizedBox(height: 8.0),
            TextButton(
              onPressed: () {
              },
              child: Text(LocaleKeys.signUp.tr()),
            ),
          ],
        ),
      ),
    );
  }
}
