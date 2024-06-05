import 'dart:io';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:messenger/domain/data_interfaces/i_auth_repository.dart';
import 'package:messenger_app/auth/cubit/auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final IAuthRepository _authRepository;

  AuthCubit({required IAuthRepository authRepository})
      : _authRepository = authRepository,
        super(InitialState());

  Future<void> checkAuth() async {
    await Future.delayed(const Duration(milliseconds: 3000));
    if (_authRepository.isAuthorized) {
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
      if (result) {
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
    required File? photo,
  }) async {
    try {
      final id = await _authRepository.signUp(
        name: name,
        email: email,
        password: password,
        phone: phone,
        birthday: birthday,
        photo: photo,
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
