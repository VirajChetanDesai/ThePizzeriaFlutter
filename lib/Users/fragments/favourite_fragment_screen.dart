import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:pizzeria/api_connection/api_connection.dart';
import 'package:get/get.dart';
import 'package:pizzeria/user_preferences/current_user.dart';
import 'package:pizzeria/Users/model/favourite.dart';
import 'package:pizzeria/Users/Item/ItemDetails.dart';
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


class FavouriteFragmentScreen extends StatelessWidget {
  final currentOnlineUser = Get.put(currentUser());
  Future<List<Favourite>> readFavourites()async{
    List<Favourite> favouriteListCurrentUser = [];
    try{
      var res = await http.post(
        Uri.parse(API.readFavourite),
        body: {
          'user_id' : currentOnlineUser.user.user_email,
        }
      );
      if(res.statusCode == 200){
        var resBody = jsonDecode(res.body);
        if(resBody['success'] == true){
          if((resBody['currentUserFavouriteData'] as List).isNotEmpty){
            (resBody['currentUserFavouriteData'] as List).forEach((element) {
              favouriteListCurrentUser.add(Favourite.fromJson(element));
            });
          }
        }else if(resBody['success'] == false){;
        }
      }
    }catch(e){
      print(e);
    }
    return favouriteListCurrentUser;
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Center(child: Text('Favourites',
        style: TextStyle(
          fontWeight: FontWeight.bold,
        ),),),
        automaticallyImplyLeading: false,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: const EdgeInsets.fromLTRB(16,16,0,0),
              child: Text(
                "Following Items are bookmarked by user",
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
            const SizedBox(height:24),
            //todo: display favourite list
            favouriteListItemWidget(context),
          ],
        ),
      ),
    );
  }

  Widget favouriteListItemWidget(context){
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    return FutureBuilder(
        future: readFavourites(),
        builder: (context, AsyncSnapshot<List> dataSnapshot){
          if(dataSnapshot.connectionState == ConnectionState.waiting){
            return const Center(child: CircularProgressIndicator());
          }
          if(dataSnapshot.data!.isEmpty){
            return Padding(
              padding: EdgeInsets.symmetric(vertical: MediaQuery.sizeOf(context).height/3,horizontal: 0),
              child: const Center(child: Text("No Favourite Items",style: TextStyle(color: Colors.grey),)),
            );
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
                        //todo: fix the updation of favourites post update
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
