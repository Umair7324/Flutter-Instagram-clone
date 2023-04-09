// ignore_for_file: file_names
import 'package:flutter/material.dart';
import 'package:instagram_clone/models/user.dart';
import 'package:instagram_clone/providers/user_provider.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    addDAta();
  }

  addDAta() async {
    return Provider.of<UserProvider>(context, listen: false).refereshUser();
  }

  @override
  Widget build(BuildContext context) {
    USer? user = Provider.of<UserProvider>(context).getUSer();

    return Scaffold(
      body: SizedBox(
        height: MediaQuery.of(context).size.height,
        child: Center(
          child: Text(user!.email),
        ),
      ),
    );
  }
}
