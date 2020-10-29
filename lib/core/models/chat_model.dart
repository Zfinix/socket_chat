import 'package:flutter/material.dart';

class ChatModel {
  String id;
  String username;
  String message;
  DateTime timestamp;

  ChatModel({
    @required this.id,
    @required this.username,
    @required this.message,
    @required this.timestamp,
  });

  ChatModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    username = json['username'];
    message = json['message'];
    timestamp = json['timestamp'] != null
        ? DateTime.fromMillisecondsSinceEpoch(json['timestamp'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['username'] = this.username;
    data['message'] = this.message;
    data['timestamp'] = this.timestamp.millisecondsSinceEpoch;
    return data;
  }
}
