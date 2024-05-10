import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

class Post {
  final story;
  final String title;
  final String uid;
  final String username;
  final likes;
  final String postId;
  final DateTime datePublished;
  final postUrl;
  final String profImage;
  final photos;
  final String body;

  const Post(
      {required this.photos,
      required this.story,
      required this.title,
      required this.uid,
      required this.username,
      required this.likes,
      required this.postId,
      required this.datePublished,
      required this.postUrl,
      required this.profImage,
      required this.body});

  static Post fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;

    return Post(
        story: snapshot["story"],
        title: snapshot["description"],
        uid: snapshot["uid"],
        likes: snapshot["likes"],
        postId: snapshot["postId"],
        datePublished: snapshot["datePublished"],
        username: snapshot["username"],
        postUrl: snapshot['postUrl'],
        profImage: snapshot['profImage'],
        photos: snapshot['photos'],
        body: snapshot['body']);
  }

  Map<String, dynamic> toJson() => {
        "story": story,
        "description": title,
        "uid": uid,
        "likes": likes,
        "username": username,
        "postId": postId,
        "datePublished": datePublished,
        'postUrl': postUrl,
        'profImage': profImage,
        'photos': photos,
        'body': body
      };
}
