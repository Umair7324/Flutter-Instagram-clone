// ignore_for_file: prefer_typing_uninitialized_variables

import 'package:cloud_firestore/cloud_firestore.dart';

class Post {
  final String username;
  final String postId;
  final publishedDate;
  final String profImage;
  final String description;
  final String uid;
  final likes;
  final String posturl;

  Post(
      {required this.username,
      required this.uid,
      required this.description,
      required this.likes,
      required this.postId,
      required this.publishedDate,
      required this.posturl,
      required this.profImage});
  Map<String, dynamic> toJSON() => {
        'username': username,
        'postId': postId,
        'uid': uid,
        'publishedDate': DateTime.now(),
        'likes': likes,
        'postUrl': posturl,
        'description': description,
        'profImage': profImage
      };

  static Post fromSNap(DocumentSnapshot snapshot) {
    Object snap = snapshot.data() as Map<String, dynamic>;
    return Post(
        username: (snap as Map<String, dynamic>)['username'],
        postId: (snap)['postId'],
        publishedDate: (snap)['publishedDate'],
        uid: (snap)['uid'],
        posturl: (snap)['posturl'],
        likes: (snap)['likes'],
        description: (snap)['description'],
        profImage: (snap)['profImage']);
  }
}
