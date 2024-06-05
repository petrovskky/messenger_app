import 'package:equatable/equatable.dart';
import 'package:messenger/domain/entities/user.dart';

class ProfileState extends Equatable{
  final User? user;

  const ProfileState(this.user);
  
  @override
  List<Object?> get props => [user];
}