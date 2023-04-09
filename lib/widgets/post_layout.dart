import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:instagram_clone/models/user.dart';
import 'package:instagram_clone/providers/user_provider.dart';
import 'package:instagram_clone/responisve/colors.dart';
import 'package:instagram_clone/screens/comments_screen.dart';
import 'package:instagram_clone/services/firestore_methods.dart';
import 'package:instagram_clone/widgets/like_animation.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class Postlayout extends StatefulWidget {
  final Map<String, dynamic> snap;
  const Postlayout({super.key, required this.snap});

  @override
  State<Postlayout> createState() => _PostlayoutState();
}

class _PostlayoutState extends State<Postlayout> {
  int commentLen = 0;

  @override
  void initState() {
    super.initState();
    getCommentLength();
  }

  void getCommentLength() async {
    QuerySnapshot<Map<String, dynamic>> snapshotMe = await FirebaseFirestore
        .instance
        .collection('posts')
        .doc(widget.snap['postId'])
        .collection('comments')
        .get();
    commentLen = snapshotMe.docs.length;
  }

  @override
  Widget build(BuildContext context) {
    Provider.of<UserProvider>(context).refereshUser();
    final USer? user = Provider.of<UserProvider>(context).getUSer();
    bool isAnimating = false;
    final bool isContains = widget.snap['likes'].contains(user!.uid);
    return Container(
      padding: const EdgeInsets.symmetric(
        vertical: 16,
        horizontal: 10,
      ),
      color: mobileBackgroundColor,
      child: Column(
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 16,
                backgroundImage: NetworkImage(widget.snap['profImage']),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(left: 8),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.snap['username'],
                        style: const TextStyle(fontSize: 14),
                      ),
                    ],
                  ),
                ),
              ),
              IconButton(
                  onPressed: () {
                    showDialog(
                        context: context,
                        builder: (context) {
                          return Dialog(
                            child: ListView(
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shrinkWrap: true,
                              children: ['delete']
                                  .map(
                                    (e) => InkWell(
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 12, horizontal: 16),
                                        child: Text(e),
                                      ),
                                      onTap: () async {
                                        FirebaseMethods().deletePost(
                                            widget.snap['postId'], context);
                                        Navigator.of(context).pop();
                                      },
                                    ),
                                  )
                                  .toList(),
                            ),
                          );
                        });
                  },
                  icon: const Icon(Icons.more_vert)),
            ],
          ),
          GestureDetector(
            onDoubleTap: () async {
              setState(() {
                isAnimating = true;
              });
              FirebaseMethods().likePost(user.uid, widget.snap['postId'],
                  widget.snap['likes'], context);
            },
            child: Stack(
              alignment: Alignment.center,
              children: [
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.35,
                  width: double.infinity,
                  child: Image.network(
                    widget.snap['postUrl'],
                    fit: BoxFit.cover,
                  ),
                ),
                AnimatedOpacity(
                  duration: const Duration(milliseconds: 200),
                  opacity: isAnimating ? 1 : 0,
                  child: LikeAnimation(
                      isAnimating: isAnimating,
                      duration: const Duration(milliseconds: 400),
                      onEnd: () => setState(() {
                            isAnimating = false;
                          }),
                      child: const Icon(
                        Icons.favorite,
                        color: Color.fromARGB(255, 255, 255, 255),
                        size: 120,
                      )),
                ),
              ],
            ),
          ),
          Row(
            children: [
              LikeAnimation(
                  smallLike: true,
                  isAnimating: isContains,
                  child: IconButton(
                      onPressed: () {},
                      icon: Icon(
                        isContains ? Icons.favorite : Icons.favorite_border,
                        color: Colors.red,
                      ))),
              IconButton(
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => CommentsScreen(
                              postId: widget.snap['postId'].toString(),
                            )));
                  },
                  icon: const Icon(Icons.comment_outlined)),
              IconButton(onPressed: () {}, icon: const Icon(Icons.send)),
              Expanded(
                  child: Align(
                      alignment: Alignment.bottomRight,
                      child: IconButton(
                          onPressed: () {},
                          icon: const Icon(Icons.bookmark_border)))),
            ],
          ),
          //for Description and comments
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                DefaultTextStyle(
                  style: Theme.of(context)
                      .textTheme
                      .subtitle2!
                      .copyWith(fontWeight: FontWeight.w800),
                  child: Text(
                    '${widget.snap['likes'].length}. likes',
                    style: Theme.of(context).textTheme.bodyText2,
                    textAlign: TextAlign.start,
                  ),
                ),
                Container(
                    padding: const EdgeInsets.only(top: 8),
                    alignment: Alignment.topLeft,
                    child: RichText(
                      text: TextSpan(
                          style: const TextStyle(color: primaryColor),
                          children: [
                            TextSpan(
                              text: widget.snap['username'],
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold),
                            ),
                            TextSpan(text: ' ${widget.snap['description']}')
                          ]),
                    )),
                InkWell(
                  onTap: () {},
                  child: Container(
                    alignment: Alignment.topLeft,
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: Text(
                      'View all $commentLen comments',
                      textAlign: TextAlign.start,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: secondaryColor,
                      ),
                    ),
                  ),
                ),
                Container(
                  alignment: Alignment.topLeft,
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Text(
                    DateFormat.yMMMEd()
                        .format(widget.snap['publishedDate'].toDate()),
                    textAlign: TextAlign.start,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: secondaryColor,
                    ),
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
