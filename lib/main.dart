import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:messenger/data/repositories/auth_repository.dart';
import 'package:messenger/domain/data_interfaces/i_auth_repository.dart';
import 'package:messenger/presentation/di/injector.dart' as injector;
import 'package:messenger_app/auth/cubit/auth_cubit.dart';
import 'package:messenger_app/auth/cubit/auth_state.dart';
import 'package:messenger_app/auth/sign_in_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:messenger_app/main_tab.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'firebase_options.dart';

import 'lang/codegen_loader.g.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await EasyLocalization.ensureInitialized();
  injector.setup(
    FirebaseAuth.instance,
    FirebaseFirestore.instance,
    (await SharedPreferences.getInstance()),
  );
  runApp(EasyLocalization(
    path: 'assets/lang',
    supportedLocales: const [
      Locale('en'),
      Locale('ru'),
    ],
    fallbackLocale: const Locale('en'),
    assetLoader: const CodegenLoader(),
    child: const MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<AuthCubit>(
      create: (context) => AuthCubit(
        authRepository: injector.getIt.get<IAuthRepository>(),
      )..checkAuth(),
      child: MaterialApp(
        supportedLocales: context.supportedLocales,
        localizationsDelegates: context.localizationDelegates,
        locale: context.locale,
        debugShowCheckedModeBanner: false,
        theme: ThemeData.from(
          colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF008a8b)),
        ),
        home: BlocBuilder<AuthCubit, AuthState>(
          builder: (context, state) {
            if (state is InitialState) {
              return Scaffold(
                backgroundColor: Colors.white,
                body: Center(
                  child: Image.asset(
                    'assets/images/messenger.png',
                    scale: 3,
                  ),
                ),
              );
            }
            if (state is AuthenticatedState) {
              return const MainTab();
            }
            return const SignInPage();
          },
        ),
      ),
    );
  }
}
