import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:pizzeria/Admin/admin_login.dart';
import 'package:pizzeria/Users/Authentication/signup_screen.dart';
import 'package:pizzeria/Users/fragments/dashboard_fragments.dart';
import 'package:pizzeria/Users/model/user.dart';
import 'package:pizzeria/api_connection/api_connection.dart';
import 'package:pizzeria/user_preferences/user_preferences.dart';
class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  var formKey = GlobalKey<FormState>();
  var emailController = TextEditingController();
  var passwordController = TextEditingController();
  var isobscure = true.obs;
  loginUser()async{
    try{
      var res = await http.post(
          Uri.parse(API.login),
        body: {
            'user_email':emailController.text.trim(),
            'user_password':passwordController.text.trim(),
        }
      );
      print(res.body);
      if(res.statusCode == 200){
        var resBodyLogIn = json.decode(res.body);
        if(resBodyLogIn['success'] == true){
          Fluttertoast.showToast(msg: 'Login Successful');
          User userInfo = User.fromJson(resBodyLogIn['userData']);
          await RememberUser.storeUserInfo(userInfo);
          Get.to(()=> DashBoardOfFragments());
        }else{
          Fluttertoast.showToast(msg: 'Invalid Email or Password');
        }

      }else{
        Fluttertoast.showToast(msg: 'Login Failed');
      }
    }catch(e){
      print(e);
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: LayoutBuilder(
        builder: (context,cons){
          return ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: cons.maxHeight,
              ),
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.fromLTRB(40,60,40,20),
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      height: 300,
                      child:const Hero(
                        tag: 'fire',
                        child: Icon(
                          Icons.local_pizza_outlined,
                          color: Colors.white,
                          size: 250,
                        ),
                      ),
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Container(
                      decoration: const BoxDecoration(
                        color: Colors.white10,
                        borderRadius: BorderRadius.all(
                          Radius.circular(60),
                        ),
                        boxShadow: [BoxShadow(
                          blurRadius: 0,
                          color: Colors.black26,
                          offset: Offset(0,-3),
                        )],
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Form(
                            key: formKey,
                            child: Padding(
                              padding: EdgeInsets.fromLTRB(30,30,30,5),
                              child: Column(
                                children: <Widget>[
                                  TextFormField(
                                    textAlign: TextAlign.left,
                                    style: TextStyle(
                                      color: Colors.black,
                                    ),
                                    controller: emailController,
                                    obscureText: false,
                                    validator: (val){
                                      val == ""?"Enter email":null;
                                    },
                                    decoration: InputDecoration(
                                      prefixIcon: const Icon(
                                        Icons.email_outlined,
                                        color: Colors.black,
                                      ),
                                      hintText: "Enter Email",
                                      hintStyle: const TextStyle(
                                        color: Colors.black,
                                      ),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(30),
                                        borderSide: const BorderSide(
                                          color: Colors.white60,
                                        ),
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(30),
                                        borderSide: const BorderSide(
                                          color: Colors.white60,
                                        ),

                                      ),
                                      disabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(30),
                                        borderSide: const BorderSide(
                                          color: Colors.white60,
                                        ),
                                      ),
                                      contentPadding: const EdgeInsets.symmetric(
                                        vertical: 15,
                                        horizontal: 30,
                                      ),
                                      fillColor: Colors.white,
                                      filled:true,
                                    ),
                                  ),
                                  SizedBox(height: 20.0,),
                                  Obx(()=> TextFormField(
                                      textAlign: TextAlign.left,
                                      style: const TextStyle(
                                        color: Colors.black,
                                      ),
                                      controller: passwordController,
                                      obscureText: isobscure.value,
                                      validator: (val){
                                        val == "" ? "Enter Password":null;
                                      },
                                      decoration: InputDecoration(
                                        prefixIcon: const Icon(
                                          Icons.vpn_key_outlined,
                                          color: Colors.black,
                                        ),
                                        suffixIcon: GestureDetector(
                                          onTap:(){
                                            isobscure.value = !isobscure.value;
                                          },
                                          child: Icon(
                                            isobscure.value? Icons.visibility_off_outlined:Icons.visibility_outlined,
                                            color: Colors.black,
                                          ),
                                        ),
                                        hintText: "Enter password",
                                        hintStyle: const TextStyle(
                                          color: Colors.black,
                                        ),
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(30),
                                          borderSide: const BorderSide(
                                            color: Colors.white60,
                                          ),
                                        ),
                                        enabledBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(30),
                                          borderSide: const BorderSide(
                                            color: Colors.white60,
                                          ),

                                        ),
                                        disabledBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(30),
                                          borderSide: const BorderSide(
                                            color: Colors.white60,
                                          ),
                                        ),
                                        contentPadding: const EdgeInsets.symmetric(
                                          vertical: 15,
                                          horizontal: 30,
                                        ),
                                        fillColor: Colors.white,
                                        filled:true,
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 20.0,),
                                  Material(
                                    color:Colors.black,
                                    borderRadius: BorderRadius.circular(30),
                                    child: InkWell(
                                      onTap: (){
                                        if(formKey.currentState!.validate()) {
                                          loginUser();
                                        }
                                      },
                                      borderRadius: BorderRadius.circular(30),
                                      child: const Padding(
                                        padding: EdgeInsets.symmetric(vertical: 10,horizontal: 20),
                                        child: Text(
                                          "Login",
                                          style: TextStyle(
                                            color:Colors.white,
                                            fontSize: 16,
                                          ),
                                        ),
                                      ),
                                    ),

                                  ),
                                ],
                              ),
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              const Text("Dont have an account?"),
                              TextButton(
                                  onPressed: (){
                                    Navigator.push(context, MaterialPageRoute(builder: (context)=>const SignupScreen()));
                                  },
                                  child: const Text(
                                    "Sign Up",
                                    style: TextStyle(
                                      color: Colors.purpleAccent,
                                    ),
                                  ),
                              ),
                            ],
                          ),
                          const Text("OR",style: TextStyle(
                            color: Colors.grey,
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                          ),),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              const Text("Adminstrator Login"),
                              TextButton(
                                onPressed: (){Get.to(const AdminLoginScreen());},
                                child: const Text(
                                  "Click Here",
                                  style: TextStyle(
                                    color: Colors.purpleAccent,
                                  ),
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
          );
        },
    )
    );
  }
}
