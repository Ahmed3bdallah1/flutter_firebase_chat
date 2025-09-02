import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart' as intl;
import '../../../data/models/user_model.dart';
import '../../../domain/entities/chat_entity.dart';
import '../chat_screen.dart';

enum NavigatorType { Get, Navigator }

class ChatTileContainer extends ConsumerWidget {
  final ChatEntity chat;
  final NavigatorType navigatorType;
  final UserData? receiverData;

  const ChatTileContainer({
    super.key,
    required this.chat,
    this.receiverData,
    this.navigatorType = NavigatorType.Get,
  });

  String timeAgo(DateTime date) {
    final Duration diff = DateTime.now().difference(date);

    if (diff.inSeconds < 60) {
      return "${diff.inSeconds}s ago";
    } else if (diff.inMinutes < 60) {
      return "${diff.inMinutes}m ago";
    } else if (diff.inHours < 24) {
      return "${diff.inHours}h ago";
    } else if (diff.inDays < 7) {
      return "${diff.inDays}d ago";
    } else {
      return intl.DateFormat.yMd().add_jm().format(date);
    }
  }

  _navigateWithGet() {
    Get.to(
          () => ChatPage(
        receiverId: chat.receiverId,
        receiverName: chat.receiverName,
        receiver: receiverData ?? UserData(
          id: int.parse(chat.receiverId),
          status: "1",
          isVerified: "1",
          name: chat.receiverName,
          role: "user",
          profilePicture: chat.receiverImage,
        ),
      ),
    );
  }

  _navigateWithNavigator(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ChatPage(
          receiverId: chat.receiverId,
          receiverName: chat.receiverName,
          receiver: receiverData ?? UserData(
            id: int.parse(chat.receiverId),
            status: "1",
            isVerified: "1",
            name: chat.receiverName,
            role: "user",
            profilePicture: chat.receiverImage,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return GestureDetector(
      key: UniqueKey(),
      onTap: () {
        if (navigatorType == NavigatorType.Get) {
          _navigateWithGet();
        } else {
          _navigateWithNavigator(context);
        }
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          child: ListTile(
            leading: ClipRRect(
              borderRadius: BorderRadius.circular(40),
              child: Image.network(chat.receiverImage, height: 65, width: 65),
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  timeAgo(chat.updatedAt.toDate()),
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[300],
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
            subtitle: Text(
              chat.lastMessage,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
                fontWeight: FontWeight.w600,
              ),
            ),
            title: Text(
              chat.receiverName,
              style: TextStyle(
                fontSize: 16,
                color: Colors.black,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
