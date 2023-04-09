import 'package:flutter/cupertino.dart';
import 'package:instagram_clone/models/user.dart';
import 'package:instagram_clone/services/auth_data.dart';

class UserProvider with ChangeNotifier {
  USer? _user;
  USer? getUSer() => _user;
  Future refereshUser() async {
    USer? user = await AuthData().getCurrentUSerDetails();
    if (user != null) {
      _user = user;
    }

    notifyListeners();
  }
}
