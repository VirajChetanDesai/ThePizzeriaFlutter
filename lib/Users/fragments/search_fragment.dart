import 'dart:convert';

import 'package:flutter/material.dart';
import 'home_fragment_screen.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:pizzeria/Users/Cart/cart_screen.dart';
import 'package:pizzeria/Users/Item/ItemDetails.dart';
import 'package:pizzeria/Users/fragments/search_fragment.dart';
import 'package:pizzeria/Users/model/item.dart';
import 'package:http/http.dart' as http;
import 'package:pizzeria/api_connection/api_connection.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';
class SearchScreen extends StatefulWidget {
  TextEditingController? searchController;
  SearchScreen(this.searchController, {super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  Future<List<Item>> searchresults() async {
    List<Item> result = [];
    try{
      var res = await http.post(
        Uri.parse(API.getSearchResults),
        body: {
          'search' : widget.searchController?.text,
        },
      );
      if(res.statusCode == 200){
        var resBody = jsonDecode(res.body);
        if(resBody["success"] == true){
          if((resBody["itemsData"] as List).isEmpty) return result;
          (resBody["itemsData"] as List).forEach((element) {
            result.add(Item.fromJson(element));
          });
        }else{
          Fluttertoast.showToast(msg: "Search Error");
        }
      }else{
        Fluttertoast.showToast(msg: "Server Error");
      }
    }catch(e){
      print(e);
    }
    return result;
  }
  Widget showSearchBarWidget() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: TextField(
        style: const TextStyle(color: Colors.black),
        decoration: InputDecoration(
          prefixIcon: IconButton(
            onPressed: (){
              //todo: reload screen using search functionality
              setState(() {
                searchresults();
              });
            },
            icon: const Icon(Icons.search,color: Colors.purple,),
          ),
          hintText: "Search",
          hintStyle: const TextStyle(color: Colors.grey),
          border: const OutlineInputBorder(
            borderSide: BorderSide(
              width: 1,
              color: Colors.black,
            ),
            borderRadius: BorderRadius.all(Radius.circular(15)),
          ),
          enabledBorder: const OutlineInputBorder(
            borderSide: BorderSide(
              width: 1,
              color: Colors.black,
            ),
            borderRadius: BorderRadius.all(Radius.circular(15)),
          ),
          focusedBorder: const OutlineInputBorder(
            borderSide: BorderSide(
              width: 1,
              color: Colors.black,
            ),
            borderRadius: BorderRadius.all(Radius.circular(15)),
          ),
        ),
        controller: widget.searchController,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Center(child: Text("Home",style: TextStyle(color: Colors.white),)),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: 10,),
          showSearchBarWidget(),
          SingleChildScrollView(
            child: allItemWidget(context),
          ),
        ],
      ),
    );
  }
  Widget allItemWidget(context){
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    return FutureBuilder(
        future: searchresults(),
        builder: (context, AsyncSnapshot<List> dataSnapshot){
          if(dataSnapshot.connectionState == ConnectionState.waiting){
            return const Center(child: CircularProgressIndicator());
          }
          if(dataSnapshot.data == null){
            return const Text("No Items");
          }
          if(dataSnapshot.data!.length > 0){
            return ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: dataSnapshot.data!.length,
                scrollDirection: Axis.vertical,
                itemBuilder: (BuildContext context, int index){
                  var eachItem = dataSnapshot.data![index];
                  return GestureDetector(
                      onTap: (){
                        Get.to(ItemDetailsScreen(eachItem));
                      },
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
                              height: height/4.4,
                              decoration: const BoxDecoration(
                                borderRadius: BorderRadius.all(Radius.circular(25)),
                                color: Color(0xFFC4C4C4),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  children: <Widget>[
                                    Container(
                                      width: width/4,
                                      height: height/6,
                                      decoration: const BoxDecoration(
                                        boxShadow: [BoxShadow(
                                          blurRadius: 0,
                                          color: Colors.black26,
                                          offset: Offset(0,2),
                                        )],
                                        borderRadius: const BorderRadius.all(Radius.circular(20.0)),
                                        shape: BoxShape.rectangle,
                                      ),
                                      child: ClipRRect(
                                        borderRadius: const BorderRadius.all(Radius.circular(20.0)),
                                        child: FadeInImage(
                                          height: 150,
                                          fit: BoxFit.cover,
                                          width: 200,
                                          placeholder: const AssetImage('images/img.png'),
                                          image: NetworkImage(
                                            eachItem.image!,
                                          ),
                                          imageErrorBuilder: (context,error,stackTraceError){
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
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: <Widget>[
                                        Row(
                                          children: [
                                            const SizedBox(width: 10,),
                                            Container(
                                              width: width/4,
                                              height:width/12,
                                              padding: EdgeInsets.all(height * 0.01),
                                              decoration: BoxDecoration(
                                                  borderRadius: BorderRadius.circular(10),
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
                                                  mainAxisAlignment: MainAxisAlignment.center,
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
                                            const SizedBox(width: 5,),
                                            Container(
                                              width: width/4,
                                              height: width/12,
                                              padding: EdgeInsets.all(height * 0.01),
                                              decoration: BoxDecoration(
                                                borderRadius: BorderRadius.circular(10),
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
                                                children: [
                                                  dropDown("Size",eachItem.base_size),
                                                ],
                                              ),
                                            )
                                          ],
                                        ),
                                        const SizedBox(height: 10,),
                                        Row(
                                          children: [
                                            const SizedBox(width: 10,),
                                            Container(
                                              width: width/4,
                                              height: width/12,
                                              decoration: BoxDecoration(
                                                  borderRadius: BorderRadius.circular(10),
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
                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                  crossAxisAlignment: CrossAxisAlignment.center,
                                                  mainAxisSize: MainAxisSize.min,
                                                  children: [
                                                    RatingBar.builder(
                                                      initialRating: eachItem.rating!,
                                                      direction: Axis.horizontal,
                                                      allowHalfRating: true,
                                                      minRating: 1,
                                                      maxRating: 5,
                                                      itemCount: 5,
                                                      itemBuilder: (context,c){
                                                        return const Icon(
                                                          Icons.star,
                                                          color: Colors.amber,
                                                        );
                                                      },
                                                      itemSize: 10,
                                                      onRatingUpdate: (c){},
                                                      ignoreGestures: true,
                                                      unratedColor: Colors.grey,
                                                    ),
                                                    SizedBox(width: 3,),
                                                    Text("${eachItem.rating!}",style: TextStyle(color: Colors.grey,fontSize: 8,fontWeight: FontWeight.w200),),
                                                  ],
                                                ),
                                              ),
                                            ),
                                            const SizedBox(width: 5,),
                                            Container(
                                              width: width/4,
                                              height: width/12,
                                              padding: EdgeInsets.all(height * 0.01),
                                              decoration: BoxDecoration(
                                                borderRadius: BorderRadius.circular(10),
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
                                                children: [
                                                  dropDown("Style",eachItem.base_style),
                                                ],
                                              ),
                                            )
                                          ],
                                        ),
                                        const SizedBox(height: 10,),

                                        Row(
                                          children: [
                                            const SizedBox(width: 10,),
                                            Container(
                                              width: width/2,
                                              height: width/12,
                                              padding: EdgeInsets.all(height * 0.01),
                                              decoration: BoxDecoration(
                                                borderRadius: BorderRadius.circular(10),
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
                                                    child: Center(child: Text("INR ${eachItem.price}",style: const TextStyle(color: Colors.white),)),
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
                      )
                  );
                }
            );
          }
          else{return const Center();}
        }
    );
  }
}
