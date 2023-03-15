import 'package:flutter/material.dart';
import 'package:pizzeria/Users/Authentication/login_screen.dart';
import 'package:pizzeria/Users/model/user.dart';
import 'package:pizzeria/user_preferences/current_user.dart';
import 'package:get/get.dart';
import 'package:pizzeria/user_preferences/user_preferences.dart';
class ProfileFragmentScreen extends StatelessWidget {
  final currentUser _user = Get.put(currentUser());
  logOut() async {
    var resp = await Get.dialog(
      AlertDialog(backgroundColor: Colors.grey,
        title: const Text('Log Out',style: TextStyle(fontSize: 16.0,fontWeight: FontWeight.bold),),
        content: const Text('Confirm User logout'),
        actions: [
          TextButton(onPressed: (){Get.back(result: "LOGOUT");}, child: const Text("Yes",style: TextStyle(color: Colors.black),)),
          TextButton(onPressed: (){Get.back();}, child: const Text("No",style: TextStyle(color: Colors.black),)),
        ],
        ),
    );
    if(resp == 'LOGOUT') {
      RememberUser.removeUserData().then((value) =>
          Get.off(const LoginScreen()));
    }
  }
  @override
  Widget userInfoItemProfile(IconData iconData,String userData){
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0,horizontal: 16.0),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12.0),
          color: Colors.black,
        ),
        padding : const EdgeInsets.symmetric(
          horizontal: 20.0,
          vertical: 20.0,
        ),
        child: Row(
          children: [
            Icon(iconData,size: 30,color: Colors.white,),
            const SizedBox(width: 16.0,),
            Text(userData,style: const TextStyle(
              fontSize: 15,
            ),),
          ],
        ),
      ),
    );
  }
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Center(child: Text('Profile'),),
        automaticallyImplyLeading: false,
      ),
      body: ListView(
        children: [
          const SizedBox(height: 40,),
          Center(
            child: Image.asset(
              'images/man.png',
              width: 200,
            ),
          ),
          const SizedBox(height: 20,),
          userInfoItemProfile(Icons.person,_user.user.user_name),
          const SizedBox(height: 20,),
          userInfoItemProfile(Icons.email,_user.user.user_email),
          const SizedBox(height: 20,),
          Center(
            child: Material(
              color: Colors.lightBlueAccent,
              borderRadius: BorderRadius.circular(12),
              child: InkWell(
                onTap: (){logOut();},
                borderRadius: BorderRadius.circular(32),
                child: const Padding(
                  padding: EdgeInsets.symmetric(
                    vertical: 20,
                    horizontal: 30,
                  ),
                  child: Text("Log Out",style: TextStyle(fontSize: 16.0,color: Colors.white,),),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
