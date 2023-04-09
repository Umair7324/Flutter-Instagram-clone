// ignore_for_file: use_build_context_synchronously

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:instagram_clone/responisve/colors.dart';
import 'package:instagram_clone/services/auth_data.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:instagram_clone/utills/pick_image.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final formKey = GlobalKey<FormState>();
  String email = '';
  String userName = '';
  String passWord = '';
  String bio = '';
  Uint8List? _selectedImage;
  bool isLoading = false;

  var isLogin = true;

  void onSubmitForm() async {
    final isValid = formKey.currentState!.validate();
    FocusScope.of(context).unfocus();
    if (isValid) {
      if (email.isEmpty ||
          userName.isEmpty ||
          passWord.isEmpty ||
          bio.isEmpty) {
        return;
      }
      formKey.currentState!.save();
      if (!isLogin) {
        setState(() {
          isLoading = true;
        });
        await AuthData().userSignup(
            userName: userName,
            userEMail: email,
            userPAssword: passWord,
            userBio: bio,
            file: _selectedImage);
        setState(() {
          isLoading = false;
        });
      } else {
        setState(() {
          isLoading = true;
        });
        await AuthData().userSignIn(userEmail: email, userPassword: passWord);
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  void pickedImage() async {
    Uint8List img = await pickImage(ImageSource.gallery);
    setState(() {
      _selectedImage = img;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        margin: const EdgeInsets.symmetric(vertical: 80),
        height: MediaQuery.of(context).size.height,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Form(
            key: formKey,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Flexible(
                    flex: -1,
                    fit: FlexFit.loose,
                    child: Container(),
                  ),
                  SvgPicture.asset(
                    'assets/ic_instagram.svg',
                    height: 64,
                    color: primaryColor,
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  if (!isLogin)
                    Stack(
                      children: [
                        _selectedImage != null
                            ? CircleAvatar(
                                radius: 64,
                                backgroundImage: MemoryImage(_selectedImage!),
                              )
                            : const CircleAvatar(
                                radius: 64,
                                backgroundImage: NetworkImage(
                                    'https://www.shutterstock.com/image-vector/default-avatar-profile-icon-vector-600w-1725655669.jpg'),
                              ),
                        Positioned(
                          bottom: -10,
                          left: 80,
                          child: IconButton(
                              onPressed: pickedImage,
                              icon: const Icon(Icons.add_a_photo)),
                        )
                      ],
                    ),
                  const SizedBox(
                    height: 20,
                  ),
                  TextFormField(
                    decoration: const InputDecoration(
                      label: Text('Email'),
                    ),
                    textInputAction: TextInputAction.next,
                    keyboardType: TextInputType.emailAddress,
                    onChanged: (value) => email = value.toString(),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  if (!isLogin)
                    TextFormField(
                      decoration:
                          const InputDecoration(label: Text('UserName')),
                      onChanged: (value) => userName = value.toString(),
                    ),
                  const SizedBox(
                    height: 10,
                  ),
                  TextFormField(
                    decoration: const InputDecoration(label: Text('Password')),
                    obscureText: true,
                    onChanged: (newValue) => passWord = newValue.toString(),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  if (!isLogin)
                    TextFormField(
                      decoration:
                          const InputDecoration(label: Text('Enter your Bio')),
                      onChanged: (value) => bio = value.toString(),
                    ),
                  const SizedBox(
                    height: 10,
                  ),
                  ElevatedButton(
                      onPressed: onSubmitForm,
                      child: isLoading
                          ? const Center(
                              child: CircularProgressIndicator(
                                color: primaryColor,
                              ),
                            )
                          : Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 80),
                              child: Text(
                                isLogin ? 'Login' : 'SignUp',
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 26,
                                    fontFamily: 'poppins',
                                    color: primaryColor),
                              ),
                            )),
                  TextButton(
                    onPressed: () {
                      setState(() {
                        isLogin = !isLogin;
                      });
                    },
                    child: Text(
                      isLogin
                          ? 'Create an account'
                          : 'I already have an account',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: secondaryColor,
                        backgroundColor: mobileBackgroundColor,
                      ),
                    ),
                  ),
                ],
              ),
            )),
      ),
    );
  }
}
