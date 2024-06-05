import 'package:bloc/bloc.dart';
import 'package:messenger/domain/data_interfaces/i_chat_repository.dart';
import 'package:messenger_app/dialogs/cubit/chat_state.dart';

class ChatCubit extends Cubit<ChatState> {
  final IChatRepository chatRepository;

  ChatCubit({required this.chatRepository})
      : super(const ChatState([], [], null));

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

  Future<void> sendMessage(String userId, String text,
      {String? dialogId}) async {
    try {
      dialogId ??= await chatRepository.createDialog(userId);
      if (dialogId != null) {
        await chatRepository.sendMessage(dialogId, text);
        if (state.currentDialog != null &&
            state.currentDialog!.id == dialogId) {
          await openDialog(dialogId: dialogId);
        }
      }
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> openDialog({String? dialogId, String? userId}) async {
    try {
      if (userId != null) {
        dialogId = await chatRepository.getDialogByUser(userId);
      }
      if (dialogId != null) {
        final dialog =
            state.dialogs.firstWhere((element) => element.id == dialogId);
        emit(ChatState(state.dialogs, state.users, dialog));
        chatRepository.openDialog(dialogId, (dialog) {
          emit(ChatState(state.dialogs, state.users, dialog));
        });
      } else {
        emit(ChatState(state.dialogs, state.users, null));
      }
    } catch (e) {
      print(e.toString());
    }
  }
}
