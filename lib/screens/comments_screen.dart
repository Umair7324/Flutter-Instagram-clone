// ignore_for_file: prefer_typing_uninitialized_variables

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:instagram_clone/models/user.dart';
import 'package:instagram_clone/providers/user_provider.dart';
import 'package:instagram_clone/responisve/colors.dart';
import 'package:instagram_clone/services/firestore_methods.dart';
import 'package:instagram_clone/widgets/comments_card.dart';
import 'package:provider/provider.dart';

class CommentsScreen extends StatefulWidget {
  final postId;
  const CommentsScreen({super.key, required this.postId});

  @override
  State<CommentsScreen> createState() => _CommentsScreenState();
}

class _CommentsScreenState extends State<CommentsScreen> {
  final TextEditingController textController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    textController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final USer? user =
        Provider.of<UserProvider>(context, listen: false).getUSer();
    return Scaffold(
      appBar: AppBar(
        backgroundColor: mobileBackgroundColor,
        title: const Text(
          'Comments',
        ),
        centerTitle: false,
      ),
      body: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection('posts')
              .doc(widget.postId)
              .collection('comments')
              .snapshots(),
          builder: ((context,
              AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            return ListView.builder(
                itemCount: snapshot.data!.docs.length,
                itemBuilder: ((context, index) =>
                    CommentsCard(snap: snapshot.data!.docs[index].data())));
          })),
      bottomNavigationBar: SafeArea(
          child: SizedBox(
        height: kToolbarHeight,
        child: Row(
          children: [
            CircleAvatar(
              backgroundImage: NetworkImage(
                user!.photoUrl,
              ),
              radius: 18,
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(left: 16, right: 8),
                child: TextField(
                  decoration: InputDecoration(
                      hintText: 'Comment as ${user.name}',
                      border: InputBorder.none),
                  controller: textController,
                ),
              ),
            ),
            TextButton(
                onPressed: () {
                  FirebaseMethods().uploadComments(widget.postId, user.name,
                      user.uid, user.photoUrl, textController.text);
                  setState(() {
                    textController.text = '';
                  });
                },
                child: const Text(
                  'Post',
                  style: TextStyle(color: Colors.blueAccent),
                ))
          ],
        ),
      )),
    );
  }
}
