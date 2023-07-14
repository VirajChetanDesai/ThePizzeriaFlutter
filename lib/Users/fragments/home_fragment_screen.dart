import 'dart:convert';

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
/* Counter code
void _increment() {
    setState(() {
      if(widget.count<9) {
        widget.count++;
      }
    });
  }
  void _decrement() {
    setState(() {
      if(widget.count>1) {
        widget.count--;
      }
    });
  }
child: Center(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Padding(
                                    padding: EdgeInsets.zero,
                                    child: IconButton(
                                      icon: const Icon(Icons.remove,color: Colors.black,),
                                      iconSize: 10,
                                      padding: EdgeInsets.zero,
                                      onPressed: _decrement,
                                    ),
                                  ),
                                  Text('${widget.count}',style: const TextStyle(color: Colors.black,fontSize: 12),),
                                  Padding(
                                    padding: EdgeInsets.zero,
                                    child: IconButton(
                                      icon: const Icon(Icons.add,color: Colors.black),
                                      iconSize: 10,
                                      padding: EdgeInsets.zero,
                                      onPressed: _increment,
                                    ),
                                  ),
                                ],
                              ),
                            ),
 */

Future<List> getTrendingItems()async{
  List<Item>? trendingList =[];
  try{
    var res = await http.post(
      Uri.parse(API.trending),
    );
    if(res.statusCode == 200){
      var responseBodyTrending = jsonDecode(res.body);
      if(responseBodyTrending["success"] == true){
        for (var element in (responseBodyTrending["itemsData"] as List)) {
          trendingList.add(Item.fromJson(element));
        }
      }
    }
    else{
      Fluttertoast.showToast(msg: "Error: trending");
    }
  }
  catch(e){
    print("Error + ${e}");
  }
  return trendingList;
}
Future<List> getAllItems()async{
  List<Item> fullList = [];
  try{
    var res = await http.post(
      Uri.parse(API.retrieve),
    );
    if(res.statusCode == 200){
      var responseBodyTrending = jsonDecode(res.body);
      if(responseBodyTrending["success"] == true){
        (responseBodyTrending["itemsData"] as List).forEach((element) {
          fullList.add(Item.fromJson(element));
        });
      }
    }
    else{
      Fluttertoast.showToast(msg: "Error: trending");
    }
  }
  catch(e){
    print("Error + ${e}");
  }
  return fullList;
}

class dropDown extends StatefulWidget {
  List<String> _dropdownItems;
  String selected;
  dropDown(this.selected,this._dropdownItems);
  @override
  State<dropDown> createState() => _dropDown();
}
class _dropDown extends State<dropDown> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: ButtonTheme(
        padding: EdgeInsets.zero,
        alignedDropdown: true,
        child: DropdownButton<String>(
          padding: EdgeInsets.zero,
          hint: Text(widget.selected,style: const TextStyle(color: Colors.black),),
          icon: const Icon(Icons.arrow_drop_down,color: Colors.black,),
          iconSize: 16,
          isDense: true,
          borderRadius: BorderRadius.circular(10),
          style: const TextStyle(
            color: Colors.black,
            fontSize: 10.0,
          ),
          underline: Container(
            height: 0,
            color: Colors.black12,
          ),
          items: widget._dropdownItems.map((String item) {
            return DropdownMenuItem<String>(
              value: item,
              child: Text(item),
            );
          }).toList(),
          onChanged: (String? selectedItem) {
            setState(() {
              widget.selected = selectedItem!;
            });
          },
        ),
      ),
    );
  }
}

class HomeFragmentScreen extends StatelessWidget {

  TextEditingController searchController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Center(child: Text('Home'),),
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            onPressed: (){
              Get.to(CartListScreen());
            },
            icon: const Icon( Icons.shopping_cart, color: Colors.white,),
          ),
        ],
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 5,),
            showSearchBarWidget(),
            SizedBox(height: 10,),
            Text("Most Popular",style: TextStyle(color: Colors.black,fontSize: 25,fontWeight: FontWeight.bold),textAlign: TextAlign.left,),
            trendingWidget(context),
            SizedBox(height: 10,),
            Text("All Items",style: TextStyle(color: Colors.black,fontSize: 25,fontWeight: FontWeight.bold),textAlign: TextAlign.left,),
            allItemWidget(context),
            SizedBox(height: 5,),
          ],
        ),
      ),
    );
  }

  Widget showSearchBarWidget() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: TextField(
        style: const TextStyle(color: Colors.black),
        decoration: InputDecoration(
          prefixIcon: IconButton(
            onPressed: (){
              Get.to(SearchScreen(searchController));
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
        controller: searchController,
      ),
    );
  }
  Widget trendingWidget(context){
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    return FutureBuilder(
      future: getTrendingItems(),
      builder: (context, AsyncSnapshot<List> dataSnapshot){
        if(dataSnapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        if(dataSnapshot.data == null){
          return const Center(
            child: Text("No trending Items"),
          );
        }
        if(dataSnapshot.data!.length > 0){
          return Container(
            height: 262,
            child: ListView.builder(
                itemCount: dataSnapshot.data!.length,
                scrollDirection: Axis.horizontal,
                itemBuilder: (BuildContext context, int index) {
                  Item eachItem = dataSnapshot.data![index];
                  return GestureDetector(
                    onTap: (){
                      Get.to(ItemDetailsScreen(eachItem));
                    },
                    child: Container(
                      width: 200,
                      margin: EdgeInsets.fromLTRB(
                        index == 0? 16:8,
                        10,
                        index == 3? 16:8,
                        10,
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: const [BoxShadow(
                          offset: Offset(0,5),
                          blurRadius: 0,
                          color: Color(0xFFC4C4C4),
                        ),]
                      ),
                      child: Column(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(20),
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
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Expanded(
                                      child: Container(
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
                                      child: Text(eachItem.pizza_name!,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(color: Colors.black,fontSize: 13),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                    ),
                                    const SizedBox(width: 10,),

                                    Expanded(
                                      child: Container(
                                        width: width/4,
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
                                        child: Center(
                                          child: Text("INR "+eachItem.price!.toString(),
                                            style: const TextStyle(color: Colors.white,fontSize: 13
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 10,),
                                Container(
                                  width: width/2,
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
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      RatingBar.builder(
                                        initialRating: eachItem.rating!,
                                        minRating: 1,
                                        maxRating: 5,
                                        direction: Axis.horizontal,
                                        allowHalfRating: true,
                                        itemCount: 5,
                                        itemBuilder: (context,c)=>const Icon(
                                          Icons.star,
                                          color: Colors.amber,
                                        ),
                                        onRatingUpdate: (updateRating){

                                        },
                                        itemSize: 16,
                                        ignoreGestures: true,
                                        unratedColor: Colors.grey,
                                      ),
                                      const SizedBox(width: 10,),
                                      Text("${eachItem!.rating}",style: const TextStyle(fontSize: 11,color: Colors.grey,fontWeight: FontWeight.w200),),
                                    ],
                                  )
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),

                  );
                },
            ),
          );
        }
        else{return const Center();}
      },
    );
  }
  Widget allItemWidget(context){
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    return FutureBuilder(
        future: getAllItems(),
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
