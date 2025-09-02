import 'package:flutter/material.dart';
import 'package:flutter_chat_ui/flutter_chat_ui.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:flutter_firebase_chat/src/components/loading_widget.dart';
import 'package:flutter_firebase_chat/src/utils/local_service/local_data_manager.dart';
import 'package:flutter_firebase_chat/src/utils/riverpod.dart';
import 'package:flutter_firebase_chat/src/utils/style.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import '../../../components/general_app_bar.dart';
import '../../../service_locator.dart';
import '../../data/models/massege_model.dart';
import '../../data/models/user_model.dart';
import '../../domain/repo/chats_repo.dart';
import '../managers/chat_providers.dart';

class ChatPage extends ConsumerStatefulWidget {
  final bool? isDisabled;
  final String receiverId;
  final String receiverName;
  final PreferredSizeWidget? customAppBar;
  final UserData receiver;

  const ChatPage({
    super.key,
    this.isDisabled = false,
    required this.receiverId,
    required this.receiverName,
    required this.receiver,
    this.customAppBar,
  });

  @override
  ConsumerState<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends ConsumerState<ChatPage> {
  late types.User _user;
  final GlobalKey<ChatState> _chatKey = GlobalKey();
  final ChatServiceInit chatInit = ChatServiceInit();
  final Style style = ChatServiceInit().style;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final user = dataManager.getUser()!;
    _user = types.User(
      id: user.id.toString(),
      firstName: user.name,
      imageUrl: user.profilePicture,
      role: user.role == "admin" ? types.Role.admin : types.Role.user,
    );
  }

  void _handlePreviewDataFetched(
      types.TextMessage message,
      types.PreviewData previewData,
      ) {
    // Optionally handle preview updates
  }

  List<types.TextMessage> _convertMessages(List<MessageModel> conversation) {
    return conversation.map((e) {
      return types.TextMessage(
        author: types.User(
          id: e.sender.id.toString(),
          firstName: e.sender.name,
          imageUrl: e.sender.profilePicture,
          role: e.sender.role == "admin" ? types.Role.admin : types.Role.user,
        ),
        createdAt: e.timestamp.millisecondsSinceEpoch,
        id: const Uuid().v4(),
        showStatus: true,
        text: e.message,
        status: e.seen == true ? types.Status.seen : types.Status.delivered,
      );
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: GeneralAppBar(
        title: Text(widget.receiverName, style: TextStyle(fontSize: 18,color: Colors.black,fontWeight: FontWeight.bold)),
      ),
      body: SafeArea(
        child: ref.watch(fetchChatMessagesProvider(widget.receiverId)).customWhen(
          ref: ref,
          refreshable: fetchChatMessagesProvider(widget.receiverId).future,
          skipLoadingOnRefresh: true,
          skipLoadingOnReload: true,
          loading: () => const Center(child: LoadingWidget()),
          data: (conversation) {
            final messages = _convertMessages(conversation);

            return Chat(
              key: _chatKey,
              messages: messages.reversed.toList(),
              user: _user,
              onSendPressed: (types.PartialText message) async {
                final textMessage = types.TextMessage(
                  author: _user,
                  createdAt: DateTime.now().millisecondsSinceEpoch,
                  id: const Uuid().v4(),
                  text: message.text,
                );

                await getIt<ChatsRepo>().sendMessage(
                  widget.receiver,
                  textMessage.text,
                  userId: widget.receiver.id.toString(),
                  userName: widget.receiver.name ?? "Unknown user",
                );

                ref.invalidate(fetchChatsProvider);
                ref.invalidate(fetchChatMessagesProvider);
              },
              onPreviewDataFetched: _handlePreviewDataFetched,
              theme: DefaultChatTheme(
                backgroundColor: style.scaffoldColor,
                primaryColor: style.primaryColor.withAlpha(200),
                secondaryColor: style.grey2.withAlpha(40),
                receivedMessageBodyTextStyle:
                TextStyle(color: style.grey2, fontSize: 14),
                sentMessageBodyTextStyle:
                TextStyle(color: style.scaffoldColor, fontSize: 14),
                inputBackgroundColor: widget.isDisabled == true
                    ? Colors.transparent
                    : style.primaryColor.withAlpha(200),
                inputTextColor: widget.isDisabled == true
                    ? style.primaryColor
                    : style.scaffoldColor,
                inputSurfaceTintColor: style.primaryColor,
              ),
              showUserAvatars: true,
              inputOptions: InputOptions(enabled: !widget.isDisabled!),
            );
          },
        ),
      ),
    );
  }
}
