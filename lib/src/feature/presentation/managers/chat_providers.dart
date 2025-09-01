import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../service_locator.dart';
import '../../data/models/massege_model.dart';
import '../../domain/entities/chat_entity.dart';
import '../../domain/repo/chats_repo.dart';

final fetchChatMessagesProvider = StreamProvider.autoDispose.family<List<MessageModel>,String>((ref,id) async* {
  final res = getIt<ChatsRepo>().getMessages(id);
  yield* res.map(
    (either) => either.fold(
      (l) => throw l,
      (r) => r.docs
          .map((doc) => MessageModel.fromMap(doc.data() as Map<String, dynamic>))
          .toList(),
    ),
  );
});

final fetchChatsProvider = StreamProvider.autoDispose<List<ChatEntity>>((ref) async* {
  final res = getIt<ChatsRepo>().getChats();
  yield* res.map(
    (either) => either.fold(
      (l) => throw l,
      (r) => r.docs
          .map((doc) => ChatEntity.fromJson(doc.data() as Map<String, dynamic>))
          .toList(),
    ),
  );
});
