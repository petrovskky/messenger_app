import 'dart:io';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:messenger_app/profile/cubit/profile_state.dart';
import 'package:messenger/domain/data_interfaces/i_user_repository.dart';
import 'package:messenger/domain/entities/user.dart';

class ProfileCubit extends Cubit<ProfileState> {
  final IUserRepository userRepository;

  ProfileCubit({required this.userRepository}) : super(const ProfileState(null));

  Future<void> init(String? email) async {
    userRepository.init(
      email,
      (user) => fetchUserProfile(user: user),
      (_) => emit(const ProfileState(null)),
    );
  }

  Future<void> fetchUserProfile({User? user}) async {
    try {
      user ??= await userRepository.getUser();
      emit(ProfileState(user));
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> updateUserStatus(bool isActive) async {
    try {
      await userRepository.updateUserStatus(isActive);
      emit(ProfileState(await userRepository.getUser()));
    } catch (e) {
      print(e.toString());
    }
  }

  Future<String?> loadAvatar(File file) async {
    try {
      final photoUrl = await userRepository.loadAvatar(file);
      emit(ProfileState(await userRepository.getUser()));
      return photoUrl;
    } catch (e) {
      print(e.toString());
    }
    return null;
  }

  Future<void> updateUserProfile(
      {String? name, String? phone, DateTime? birthday, File? photo}) async {
    try {
      String? photoUrl;
      if (photo != null) {
        photoUrl = await loadAvatar(photo);
      }

      await userRepository.updateUser(
        name: name,
        phone: phone,
        birthday: birthday,
        photoUrl: photoUrl,
      );
      emit(ProfileState(await userRepository.getUser()));
    } catch (e) {
      print(e.toString());
    }
  }
}
