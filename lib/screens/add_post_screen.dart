import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:instagram_clone/providers/user_provider.dart';
import 'package:instagram_clone/services/firestore_methods.dart';
import 'package:instagram_clone/utills/pick_image.dart';
import 'package:provider/provider.dart';
import '../models/user.dart';

class AddPostScreen extends StatefulWidget {
  const AddPostScreen({super.key});
  @override
  State<AddPostScreen> createState() => _AddPostScreenState();
}

class _AddPostScreenState extends State<AddPostScreen> {
  Uint8List? _file;
  bool _isLoading = false;
  final TextEditingController _descriptionController = TextEditingController();

  Future<String> uploadImage(
      String username, String uid, String profImage) async {
    String res = 'Some error accured';
    try {
      FirebaseMethods().uplaodPost(
          username, _file!, uid, _descriptionController.text, profImage);
      setState(() {
        _isLoading = true;
      });
      if (res == 'success') {
        setState(() {
          _isLoading = false;
        });
        FirebaseMethods().showSnackBar(context, 'posted');
        clearImage();
      } else {
        setState(() {
          _isLoading = false;
        });
        FirebaseMethods().showSnackBar(context, res);
        clearImage();
      }
    } catch (error) {
      FirebaseMethods().showSnackBar(context, error.toString());
    }
    return res;
  }

  pickImagePost(BuildContext context) async {
    return showDialog(
        context: context,
        builder: (context) {
          return SimpleDialog(
            title: const Text(
              'Create a Post',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            children: [
              SimpleDialogOption(
                padding: const EdgeInsets.all(20),
                child: const Text('Take a Photo'),
                onPressed: () async {
                  Navigator.of(context).pop();
                  Uint8List file = await pickImage(ImageSource.camera);
                  setState(() {
                    _file = file;
                  });
                },
              ),
              SimpleDialogOption(
                padding: const EdgeInsets.all(20),
                child: const Text('Choose from gallery'),
                onPressed: () async {
                  Navigator.of(context).pop();
                  Uint8List file = await pickImage(ImageSource.gallery);
                  setState(() {
                    _file = file;
                  });
                },
              ),
              SimpleDialogOption(
                padding: const EdgeInsets.all(20),
                child: const Text('Cancel'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              )
            ],
          );
        });
  }

  @override
  void initState() {
    super.initState();
    refreshUser();
  }

  void clearImage() {
    setState(() {
      _file = null;
    });
  }

  @override
  void dispose() {
    super.dispose();
    _descriptionController.dispose();
  }

  void refreshUser() async {
    await Provider.of<UserProvider>(context, listen: false).refereshUser();
  }

  @override
  Widget build(BuildContext context) {
    USer? user = Provider.of<UserProvider>(context).getUSer();
    return _file == null
        ? Center(
            child: IconButton(
                onPressed: () => pickImagePost(context),
                icon: const Icon(Icons.add_a_photo)),
          )
        : Scaffold(
            appBar: AppBar(
              leading: IconButton(
                  onPressed: clearImage, icon: const Icon(Icons.arrow_back)),
              title: const Text(
                'Post to',
              ),
              centerTitle: false,
              actions: [
                TextButton(
                    onPressed: () => uploadImage(user!.name, user.uid,
                        user.photoUrl != '' ? user.photoUrl : ''),
                    child: const Text(
                      'Post',
                      style: TextStyle(
                          color: Colors.blueAccent,
                          fontWeight: FontWeight.bold,
                          fontSize: 16),
                    ))
              ],
            ),
            body: Column(
              children: [
                _isLoading ? const LinearProgressIndicator() : Container(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CircleAvatar(
                      backgroundImage: NetworkImage(user!.photoUrl),
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.3,
                      child: TextField(
                        controller: _descriptionController,
                        decoration: const InputDecoration(
                            hintText: 'Write a caption...',
                            border: InputBorder.none),
                        maxLines: 8,
                      ),
                    ),
                    SizedBox(
                      height: 45,
                      width: 45,
                      child: AspectRatio(
                        aspectRatio: 487 / 451,
                        child: Container(
                          decoration: BoxDecoration(
                              image: DecorationImage(
                                  image: MemoryImage(_file!),
                                  fit: BoxFit.cover,
                                  alignment: FractionalOffset.topCenter)),
                        ),
                      ),
                    )
                  ],
                )
              ],
            ),
          );
  }
}
