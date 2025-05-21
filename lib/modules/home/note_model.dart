import 'package:cloud_firestore/cloud_firestore.dart';

class NoteModel {
  final String id;
  final String title;
  final bool isDone;
  final String userID;
  final Timestamp timestamp;

  NoteModel({
    required this.id,
    required this.title,
    required this.isDone,
    required this.userID,
    required this.timestamp,
  });

  factory NoteModel.fromJson(Map<String, dynamic> json, String id) {
    return NoteModel(
      id: id,
      title: json['title'] ?? '',
      isDone: json['isDone'] ?? false,
      userID: json['userID'] ?? '',
      timestamp: json['timestamp'] ?? Timestamp.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'isDone': isDone,
      'userID': userID,
      'timestamp': timestamp,
    };
  }
}
