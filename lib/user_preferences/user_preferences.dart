import 'dart:convert';

import 'package:pizzeria/Users/model/user.dart';
import 'package:shared_preferences/shared_preferences.dart';
class RememberUser{
  //saves user information
  static Future<void> storeUserInfo(User userinfo)async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String userJsonData = json.encode(userinfo.toJson());
    await preferences.setString('currentUser', userJsonData);
  }

  //get user info
  static Future<User?> readUserInfo() async{
    User? currentUserInfo;
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String? userInfo = preferences.getString('currentUser');
    if(userInfo!=null) {
      Map<String, dynamic> userMap = json.decode(userInfo);
      currentUserInfo = User.fromJson(userMap);
    }
    return currentUserInfo;
  }

  static Future<void> removeUserData()async{
    SharedPreferences preference = await SharedPreferences.getInstance();
    await preference.remove('currentUser');
  }
}