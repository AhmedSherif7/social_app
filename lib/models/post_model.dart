import 'package:cloud_firestore/cloud_firestore.dart';

class PostModel {
  String? postId;
  String? uid;
  Timestamp? dateTime;
  String? text;
  String? postImage;
  List<dynamic>? likes = [];
  int? commentsCount = 0;

  PostModel({
    this.postId,
    this.uid,
    this.dateTime,
    this.text,
    this.postImage,
    this.likes,
    this.commentsCount,
  });

  PostModel.fromJson(Map<String, dynamic> json) {
    postId = json['postId'];
    uid = json['uid'];
    dateTime = json['dateTime'];
    text = json['text'];
    postImage = json['postImage'];
    likes = json['likes'];
    commentsCount = json['commentsCount'];
  }

  Map<String, dynamic> toMap() {
    return {
      'postId': postId,
      'uid': uid,
      'dateTime': dateTime,
      'text': text,
      'postImage': postImage,
      'likes': likes,
      'commentsCount': commentsCount,
    };
  }
}
