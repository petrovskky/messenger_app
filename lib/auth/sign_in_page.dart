import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:messenger_app/auth/cubit/auth_cubit.dart';
import 'package:messenger_app/auth/sign_up_page.dart';
import 'package:messenger_app/utils.dart';

import '../lang/locale_keys.g.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({super.key});

  @override
  SignInPageState createState() => SignInPageState();
}

class SignInPageState extends State<SignInPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
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
                SizedBox(
                  width: double.maxFinite,
                  child: ElevatedButton(
                    onPressed: () async {
                      String email = _emailController.text;
                      String password = _passwordController.text;
                      if (email.isEmpty || password.isEmpty) {
                        Utils.showErrorMessage(context, LocaleKeys.dataEmpty.tr());
                        return;
                      }
                      setState(() {
                        _isLoading = true;
                      });
                      final res = await context
                          .read<AuthCubit>()
                          .signIn(email: email, password: password);
                      setState(() {
                        _isLoading = false;
                      });
                      if (!res) {
                        Utils.showErrorMessage(context, LocaleKeys.error.tr());
                        return;
                      }
                    },
                    child: Text(LocaleKeys.signIn.tr()),
                  ),
                ),
                const SizedBox(height: 8.0),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => const SignUpPage()));
                  },
                  child: Text(LocaleKeys.signUp.tr()),
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
          )
      ],
    );
  }
}
