import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:pizzeria/Admin/admin_upload_screen.dart';
import 'package:pizzeria/Users/Authentication/login_screen.dart';
import 'package:pizzeria/Users/Authentication/signup_screen.dart';
import 'package:pizzeria/Users/fragments/dashboard_fragments.dart';
import 'package:pizzeria/Users/model/user.dart';
import 'package:pizzeria/api_connection/api_connection.dart';
import 'package:pizzeria/user_preferences/user_preferences.dart';
class AdminLoginScreen extends StatefulWidget {
  const AdminLoginScreen({Key? key}) : super(key: key);

  @override
  State<AdminLoginScreen> createState() => _AdminLoginScreenState();
}

class _AdminLoginScreenState extends State<AdminLoginScreen> {
  var formKey = GlobalKey<FormState>();
  var emailController = TextEditingController();
  var passwordController = TextEditingController();
  var isobscure = true.obs;
  loginAdmin()async{
    try{
      var res = await http.post(
          Uri.parse(API.adminLogin),
          body: {
            'admin_email':emailController.text.trim(),
            'admin_password':passwordController.text.trim(),
          }
      );
      print(res.body);
      if(res.statusCode == 200){
        var resBodyLogIn = jsonDecode(res.body);
        print(resBodyLogIn);
        if(resBodyLogIn['success'] == true){
          Fluttertoast.showToast(msg: 'Login Successful');

          Get.to(()=> const AdminUploadItemScreen());
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
                      padding: const EdgeInsets.fromLTRB(40,60,40,0),
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        height: 300,
                        child:const Hero(
                          tag: 'fire',
                          child: Icon(
                            Icons.local_pizza_outlined,
                            color: Colors.white,
                            size: 225,
                          ),
                        ),
                      ),
                    ),
                    const Center(
                      child: Padding(
                        padding: EdgeInsets.fromLTRB(40,60,40,20),
                        child: Text('Adminstrator Login',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),),
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
                                            loginAdmin();
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
                                const Text("I am not an admin"),
                                TextButton(
                                  onPressed: (){Get.to(LoginScreen());},
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
