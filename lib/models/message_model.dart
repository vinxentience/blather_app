import 'package:cloud_firestore/cloud_firestore.dart';

class MessageModel {
  String? senderId;
  String? receiverId;
  String? type;
  String? message;
  Timestamp? timestamp;
  String? photoUrl;

  MessageModel({
    this.senderId,
    this.receiverId,
    this.type,
    this.message,
    this.timestamp,
  });

  MessageModel.imageMessage({
    this.senderId,
    this.receiverId,
    this.type,
    this.timestamp,
    this.photoUrl,
    this.message,
  });

  Map toMap() {
    var map = <String, dynamic>{};
    map['senderId'] = senderId;
    map['receiverId'] = receiverId;
    map['type'] = type;
    map['message'] = message;
    map['timestamp'] = timestamp;
    return map;
  }

  MessageModel.fromMap(Map<String, dynamic> map) {
    senderId = map['senderId'];
    receiverId = map['receiverId'];
    type = map['type'];
    message = map['message'];
    timestamp = map['timestamp'];
    photoUrl = map['photoUrl'];
  }

  Map toImageMap() {
    var map = <String, dynamic>{};
    map['senderId'] = senderId;
    map['receiverId'] = receiverId;
    map['type'] = type;
    map['message'] = message;
    map['timestamp'] = timestamp;
    map['photoUrl'] = photoUrl;
    return map;
  }
}
