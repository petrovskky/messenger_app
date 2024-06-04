import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:messenger/data/repositories/auth_repository.dart';
import 'package:messenger_app/auth/cubit/auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final AuthRepository _authRepository;

  AuthCubit({required AuthRepository authRepository})
      : _authRepository = authRepository,
        super(InitialState());

  Future<void> checkAuth() async {
    await Future.delayed(const Duration(milliseconds: 3000));
    if (_authRepository.firebaseAuth.currentUser != null) {
      emit(AuthenticatedState());
    } else {
      emit(NotAuthenticatedState());
    }
  }

  Future<bool> signIn({
    required String email,
    required String password,
  }) async {
    try {
      final result = await _authRepository.signIn(email: email, password: password);
      if (result != null) {
        emit(AuthenticatedState());
        return true;
      }
    } catch (e) {
      print(e.toString());
    }
    return false;
  }

  Future<bool> signUp({
    required String name,
    required String email,
    required String password,
    required String phone,
    required DateTime? birthday,
    required String? photoUrl,
  }) async {
    try {
      final id = await _authRepository.signUp(
        name: name,
        email: email,
        password: password,
        phone: phone,
        birthday: birthday,
        photoUrl: photoUrl,
      );
      if (id.isNotEmpty) {
        emit(AuthenticatedState());
        return true;
      }
    } catch (e) {
      print(e.toString());
    }
    return false;
  }

  Future<void> signOut() async {
    await _authRepository.signOut();
    emit(NotAuthenticatedState());
  }
}
