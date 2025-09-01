import 'package:flutter/material.dart';
import 'package:flutter_firebase_chat/src/feature/presentation/view/widgets/chat_tile.dart';
import 'package:flutter_firebase_chat/src/utils/riverpod.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import '../../../components/not_found_widget.dart';
import '../managers/chat_providers.dart';

class ChatsScreen extends ConsumerStatefulWidget {
  const ChatsScreen({super.key});

  @override
  ConsumerState<ChatsScreen> createState() => _ChatsScreenState();
}

class _ChatsScreenState extends ConsumerState<ChatsScreen> {

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
              onRefresh: () => ref.refresh(fetchChatsProvider.future),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16,vertical: 12),
                child: Consumer(
                  builder: (context, ref, _) {
                    final provider = ref.watch(fetchChatsProvider);
                    return provider.customWhen(
                      ref: ref,
                      refreshable: fetchChatsProvider.future,
                      skipLoadingOnRefresh: true,
                      error: (e, st) {
                        return NotFoundWidget(
                          title: "Error occurred".tr,
                          message: e.toString(),
                        );
                      },
                      data: (chats) {
                        if (chats.isEmpty) {
                          return NotFoundWidget(
                            title: "No Chats found".tr,
                            message: "You have no chats yet".tr,
                          );
                        }
                        return ListView.separated(
                          itemBuilder: (context, index) {
                            final conv = chats[index];
                            return ChatTileContainer(chat: conv);
                          },
                          separatorBuilder: (context, index) => const Gap(8),
                          itemCount: chats.length,
                        );
                      },
                    );
                  },
                ),
              ),
            );
  }
}
