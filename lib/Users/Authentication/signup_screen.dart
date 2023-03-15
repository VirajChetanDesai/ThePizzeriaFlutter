import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:pizzeria/Users/model/user.dart';
import 'package:pizzeria/api_connection/api_connection.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({Key? key}) : super(key: key);

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  var formKey = GlobalKey<FormState>();
  var nameController = TextEditingController();
  var emailController = TextEditingController();
  var passwordController = TextEditingController();
  var isobscure = true.obs;

  validateUserEmail() async {
    try {
      var res = await http.post(Uri.parse(API.validateEmail), body: {
        'user_email': emailController.text.trim(),
      });
      if (res.statusCode == 200) {
        var responseBodyValidateEmail = jsonDecode(res.body);
        if (responseBodyValidateEmail['emailFound']==true) {
          Fluttertoast.showToast(msg: "Email already in use");
        } else {
          registerAndSaveUserRecord();
        }
      }
    } catch (e) {
      print(e);
    }
  }
  registerAndSaveUserRecord()async{
    User userModel = User(
      nameController.text.trim(),
      emailController.text.trim(),
      passwordController.text.trim(),
    );
    try{
      var res = await http.post(
          Uri.parse(API.signup),
          body : userModel.toJson(),
      );
      if(res.statusCode == 200){
        var resBodySignUp = jsonDecode(res.body);
        if(resBodySignUp['success']==true){
          Fluttertoast.showToast(msg: "Signed Up Succesfully");
          setState(() {
            nameController.clear();
            emailController.clear();
            passwordController.clear();
          });
        }else{
          Fluttertoast.showToast(msg: "Error occurred try again");
        }
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
          builder: (context, cons) {
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
                      padding: const EdgeInsets.fromLTRB(40, 60, 40, 20),
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        height: 300,
                        child: const Icon(
                          Icons.local_pizza_outlined,
                          color: Colors.white,
                          size: 250,
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
                          boxShadow: [
                            BoxShadow(
                              blurRadius: 0,
                              color: Colors.black26,
                              offset: Offset(0, -3),
                            )
                          ],
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Form(
                              key: formKey,
                              child: Padding(
                                padding: EdgeInsets.fromLTRB(30, 30, 30, 10),
                                child: Column(
                                  children: <Widget>[
                                    TextFormField(
                                      textAlign: TextAlign.left,
                                      style: const TextStyle(
                                        color: Colors.black,
                                      ),
                                      controller: nameController,
                                      obscureText: false,
                                      validator: (val) {
                                        val == "" ? "Enter name" : null;
                                      },
                                      decoration: InputDecoration(
                                          prefixIcon: const Icon(
                                            Icons.person_outlined,
                                            color: Colors.black,
                                          ),
                                          hintText: "Enter Name",
                                          hintStyle: const TextStyle(
                                            color: Colors.black,
                                          ),
                                          border: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(30),
                                              borderSide: const BorderSide(
                                                color: Colors.white60,
                                              )),
                                          enabledBorder: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(30),
                                              borderSide: const BorderSide(
                                                color: Colors.white60,
                                              )),
                                          disabledBorder: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(30),
                                              borderSide: const BorderSide(
                                                color: Colors.white60,
                                              )),
                                          fillColor: Colors.white,
                                          filled: true,
                                          contentPadding:
                                              const EdgeInsets.symmetric(
                                                  vertical: 15,
                                                  horizontal: 30)),
                                    ),
                                    SizedBox(
                                      height: 20,
                                    ),
                                    TextFormField(
                                      textAlign: TextAlign.left,
                                      style: const TextStyle(
                                        color: Colors.black,
                                      ),
                                      controller: emailController,
                                      obscureText: false,
                                      validator: (val) {
                                        val == "" ? "Enter email" : null;
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
                                          borderRadius:
                                              BorderRadius.circular(30),
                                          borderSide: const BorderSide(
                                            color: Colors.white60,
                                          ),
                                        ),
                                        enabledBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(30),
                                          borderSide: const BorderSide(
                                            color: Colors.white60,
                                          ),
                                        ),
                                        disabledBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(30),
                                          borderSide: const BorderSide(
                                            color: Colors.white60,
                                          ),
                                        ),
                                        contentPadding:
                                            const EdgeInsets.symmetric(
                                          vertical: 15,
                                          horizontal: 30,
                                        ),
                                        fillColor: Colors.white,
                                        filled: true,
                                      ),
                                    ),
                                    SizedBox(
                                      height: 20.0,
                                    ),
                                    Obx(
                                      () => TextFormField(
                                        textAlign: TextAlign.left,
                                        style: const TextStyle(
                                          color: Colors.black,
                                        ),
                                        controller: passwordController,
                                        obscureText: isobscure.value,
                                        validator: (val) {
                                          val == "" ? "Enter Password" : null;
                                        },
                                        decoration: InputDecoration(
                                          prefixIcon: const Icon(
                                            Icons.vpn_key_outlined,
                                            color: Colors.black,
                                          ),
                                          suffixIcon: GestureDetector(
                                            onTap: () {
                                              isobscure.value =
                                                  !isobscure.value;
                                            },
                                            child: Icon(
                                              isobscure.value
                                                  ? Icons
                                                      .visibility_off_outlined
                                                  : Icons.visibility_outlined,
                                              color: Colors.black,
                                            ),
                                          ),
                                          hintText: "Enter password",
                                          hintStyle: const TextStyle(
                                            color: Colors.black,
                                          ),
                                          border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(30),
                                            borderSide: const BorderSide(
                                              color: Colors.white60,
                                            ),
                                          ),
                                          enabledBorder: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(30),
                                            borderSide: const BorderSide(
                                              color: Colors.white60,
                                            ),
                                          ),
                                          disabledBorder: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(30),
                                            borderSide: const BorderSide(
                                              color: Colors.white60,
                                            ),
                                          ),
                                          contentPadding:
                                              const EdgeInsets.symmetric(
                                            vertical: 15,
                                            horizontal: 30,
                                          ),
                                          fillColor: Colors.white,
                                          filled: true,
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 20.0,
                                    ),
                                    Material(
                                      color: Colors.black,
                                      borderRadius: BorderRadius.circular(30),
                                      child: InkWell(
                                        onTap: () {
                                          if (formKey.currentState!
                                              .validate()) {
                                            validateUserEmail();
                                          }
                                        },
                                        borderRadius: BorderRadius.circular(30),
                                        child: const Padding(
                                          padding: EdgeInsets.symmetric(
                                              vertical: 10, horizontal: 20),
                                          child: Text(
                                            "Sign Up",
                                            style: TextStyle(
                                              color: Colors.white,
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
                            const Text(
                              "OR",
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: 15,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                const Text("Already have an account?"),
                                TextButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  child: const Text(
                                    "Login",
                                    style: TextStyle(
                                      color: Colors.purpleAccent,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
            );
          },
        ));
  }
}
