import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:messenger/auth/cubit/auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  //final AuthRepository _authRepository;
  AuthCubit() : super(AuthInitial());

  void signIn({
    required String email,
    required String password,
  }) {}

  void signUp({
    required String email,
    required String password,
  }) {}

  void signOut() {}
}
