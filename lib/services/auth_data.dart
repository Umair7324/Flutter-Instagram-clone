import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:instagram_clone/models/user.dart';
import 'package:instagram_clone/services/file_storage.dart';

class AuthData {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;
  Future<void> userSignup(
      {required String userName,
      required String userEMail,
      required String userPAssword,
      required String userBio,
      Uint8List? file}) async {
    if (userName.isNotEmpty ||
        userEMail.isNotEmpty ||
        userPAssword.isNotEmpty ||
        userBio.isNotEmpty ||
        file!.isNotEmpty) {
      final craetedUSer = await _auth.createUserWithEmailAndPassword(
          email: userEMail, password: userPAssword);

      String url =
          await Firebasestorage().uploadFile('ProfilePic', file!, false);
      USer user = USer(
          name: userName,
          email: userEMail,
          bio: userBio,
          uid: craetedUSer.user!.uid,
          photoUrl: url,
          followers: [],
          following: []);
      await _firestore
          .collection('users')
          .doc(craetedUSer.user!.uid)
          .set(user.toJSON());
    }
  }

  Future<void> userSignIn(
      {required String userEmail, required String userPassword}) async {
    if (userEmail.isNotEmpty || userPassword.isNotEmpty) {
      await _auth.signInWithEmailAndPassword(
          email: userEmail, password: userPassword);
    }
  }

  Future<USer?> getCurrentUSerDetails() async {
    User? currentUSer = FirebaseAuth.instance.currentUser;
    DocumentSnapshot snapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(currentUSer!.uid)
        .get();
    return USer.fromSNap(snapshot);
  }
}
