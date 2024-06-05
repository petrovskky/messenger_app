import 'package:equatable/equatable.dart';
import 'package:messenger/domain/entities/dialog.dart';
import 'package:messenger/domain/entities/user.dart';

class ChatState extends Equatable{
  final List<User> users;
  final List<Dialog> dialogs;
  final Dialog? currentDialog;

  const ChatState(this.dialogs, this.users, this.currentDialog);
  
  @override
  List<Object?> get props => [dialogs, users, currentDialog];
}