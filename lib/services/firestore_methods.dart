import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:instagram_clone/models/post.dart';
import 'package:instagram_clone/services/file_storage.dart';
import 'package:uuid/uuid.dart';

class FirebaseMethods {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  uplaodPost(String username, Uint8List file, String uid, String description,
      String profImage) async {
    String res = 'some error accured..';

    try {
      String imageUrl = await Firebasestorage().uploadFile('post', file, true);
      final String postId = const Uuid().v1();
      Post post = Post(
          username: username,
          uid: uid,
          description: description,
          likes: [],
          postId: postId,
          publishedDate: DateTime.now(),
          posturl: imageUrl,
          profImage: profImage);
      await firestore.collection('posts').doc(postId).set(post.toJSON());
      res = 'success';
    } catch (error) {
      res = error.toString();
    }
    return res;
  }

  showSnackBar(BuildContext context, String content) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(content)));
  }

  Future<void> likePost(
      String uid, String postId, List likes, BuildContext context) async {
    try {
      if (likes.contains(uid)) {
        await firestore.collection('posts').doc(postId).update({
          'likes': FieldValue.arrayRemove([uid]),
        });
      } else {
        await firestore.collection('posts').doc(postId).update({
          'likes': FieldValue.arrayUnion([uid])
        });
      }
    } catch (error) {
      FirebaseMethods().showSnackBar(context, error.toString());
    }
  }

  Future<void> uploadComments(String postId, String name, String uid,
      String profilePic, String text) async {
    if (text.isNotEmpty) {
      String commentId = const Uuid().v1();
      await firestore
          .collection('posts')
          .doc(postId)
          .collection('comments')
          .doc(commentId)
          .set({
        'comment': text,
        'postId': postId,
        'username': name,
        'uid': uid,
        'profilePic': profilePic,
        'commentId': commentId,
        'datePublished': DateTime.now().toString()
      });
    }
  }

  Future deletePost(String postId, BuildContext context) async {
    try {
      await firestore.collection('posts').doc(postId).delete();
    } catch (error) {
      showSnackBar(context, error.toString());
    }
  }

  Future<void> followUser(String uid, String followId) async {
    try {
      DocumentSnapshot snap =
          await firestore.collection('users').doc(uid).get();
      List following = (snap.data()! as dynamic)['following'];
      if (following.contains(followId)) {
        await firestore.collection('users').doc(followId).update({
          'followers': FieldValue.arrayRemove([uid])
        });

        await firestore.collection('users').doc(uid).update({
          'following': FieldValue.arrayRemove([followId])
        });
      } else {
        firestore.collection('users').doc(followId).update({
          'followers': FieldValue.arrayUnion([uid])
        });
        firestore.collection('users').doc(uid).update({
          'followers': FieldValue.arrayUnion([followId])
        });
      }
    } catch (e) {
      print(e.toString());
    }
  }

  Future signOut() async {
    await FirebaseAuth.instance.signOut();
  }
}
