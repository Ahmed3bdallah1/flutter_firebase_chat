import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_firebase_chat/flutter_firebase_chat.dart';
import '../../../utils/local_service/local_data_manager.dart';
import '../models/massege_model.dart';
import '../models/user_model.dart';

abstract class ChatsDataSource {
  Future<void> sendMessage(UserData receiver, String message, {File? file});

  Stream<QuerySnapshot> getMessages(String receiverId);

  Stream<QuerySnapshot> getChats();
}

class ChatServices extends ChangeNotifier implements ChatsDataSource {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future<void> createChatRoomIfNotExists(
    String chatRoomId,
    UserData receiver,
  ) async {
    final UserData? currentUser = dataManager.getUser() ?? ChatServiceInit().userModel;
    final docRef = firestore.collection("chat_rooms").doc(chatRoomId);

    final doc = await docRef.get();
    if (!doc.exists) {
      await docRef.set({
        "senderId": currentUser?.id.toString() ?? "0",
        "receiverId": receiver.id.toString(),
        "receiverImage": receiver.profilePicture ?? "",
        "createdAt": FieldValue.serverTimestamp(),
      });
    }
  }

  @override
  Future<void> sendMessage(
    UserData receiver,
    String message, {
    File? file,
  }) async {
    final UserData? currentUser = dataManager.getUser() ?? ChatServiceInit().userModel;
    final Timestamp timestamp = Timestamp.now();

    MessageModel messages = MessageModel(
      sender: currentUser!,
      file: file,
      receiver: receiver,
      seen: false,
      message: message,
      timestamp: timestamp,
    );

    List<String> chatId = [
      currentUser?.id.toString() ?? "0",
      receiver.id.toString(),
    ];
    chatId.sort();
    String chatRoomId = chatId.join("&");

    try {
      await firestore.collection("chat_rooms").doc(chatRoomId).set({
        "senderId": currentUser?.id.toString() ?? "0",
        "receiverId": receiver.id.toString(),
        "receiverName": receiver.name,
        "receiverImage": receiver.profilePicture == ""
            ? "https://my-car.backteam.site/dashboard/images/user/user.png"
            : receiver.profilePicture,
        "lastMessage": messages.message,
        "updatedAt": FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));
      Map<String, dynamic> senderMap = _prepareUserMapForFirestore(
        currentUser!,
      );
      Map<String, dynamic> receiverMap = _prepareUserMapForFirestore(receiver);
      await firestore
          .collection("chat_rooms")
          .doc(chatRoomId)
          .collection("messages")
          .doc()
          .set({
            "sender": senderMap,
            "receiver": receiverMap,
            "message": message,
            "seen": false,
            "timestamp": timestamp,
          }, SetOptions(merge: true));
    } catch (e) {
      print("Error sending message: $e");
    }
  }

  Map<String, dynamic> _prepareUserMapForFirestore(UserData user) {
    Map<String, dynamic> toJson() {
      return {
        "id": user.id,
        "uuid": user.uuid ?? "",
        "name": user.name,
        "email": user.email ?? "",
        "phone": user.phone ?? "",
        "role": user.role ?? "user",
        "status": user.status ?? "0",
        "profile_picture": user.profilePicture ?? "",
        "code": user.code ?? "",
        "is_verified": user.isVerified ?? "0",
        "fcm_token": user.fcmToken ?? "",
      };
    }

    return toJson();
  }

  @override
  Stream<QuerySnapshot> getMessages(String receiverId) {
    final UserData? currentUser = dataManager.getUser() ?? ChatServiceInit().userModel;
    List<String> id = [currentUser?.id.toString() ?? "0", receiverId];
    id.sort();
    String chatRoomId = id.join("&");

    final snapshots = firestore
        .collection("chat_rooms")
        .doc(chatRoomId)
        .collection("messages")
        .orderBy("timestamp", descending: false)
        .snapshots();

    snapshots.listen((snapshot) {
      for (var doc in snapshot.docs) {
        final data = doc.data();
        final senderId = data["senderId"];
        final seen = data["seen"] ?? false;

        if (senderId != currentUser?.id.toString() && seen == false) {
          doc.reference.update({"seen": true});
        }
      }
    });

    return snapshots;
  }

  @override
  Stream<QuerySnapshot> getChats() {
    final UserData? currentUser = dataManager.getUser() ?? ChatServiceInit().userModel;

    return firestore
        .collection("chat_rooms")
        .where(
          Filter.or(
            Filter("senderId", isEqualTo: currentUser?.id.toString() ?? "0"),
            Filter("receiverId", isEqualTo: currentUser?.id.toString() ?? "0"),
          ),
        )
        .orderBy("updatedAt", descending: true)
        .snapshots();
  }
}
