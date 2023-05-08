import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:pizzeria/Admin/admin_upload_screen.dart';
import 'package:pizzeria/Admin/item_edit_form.dart';
import 'package:pizzeria/Admin/item_restore_screen.dart';
import 'package:pizzeria/Users/Authentication/login_screen.dart';
import 'package:pizzeria/Users/fragments/home_fragment_screen.dart';
import 'package:pizzeria/Users/model/item.dart';
import 'package:pizzeria/api_connection/api_connection.dart';
import 'package:get/get.dart';

class ItemEditScreen extends StatefulWidget {
  String? adminEmail;
  ItemEditScreen(this.adminEmail, {super.key});
  @override
  State<ItemEditScreen> createState() => _ItemEditScreenState();
}

class _ItemEditScreenState extends State<ItemEditScreen> {
  itemDeletion(int? item_id) async {
    try {
      var res = await http.post(
        Uri.parse(API.deleteItemFromDB),
        body: {
          "ItemID": item_id.toString(),
        },
      );
      print(res.body);
      if (res.statusCode == 200) {
        var deletionBody = jsonDecode(res.body);
        if (deletionBody['success'] == true) {
          Fluttertoast.showToast(msg: "Item Deleted Successfully");
        } else {
          Fluttertoast.showToast(msg: "Item could not be deleted");
        }
      } else {
        Fluttertoast.showToast(msg: "Database Currently Inactive");
      }
    } catch (e) {
      print(e);
    }
  }

  Future deleteFromItemList(int? item_id) {
    return showDialog(
      context: context,
      builder: (context) {
        return SimpleDialog(
            title: const Text(
              'Delete from Items?',
              style:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
            children: <Widget>[
              SimpleDialogOption(
                child: const Text(
                  'Delete',
                  style: TextStyle(
                    color: Colors.red,
                  ),
                ),
                onPressed: () {
                  setState(() {
                    itemDeletion(item_id);
                    Get.back();
                  });
                },
              ),
              SimpleDialogOption(
                child: const Text(
                  'Back',
                  style: TextStyle(
                    color: Colors.grey,
                  ),
                ),
                onPressed: () {
                  Get.back();
                },
              ),
            ]);
      },
    );
  }

  Widget EditWidget(context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    return FutureBuilder(
        future: getAllItems(),
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
                                          placeholder: const AssetImage(
                                              'images/img.png'),
                                          image: NetworkImage(
                                            eachItem.image!,
                                          ),
                                          imageErrorBuilder: (context, error,
                                              stackTraceError) {
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
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
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
                                                        deleteFromItemList(eachItem.item_id);
                                                      },
                                                      icon: const Icon(
                                                        Icons
                                                            .delete_forever_outlined,
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
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  children: [
                                                    RatingBar.builder(
                                                      initialRating:
                                                          eachItem.rating!,
                                                      direction:
                                                          Axis.horizontal,
                                                      allowHalfRating: true,
                                                      minRating: 1,
                                                      maxRating: 5,
                                                      itemCount: 5,
                                                      itemBuilder:
                                                          (context, c) {
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
                                                          Get.to(ItemEditForm(eachItem,widget.adminEmail));
                                                        });
                                                      },
                                                      icon: const Icon(
                                                        Icons.edit,
                                                        color: Colors.grey,
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
                                                  Center(
                                                      child: Text(
                                                    "INR ${eachItem.price}",
                                                    style: const TextStyle(
                                                        color: Colors.white),
                                                  )),
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
        title: const Center(child: Text("Item Edit Screen")),
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
              onPressed: () {
                setState(() {
                  Get.to(ItemRestoreScreen(widget.adminEmail));
                });
              },
              icon: Icon(Icons.undo))
        ],
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
