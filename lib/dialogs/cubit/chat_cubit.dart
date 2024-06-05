import 'package:bloc/bloc.dart';
import 'package:messenger/domain/data_interfaces/i_chat_repository.dart';
import 'package:messenger_app/dialogs/cubit/chat_state.dart';

class ChatCubit extends Cubit<ChatState> {
  final IChatRepository chatRepository;

  ChatCubit({required this.chatRepository}) : super(const ChatState([], [], null));

  Future<void> loadDialogs() async {
    try {
      final dialogs = await chatRepository.getDialogs();
      emit(ChatState(dialogs, state.users, state.currentDialog));
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> loadUsers() async {
    try {
      final users = await chatRepository.getUserList();
      emit(ChatState(state.dialogs, users, state.currentDialog));
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> sendMessage(String userId, String text) async {
    try {
      final dialogId = await chatRepository.createDialog(userId);
      if (dialogId != null) {
        emit(ChatState(state.dialogs, state.users, state.currentDialog));
      }
    } catch (e) {
      print(e.toString());
    }
  }
}