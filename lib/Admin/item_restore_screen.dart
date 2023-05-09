import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:pizzeria/Admin/admin_upload_screen.dart';
import 'package:pizzeria/Admin/item_edit_screen.dart';
import 'package:pizzeria/Users/Authentication/login_screen.dart';
import 'package:pizzeria/Users/fragments/home_fragment_screen.dart';
import 'package:pizzeria/Users/model/item.dart';
import 'package:pizzeria/api_connection/api_connection.dart';
import 'package:get/get.dart';

class ItemRestoreScreen extends StatefulWidget {
  String? adminEmail;
  ItemRestoreScreen(this.adminEmail, {super.key});
  @override
  State<ItemRestoreScreen> createState() => _ItemRestoreScreenState();
}

class _ItemRestoreScreenState extends State<ItemRestoreScreen> {
  Future<List> getDeletedItems()async{
    List<Item> fullList = [];
    try{
      var res = await http.post(
        Uri.parse(API.retrieveAllDeletedItems),
      );
      if(res.statusCode == 200){
        var restoreBody = jsonDecode(res.body);
        if(restoreBody["success"] == true){
          (restoreBody["itemsData"] as List).forEach((element) {
            fullList.add(Item.fromJson2(element));
          });
        }
      }
      else{
        Fluttertoast.showToast(msg: "Error: getDeletedItems");
      }
    }
    catch(e){
      print("Error + ${e} ");
    }
    return fullList;
  }
  deleteFromBackup(int itemId)async{
    try{
      var res = await http.post(
        Uri.parse(API.deleteBackupDeletedItems),
        body: {
          "backup_id":itemId.toString(),
        }
      );
      print(res.body);
      if(res.statusCode == 200){
        Fluttertoast.showToast(msg: "Successfully Deleted");
      }
    }catch(e){
      print(e);
    }
  }
  itemAdder(Item? item)async{
    try{
      var response = await http.post(
        Uri.parse(API.upload),
        body: {
          "name": item?.pizza_name,
          "rating": item?.rating.toString(),
          "tags": item?.tags.toString().replaceFirst('[', '').replaceFirst(']', ''),
          "price": item?.price.toString(),
          "sizes": item?.base_size.toString().replaceFirst('[', '').replaceFirst(']', ''),
          "base": item?.base_style.toString().replaceFirst('[', '').replaceFirst(']', ''),
          "description":  item?.description,
          "image":  item?.image,
          "admin_email" : widget.adminEmail,
        },
      );
      print(response.body);
      if (response.statusCode == 200){
        var resBody = jsonDecode(response.body);
        if(resBody['success']==true) {
          Fluttertoast.showToast(msg: "Successful Upload");
        }else{
          Fluttertoast.showToast(msg: "Failed Upload");
        }
      }
    }catch(e){
      print('Error ${e}');
    }
  }

  itemRestore(int? item_id)async{
    Item? item;
    try{
      var res = await http.post(
        Uri.parse(API.retrieveDeletedItems),
        body: {
          "ItemID" : item_id.toString(),
          "AdminEmail" : widget.adminEmail,
        },
      );
      print(res.body);
      if(res.statusCode == 200){
        var restoreBody = jsonDecode(res.body);
        if(restoreBody['success'] == true){
          (restoreBody["itemsData"] as List).forEach((element) {
            itemAdder(Item.fromJson2(element));
          });
          Fluttertoast.showToast(msg: "Item Restored Successfully");
        }else{
          Fluttertoast.showToast(msg: "Item could not be restored");
        }
      }else{
        Fluttertoast.showToast(msg: "Database Currently Inactive");
      }
    }catch(e){
      print(e);
    }
  }

  Widget EditWidget(context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    return FutureBuilder(
        future: getDeletedItems(),
        builder: (context, AsyncSnapshot<List> dataSnapshot) {
          if (dataSnapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (dataSnapshot.data == null) {
            return const Text("No Items");
          }
          if (dataSnapshot.data!.length > 0) {
            return ListView.builder(
                itemCount: dataSnapshot.data!.length,
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                scrollDirection: Axis.vertical,
                itemBuilder: (BuildContext context, int index) {
                  var eachItem = dataSnapshot.data![index];
                  return GestureDetector(
                      onTap: () {},
                      child: Padding(
                        padding: const EdgeInsets.all(14.0),
                        child: Column(
                          children: [
                            const SizedBox(
                              height: 5,
                            ),
                            Container(
                              padding: const EdgeInsets.all(13.0),
                              width: width,
                              height: height / 4.4,
                              decoration: const BoxDecoration(
                                borderRadius:
                                BorderRadius.all(Radius.circular(25)),
                                color: Color(0xFFC4C4C4),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  children: <Widget>[
                                    Container(
                                      width: width / 4,
                                      height: height / 6,
                                      decoration: const BoxDecoration(
                                        boxShadow: [
                                          BoxShadow(
                                            blurRadius: 0,
                                            color: Colors.black26,
                                            offset: Offset(0, 2),
                                          )
                                        ],
                                        borderRadius: const BorderRadius.all(
                                            Radius.circular(20.0)),
                                        shape: BoxShape.rectangle,
                                      ),
                                      child: ClipRRect(
                                        borderRadius: const BorderRadius.all(
                                            Radius.circular(20.0)),
                                        child: FadeInImage(
                                          height: 150,
                                          fit: BoxFit.cover,
                                          width: 200,
                                          placeholder:
                                          const AssetImage('images/img.png'),
                                          image: NetworkImage(
                                            eachItem.image!,
                                          ),
                                          imageErrorBuilder:
                                              (context, error, stackTraceError) {
                                            return const Center(
                                              child: Icon(
                                                Icons.broken_image_outlined,
                                              ),
                                            );
                                          },
                                        ),
                                      ),
                                    ),
                                    Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      crossAxisAlignment:
                                      CrossAxisAlignment.center,
                                      children: <Widget>[
                                        Row(
                                          children: [
                                            const SizedBox(
                                              width: 10,
                                            ),
                                            Container(
                                              width: width / 4,
                                              height: width / 12,
                                              padding:
                                              EdgeInsets.all(height * 0.01),
                                              decoration: BoxDecoration(
                                                  borderRadius:
                                                  BorderRadius.circular(10),
                                                  color: Colors.white,
                                                  boxShadow: const [
                                                    BoxShadow(
                                                      blurRadius: 0,
                                                      color: Colors.black26,
                                                      offset: Offset(0, 2),
                                                    )
                                                  ]),
                                              child: Center(
                                                child: Row(
                                                  mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                                  children: [
                                                    Text(
                                                      "${eachItem.pizza_name}",
                                                      style: const TextStyle(
                                                        color: Colors.black,
                                                        fontSize: 10,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                            const SizedBox(
                                              width: 5,
                                            ),
                                            Container(
                                              width: width / 4,
                                              height: width / 12,
                                              padding:
                                              EdgeInsets.all(height * 0),
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                BorderRadius.circular(10),
                                                color: Colors.white,
                                                boxShadow: const [
                                                  BoxShadow(
                                                    blurRadius: 0,
                                                    color: Colors.black26,
                                                    offset: Offset(0, 2),
                                                  )
                                                ],
                                              ),
                                              child: Row(
                                                mainAxisAlignment:
                                                MainAxisAlignment.center,
                                                crossAxisAlignment:
                                                CrossAxisAlignment.baseline,
                                                textBaseline:
                                                TextBaseline.alphabetic,
                                                children: [
                                                  IconButton(
                                                      onPressed: () {
                                                        itemRestore(eachItem.item_id);
                                                      },
                                                      icon: const Icon(
                                                        Icons.add,
                                                        color: Colors.blue,
                                                        size: 17,
                                                      )),
                                                ],
                                              ),
                                            )
                                          ],
                                        ),
                                        const SizedBox(
                                          height: 10,
                                        ),
                                        Row(
                                          children: [
                                            const SizedBox(
                                              width: 10,
                                            ),
                                            Container(
                                              width: width / 4,
                                              height: width / 12,
                                              decoration: BoxDecoration(
                                                  borderRadius:
                                                  BorderRadius.circular(10),
                                                  color: Colors.white,
                                                  boxShadow: const [
                                                    BoxShadow(
                                                      blurRadius: 0,
                                                      color: Colors.black26,
                                                      offset: Offset(0, 2),
                                                    ),
                                                  ]),
                                              child: Center(
                                                child: Row(
                                                  mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                                  crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                                  mainAxisSize: MainAxisSize.min,
                                                  children: [
                                                    RatingBar.builder(
                                                      initialRating:
                                                      eachItem.rating!,
                                                      direction: Axis.horizontal,
                                                      allowHalfRating: true,
                                                      minRating: 1,
                                                      maxRating: 5,
                                                      itemCount: 5,
                                                      itemBuilder: (context, c) {
                                                        return const Icon(
                                                          Icons.star,
                                                          color: Colors.amber,
                                                        );
                                                      },
                                                      itemSize: 10,
                                                      onRatingUpdate: (c) {},
                                                      ignoreGestures: true,
                                                      unratedColor: Colors.grey,
                                                    ),
                                                    SizedBox(
                                                      width: 3,
                                                    ),
                                                    Text(
                                                      "${eachItem.rating!}",
                                                      style: TextStyle(
                                                          color: Colors.grey,
                                                          fontSize: 8,
                                                          fontWeight:
                                                          FontWeight.w200),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                            const SizedBox(
                                              width: 5,
                                            ),
                                            Container(
                                              width: width / 4,
                                              height: width / 12,
                                              padding:
                                              EdgeInsets.all(height * 0),
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                BorderRadius.circular(10),
                                                color: Colors.white,
                                                boxShadow: const [
                                                  BoxShadow(
                                                    blurRadius: 0,
                                                    color: Colors.black26,
                                                    offset: Offset(0, 2),
                                                  )
                                                ],
                                              ),
                                              child: Row(
                                                mainAxisAlignment:
                                                MainAxisAlignment.center,
                                                crossAxisAlignment:
                                                CrossAxisAlignment.baseline,
                                                textBaseline:
                                                TextBaseline.alphabetic,
                                                children: [
                                                  IconButton(
                                                      onPressed: () {
                                                        setState(() {
                                                          deleteFromBackup(eachItem.item_id);
                                                        });
                                                      },
                                                      icon: const Icon(
                                                        Icons.delete,
                                                        color: Colors.red,
                                                        size: 17,
                                                      )),
                                                ],
                                              ),
                                            )
                                          ],
                                        ),
                                        const SizedBox(
                                          height: 10,
                                        ),
                                        Row(
                                          children: [
                                            const SizedBox(
                                              width: 10,
                                            ),
                                            Container(
                                              width: width / 2,
                                              height: width / 12,
                                              padding:
                                              EdgeInsets.all(height * 0.01),
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                BorderRadius.circular(10),
                                                color: Colors.black,
                                                boxShadow: const [
                                                  BoxShadow(
                                                    blurRadius: 0,
                                                    color: Colors.black26,
                                                    offset: Offset(0, 2),
                                                  )
                                                ],
                                              ),
                                              child: Row(
                                                children: [
                                                  Expanded(
                                                    child: Center(
                                                        child: Text(
                                                          "INR ${eachItem.price}",
                                                          style: const TextStyle(
                                                              color: Colors.white),
                                                        )),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        )
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ));
                });
          } else {
            return const Center();
          }
        });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Center(child: Text("Item Restore Screen")),
        automaticallyImplyLeading: false,
        leading: IconButton(icon: Icon(Icons.arrow_back_ios_new), onPressed: () {
          setState(() {
            Get.back();
          });

          },),
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
        height: MediaQuery.sizeOf(context).height,
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              EditWidget(context),
            ],
          ),
        ),
      ),
    );
  }
}
