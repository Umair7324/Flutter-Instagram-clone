import 'package:cloud_firestore/cloud_firestore.dart';

class USer {
  final String name;
  final String email;
  final String bio;
  final String uid;
  final String photoUrl;
  final List followers;
  final List following;

  USer(
      {required this.name,
      required this.email,
      required this.bio,
      required this.uid,
      required this.photoUrl,
      required this.followers,
      required this.following});

  Map<String, dynamic> toJSON() => {
        'username': name,
        'email': email,
        'uid': uid,
        'bio': bio,
        'followers': followers,
        'following': following,
        'photoUrl': photoUrl,
      };

  static USer fromSNap(DocumentSnapshot snapshot) {
    Object snap = snapshot.data() as Map<String, dynamic>;
    return USer(
        name: (snap as Map<String, dynamic>)['username'],
        email: (snap)['email'],
        bio: (snap)['bio'],
        uid: (snap)['uid'],
        photoUrl: (snap)['photoUrl'],
        followers: (snap)['followers'],
        following: (snap)['following']);
  }
}
