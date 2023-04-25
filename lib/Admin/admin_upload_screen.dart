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
import 'package:pizzeria/api_connection/api_connection.dart';

Future<String> hostImage(XFile? file) async {

  String imageUrl = '';
    String uniqueName = DateTime.now().toString().trim();
    Reference referenceRoot = FirebaseStorage.instance.ref();
    Reference referenceDirImages = referenceRoot.child('images');
    Reference referenceImageToUpload = referenceDirImages.child(uniqueName);
    try{
      await referenceImageToUpload.putFile(File(file!.path));
      imageUrl = await referenceImageToUpload.getDownloadURL();
    }catch(e){
      Fluttertoast.showToast(msg: "Error Uploading Image");
    }
    return imageUrl;
}

class AdminUploadItemScreen extends StatefulWidget {
  late String adminEmail;
  AdminUploadItemScreen(this.adminEmail, {Key? key}) : super(key: key);
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
  var formKey = GlobalKey<FormState>();
  var nameController = TextEditingController();
  var ratingController = TextEditingController();
  var tagsController = TextEditingController();
  var priceController = TextEditingController();
  var sizeController = TextEditingController();
  var baseController = TextEditingController();
  var descriptionController = TextEditingController();
  var imageLink = "";
  saveToDatabase()async{
    List<String> tagsList = tagsController.text.split(',');
    List<String> sizeList = sizeController.text.split(',');
    List<String> baseList = baseController.text.split(',');
    try{
      var response = await http.post(
        Uri.parse(API.upload),
        body: {
          "name": nameController.text.trim().toString(),
          "rating": ratingController.text.trim().toString(),
          "tags": tagsList.toString(),
          "price": priceController.text.trim().toString(),
          "sizes": sizeList.toString(),
          "base": baseList.toString(),
          "description":  descriptionController.text.trim().toString(),
          "image":  imageLink,
          "admin_email" : widget.adminEmail,
        },
      );
      print(response.body);
      if (response.statusCode == 200){
        var resBody = jsonDecode(response.body);
        if(resBody['success']==true) {
          Fluttertoast.showToast(msg: "Successful Upload");
          setState(() {
            pickedImage = null;
            nameController.clear();
            ratingController.clear();
            tagsController.clear();
            priceController.clear();
            sizeController.clear();
            baseController.clear();
            descriptionController.clear();
            imageLink = "";
          });
        }else{
          Fluttertoast.showToast(msg: "Failed Upload");
        }
      }
    }catch(e){
      print('Error ${e}');
    }
  }

  Widget pickedScreen(){
    return Scaffold(
      backgroundColor: Colors.black38,
      appBar: AppBar(
        title: const Text("Upload",),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.clear),
          onPressed: () {Get.to(AdminLoginScreen());},
        ),
        actions: [
          TextButton(
              onPressed: (){},
              child: const Text("Publish",style: TextStyle(color: Colors.deepPurple),),),
        ],
        automaticallyImplyLeading: false,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(colors: [Colors.deepPurple,Colors.purpleAccent])
          ),
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
              begin : Alignment.topCenter,
              end :Alignment.bottomCenter,
              colors: [Colors.deepPurple,Colors.purpleAccent]
          ),
        ),
        child: ListView(
          children: <Widget>[
            Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height * 25/100,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                image: DecorationImage(
                  image: FileImage(
                      File(pickedImage!.path)
                  ),
                  fit: BoxFit.cover,
                )
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
                            //name
                            TextFormField(
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                color: Colors.black,
                              ),
                              controller: nameController,
                              obscureText: false,
                              validator: (val){
                                val == ""?"Enter Item Name":null;
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
                                filled:true,
                              ),
                            ),
                            const SizedBox(height: 20.0,),
                            //rating
                            TextFormField(
                              textAlign: TextAlign.left,
                              style: const TextStyle(
                                color: Colors.black,
                              ),
                              controller: ratingController,
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
                              controller: tagsController,
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
                              controller: priceController,
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
                              controller: sizeController,
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
                              controller: baseController,
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
                              controller: descriptionController,
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
                            const SizedBox(height: 20.0,),
                            Material(
                              color:Colors.black38,
                              borderRadius: BorderRadius.circular(30),
                              child: InkWell(
                                onTap: ()async{
                                  if(pickedImage!=null && nameController.text != "" && ratingController.text != "" && tagsController.text != "" && priceController.text!= "" && sizeController.text!= "" && baseController.text!=""){
                                    imageLink =  await hostImage(pickedImage);
                                    await saveToDatabase();
                                  }else{
                                    Fluttertoast.showToast(msg: "Please enter all fields");
                                  }
                                },
                                borderRadius: BorderRadius.circular(30),
                                child: const Padding(
                                  padding: EdgeInsets.symmetric(vertical: 10,horizontal: 20),
                                  child: Text(
                                    "Upload Now",
                                    style: TextStyle(
                                      color:Colors.white,
                                      fontSize: 16,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 10.0,),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
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
        actions: [
          IconButton(onPressed: (){Get.to(ItemEditScreen());}, icon: const Icon(Icons.edit, color: Colors.white,))
        ],
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
                onPressed: () async {
                  await imagePicker();
                },
              ),
              const Text('Add New Item',style: TextStyle(color: Colors.white70),),
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
