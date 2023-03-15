import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pizzeria/Users/model/user.dart';
import 'package:pizzeria/user_preferences/user_preferences.dart';
class currentUser extends GetxController{
  Rx<User> _currentUser = User('','','').obs;
  User get user => _currentUser.value;
  GetUserInfo()async{
    User? getUserInfoLocalStorage = await RememberUser.readUserInfo();
    _currentUser.value = getUserInfoLocalStorage!;
  }
}