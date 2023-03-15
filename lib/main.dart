import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pizzeria/Users/Authentication/login_screen.dart';
import 'package:pizzeria/Users/fragments/dashboard_fragments.dart';
import 'package:pizzeria/user_preferences/user_preferences.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(Pizzeria());
}

class Pizzeria extends StatefulWidget {
  const Pizzeria({Key? key}) : super(key: key);

  @override
  State<Pizzeria> createState() => _PizzeriaState();
}

class _PizzeriaState extends State<Pizzeria> {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Manipal Pizzeria',
      theme: ThemeData.dark(),
      home: FutureBuilder(
        future: RememberUser.readUserInfo(),
        builder: (context,datasnapshot){
          if(datasnapshot.data == null) {return LoginScreen();}
          else{
            return DashBoardOfFragments();
          }
        },
    )
    );
  }
}



