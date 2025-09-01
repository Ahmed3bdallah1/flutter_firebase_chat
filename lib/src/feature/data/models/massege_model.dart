import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_firebase_chat/src/feature/data/models/user_model.dart';

class MessageModel {
  final UserData sender;
  final UserData receiver;
  final String message;
  final bool seen;
  final File? file;
  final Timestamp timestamp;

  MessageModel({
    required this.sender,
    required this.receiver,
    required this.message,
    required this.timestamp,
    required this.seen,
    this.file,
  });

  factory MessageModel.fromMap(Map<String, dynamic> map) {
    return MessageModel(
      sender: UserData.fromJson(map['sender']),
      receiver: UserData.fromJson(map['receiver']),
      message: map['message'],
      seen: map['seen'] ?? false,
      timestamp: map['timestamp'],
      file: map['file'] != null ? File(map['file']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "sender": sender.toJson(),
      "receiver": receiver.toJson(),
      "message": message,
      file != null ? "file": file!.path : null,
      "timestamp": timestamp
    };
  }
}
