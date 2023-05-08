import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pizzeria/Admin/admin_login.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:pizzeria/Admin/item_edit_screen.dart';
import 'package:pizzeria/Users/model/item.dart';
import 'package:pizzeria/api_connection/api_connection.dart';

class ItemEditForm extends StatefulWidget {
  String? adminEmail;
  Item? item;
  ItemEditForm(this.item, this.adminEmail,{super.key});

  @override
  State<ItemEditForm> createState() => _ItemEditFormState();
}

class _ItemEditFormState extends State<ItemEditForm> {
  var formKey = GlobalKey<FormState>();
  var nameController = TextEditingController();
  var ratingController = TextEditingController();
  var tagsController = TextEditingController();
  var priceController = TextEditingController();
  var sizeController = TextEditingController();
  var baseController = TextEditingController();
  var descriptionController = TextEditingController();
  var imageLink = "";
  updateRecord()async{
    List<String> tagsList = tagsController.text.split(',');
    List<String> sizeList = sizeController.text.split(',');
    List<String> baseList = baseController.text.split(',');
    try{
      var res = await http.post(
          Uri.parse(API.updateItem),
          body: {
            "item_id": widget.item!.item_id.toString(),
            "name": nameController.text.toString().trim(),
            "rating": ratingController.text.toString().trim(),
            "tags": tagsList.toString(),
            "price": priceController.text.toString().trim(),
            "pizza_size": sizeList.toString(),
            "pizza_base": baseList.toString(),
            "description": descriptionController.text.toString(),
            "image": widget.item!.image!.toString(),
            "admin_email": widget.adminEmail.toString(),
          }
      );
      print(res.body);
      if (res.statusCode == 200){
        var resbody = jsonDecode(res.body);
        if(resbody['success'] = true){
          Fluttertoast.showToast(msg: "Update Succesful");
        }else{
          Fluttertoast.showToast(msg: "Update Unsuccesful");
        }
      }else{
        Fluttertoast.showToast(msg: "Database Unavailable");
      }
    }catch(e) {
      print(e);
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:const Center(
          child: Text(
            "Edit Form",
            style: TextStyle(
              color: Colors.white,
            ),
            textAlign: TextAlign.center,
          ),
        ),
        automaticallyImplyLeading: false,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.bottomLeft,
              end: Alignment.topCenter,
              colors: [Colors.purpleAccent, Colors.deepPurple],
            ),
          ),
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Colors.deepPurple, Colors.purpleAccent]),
        ),
        child: ListView(children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Form(
                key: formKey,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(30, 30, 30, 5),
                  child: Column(
                    children: [
                      TextFormField(
                        textAlign: TextAlign.left,
                        style: TextStyle(
                          color: Colors.black,
                        ),
                        controller: nameController
                          ..text = widget.item!.pizza_name!,
                        obscureText: false,
                        validator: (val) {
                          val == "" ? "Enter Item Name" : null;
                        },
                        decoration: InputDecoration(
                          prefixIcon: const Icon(
                            Icons.title_outlined,
                            color: Colors.black,
                          ),
                          hintText: "Enter Item Name",
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
                          filled: true,
                        ),
                      ),
                      const SizedBox(height: 20.0,),
                      //rating
                      TextFormField(
                        textAlign: TextAlign.left,
                        style: const TextStyle(
                          color: Colors.black,
                        ),
                        controller: ratingController..text = widget.item!.rating!.toString(),
                        obscureText: false,
                        validator: (val){
                          val == ""?"Enter Item Rating":null;
                        },
                        decoration: InputDecoration(
                          prefixIcon: const Icon(
                            Icons.star_border_outlined ,
                            color: Colors.black,
                          ),
                          hintText: "Enter Item Rating",
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
                      const SizedBox(height: 20.0,),
                      //tags
                      TextFormField(
                        textAlign: TextAlign.left,
                        style: const TextStyle(
                          color: Colors.black,
                        ),
                        controller: tagsController..text = widget.item!.tags!.toString().replaceAll('[', '').replaceAll(']', ''),
                        obscureText: false,
                        validator: (val){
                          val == ""?"Enter Item Tags":null;
                        },
                        decoration: InputDecoration(
                          prefixIcon: const Icon(
                            Icons.tag_outlined,
                            color: Colors.black,
                          ),
                          hintText: "Enter Item tags",
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
                      const SizedBox(height: 20.0,),
                      //price
                      TextFormField(
                        textAlign: TextAlign.left,
                        style: const TextStyle(
                          color: Colors.black,
                        ),
                        controller: priceController..text = widget.item!.price!.toString(),
                        obscureText: false,
                        validator: (val){
                          val == ""?"Enter Item Price":null;
                        },
                        decoration: InputDecoration(
                          prefixIcon: const Icon(
                            Icons.price_change_outlined,
                            color: Colors.black,
                          ),
                          hintText: "Enter Item Price",
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
                      const SizedBox(height: 20.0,),
                      //item Size S M L
                      TextFormField(
                        textAlign: TextAlign.left,
                        style: const TextStyle(
                          color: Colors.black,
                        ),
                        controller: sizeController..text = widget.item!.base_size!.toString().replaceAll('[', '').replaceAll(']', ''),
                        obscureText: false,
                        validator: (val){
                          val == ""?"Enter Item Sizes":null;
                        },
                        decoration: InputDecoration(
                          prefixIcon: const Icon(
                            Icons.picture_in_picture_outlined,
                            color: Colors.black,
                          ),
                          hintText: "Enter Item Sizes",
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
                      const SizedBox(height: 20.0,),
                      //item Base PAN,HANDTOSSED
                      TextFormField(
                        textAlign: TextAlign.left,
                        style: const TextStyle(
                          color: Colors.black,
                        ),
                        controller: baseController..text = widget.item!.base_style!.toString().replaceAll('[', '').replaceAll(']', ''),
                        obscureText: false,
                        validator: (val){
                          val == ""?"Enter Item Base":null;
                        },
                        decoration: InputDecoration(
                          prefixIcon: const Icon(
                            Icons.local_pizza_outlined,
                            color: Colors.black,
                          ),
                          hintText: "Enter Item Base",
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
                      const SizedBox(height: 20.0,),
                      //item description
                      TextFormField(
                        textAlign: TextAlign.left,
                        style: const TextStyle(
                          color: Colors.black,
                        ),
                        controller: descriptionController..text = widget.item!.description!,
                        obscureText: false,
                        validator: (val){
                          val == ""?"Enter Item Description":null;
                        },
                        decoration: InputDecoration(
                          prefixIcon: const Icon(
                            Icons.rate_review_outlined,
                            color: Colors.black,
                          ),
                          hintText: "Enter Item Description",
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
                      SizedBox(height: 20,),
                      Material(
                        color: Colors.black38,
                        borderRadius: BorderRadius.circular(30),
                        child: InkWell(
                          onTap: (){
                            updateRecord();
                          },
                          borderRadius: BorderRadius.circular(30),
                          child: const Padding(
                            padding: EdgeInsets.symmetric(horizontal: 20,vertical: 10),
                            child: Text("Update",style: TextStyle(fontSize: 16,color: Colors.white),textAlign: TextAlign.center,),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ]),
      ),
    );
  }
}
