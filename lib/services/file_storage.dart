import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:uuid/uuid.dart';

class Firebasestorage {
  final FirebaseStorage _storage = FirebaseStorage.instance;

  final _auth = FirebaseAuth.instance;

  Future<String> uploadFile(
    String childName,
    Uint8List file,
    bool isPost,
  ) async {
    Reference ref =
        _storage.ref().child(childName).child('${_auth.currentUser!.uid}.jpg');

    if (isPost) {
      String id = const Uuid().v1();
      ref = ref.child(id);
    }
    UploadTask uploadTask = ref.putData(file);
    TaskSnapshot snapShot = await uploadTask;
    String urlDownload = await snapShot.ref.getDownloadURL();
    return urlDownload;
  }
}
