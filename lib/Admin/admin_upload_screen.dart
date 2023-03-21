import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
class AdminUploadItemScreen extends StatefulWidget {
  const AdminUploadItemScreen({Key? key}) : super(key: key);

  @override
  State<AdminUploadItemScreen> createState() => _AdminUploadItemScreenState();
}

class _AdminUploadItemScreenState extends State<AdminUploadItemScreen> {
  final ImagePicker _picker = ImagePicker();
  XFile? pickedImage;
  phoneCam()async{
    pickedImage = await _picker.pickImage(source: ImageSource.camera);
    if(pickedImage!=null){
      Fluttertoast.showToast(msg: 'Image Picked');
      Get.back();
      setState(() {
        pickedScreen();
      });
    }else{
      Fluttertoast.showToast(msg: 'No Image picked');
    }
  }
  phoneGallery()async{
    pickedImage = await _picker.pickImage(source: ImageSource.gallery);
    if(pickedImage!=null){
      Fluttertoast.showToast(msg: 'Image Picked');
      Get.back();
      setState(() {
        pickedScreen();
      });
    }else{
      Fluttertoast.showToast(msg: 'No Image picked');
    }
  }
  imagePicker(){
    return showDialog(context: context,
        builder: (context){
          return SimpleDialog(
            title: const Text(
              'Item Image',
              style: TextStyle(
                color: Colors.purpleAccent,
                fontWeight: FontWeight.bold
              ),
            ),
            children: <Widget>[
              SimpleDialogOption(
                child: const Text(
                  'Capture with Phone Camera',
                  style: TextStyle(
                    color: Colors.grey,
                  ),
                ),
                onPressed: (){phoneCam();},
              ),
              SimpleDialogOption(
                child: const Text(
                  'Pick from gallery',
                  style: TextStyle(
                    color: Colors.grey,
                  ),
                ),
                onPressed: (){phoneGallery();},
              ),
              SimpleDialogOption(
                child: const Text(
                  'Back',
                  style: TextStyle(
                    color: Colors.red,
                  ),
                ),
                onPressed: (){
                  Get.back();
                },
              ),
            ],
          );
        });
  }
  Widget pickedScreen(){
    return Scaffold(
      backgroundColor: Colors.black87,
      body: ListView(
        children: <Widget>[
          Container(
            width: MediaQuery.of(context).size.width * 75/100,
            height: MediaQuery.of(context).size.height * 25/100,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              image: DecorationImage(
                image: FileImage(
                    File(pickedImage!.path)
                ),
                fit: BoxFit.cover,
              )
            ),
          )
        ],
      ),
    );
  }
  Widget defaultScreen(){
    return Scaffold(
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.bottomLeft,
              end: Alignment.topCenter,
              colors: [Colors.purpleAccent,Colors.deepPurple],
            ),
          ),
        ),
        automaticallyImplyLeading: false,
        title: const Center(child: Text('Admin Home')),
      ),
      body : Container(
        decoration:const BoxDecoration(
          gradient : LinearGradient(
            begin: Alignment.bottomCenter,
            end: Alignment.topCenter,
            colors: [Colors.purple,Colors.deepPurple],
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              IconButton(
                icon: Icon(Icons.add,),
                color: Colors.white,
                iconSize: 100,
                onPressed: () {
                  imagePicker();
                },
              ),
              Text('Add New Item',style: TextStyle(color: Colors.white70),),
            ],
          ),
        ),
      ),
    );
  }
  @override
  Widget build(BuildContext context) {
    return pickedImage == null? defaultScreen():pickedScreen();
  }
}
