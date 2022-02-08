import 'package:cloud_firestore/cloud_firestore.dart';

class CommentModel {
  String? text;
  String? uid;
  Timestamp? dateTime;

  CommentModel.fromJson(Map<String, dynamic> json) {
    text = json['text'];
    uid = json['uid'];
    dateTime = json['dateTime'];
  }

  Map<String, dynamic> toMap() {
    return {
      'text': text,
      'uid': uid,
      'dateTime': dateTime,
    };
  }
}
