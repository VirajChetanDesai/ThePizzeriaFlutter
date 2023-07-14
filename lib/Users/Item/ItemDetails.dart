import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:pizzeria/Users/Cart/cart_screen.dart';
import 'package:pizzeria/Users/Controllers/Item_details_controller.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:pizzeria/api_connection/api_connection.dart';
import 'package:pizzeria/user_preferences/current_user.dart';
class ItemDetailsScreen extends StatefulWidget {
  late var itemDetail;
  ItemDetailsScreen(this.itemDetail);
  @override
  State<ItemDetailsScreen> createState() => _ItemDetailsScreenState();
}

class _ItemDetailsScreenState extends State<ItemDetailsScreen> {
  final itemDetailsController = Get.put(ItemDetailsController());
  final currentOnlineUser = Get.put(currentUser());
  validateFavouriteList() async {
    try{
      var res = await http.post(
        Uri.parse(API.validateFavourite),
        body: {
          "user_id":currentOnlineUser.user.user_email.toString(),
          "item_id":widget.itemDetail!.item_id.toString(),
        },
      );
      if(res.statusCode == 200){
        var resBody = jsonDecode(res.body);
        if(resBody['success']==true){
          itemDetailsController.setFavoriteItem(true);
          Fluttertoast.showToast(msg: "In Favourites");
        }else if(resBody['success']==false){
          itemDetailsController.setFavoriteItem(false);
          Fluttertoast.showToast(msg: "Not In Favourites");
        }
      }
    }catch(e){
      print(e);
    }
  }
  addToFavouriteList() async {
    try{
      var res = await http.post(
        Uri.parse(API.addFavourite),
        body: {
          "user_id":currentOnlineUser.user.user_email.toString(),
          "item_id":widget.itemDetail!.item_id.toString(),
        },
      );
      if(res.statusCode == 200){
        var resBody = jsonDecode(res.body);
        if(resBody['success']==true){
          Fluttertoast.showToast(msg: "Item Added To Favourites");
          validateFavouriteList();
        }else if(resBody['success']==false){
          Fluttertoast.showToast(msg: "Server Error");
        }
      }
    }catch(e){
      print(e);
    }
  }
  deleteFromFavouriteList() async {
    try{
      var res = await http.post(
        Uri.parse(API.deleteFavourite),
        body: {
          "user_id":currentOnlineUser.user.user_email.toString(),
          "item_id":widget.itemDetail!.item_id.toString(),
        },
      );
      if(res.statusCode == 200){
        var resBody = jsonDecode(res.body);
        if(resBody['success']==true){
          Fluttertoast.showToast(msg: "Item Removed From Favourites");
          validateFavouriteList();
        }else if(resBody['success']==false){
          Fluttertoast.showToast(msg: "Server Error");
        }
      }
    }catch(e){
      print(e);
    }
  }
  addItemToCart()async{
    try{
      var res = await http.post(
        Uri.parse(API.addtoCart),
        body: {
          "user_id": currentOnlineUser.user.user_email.toString(),
          "item_id": widget.itemDetail!.item_id.toString(),
          "quantity": itemDetailsController.quantity.toString(),
          "style":widget.itemDetail.base_style[itemDetailsController.style].toString().replaceAll('[', '').replaceAll(']', ''),
          "size":widget.itemDetail.base_size[itemDetailsController.size].toString().replaceAll('[', '').replaceAll(']', ''),
        }
      );
      if(res.statusCode == 200){
        var resBodyLogIn = json.decode(res.body);
        if(resBodyLogIn['success'] == true){
          Fluttertoast.showToast(msg: 'Added to Cart');
        }else{
          Fluttertoast.showToast(msg: 'Invalid Email or Password');
        }
      }else{
        Fluttertoast.showToast(msg: 'Login Failed');
        }
    }catch(e){
      print("Error"+ e.toString());
    }
  }
  itemInfoWidget(){
    return Container(
      height: MediaQuery.of(context).size.height * 0.6,
      width: MediaQuery.of(context).size.width,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(10),
          topLeft: Radius.circular(10),
        ),
        boxShadow: [
          BoxShadow(
            offset: Offset(0,-3),
            blurRadius: 3,
            color:Colors.lightBlueAccent,
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 0,horizontal: 16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 18,),
              Center(
                child: Container(
                  height: 8,
                  width: 140,
                  decoration: BoxDecoration(
                    color: Colors.lightBlueAccent,
                    borderRadius: BorderRadius.circular(30),
                  ),

                ),
              ),
              const SizedBox(height: 30,),
              Text(widget.itemDetail.pizza_name,
                style: const TextStyle(color: Colors.lightBlueAccent,fontSize: 25,fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16,),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            RatingBar.builder(
                              initialRating: widget.itemDetail!.rating!,
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
                            const SizedBox(width: 8,),
                            Text(
                              "("+widget.itemDetail!.rating.toString()+")",
                              style: const TextStyle(
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16,),
                        Row(
                          children: [
                            const Text("Ingredients : " , style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold),),
                            Text(
                              widget.itemDetail!.tags!.toString().replaceAll("[","").replaceAll("]",""),
                              style: const TextStyle(
                                fontSize: 16,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 20,),
                        Text("INR "+widget.itemDetail!.price.toString(),
                          style: const TextStyle(
                            fontSize: 24,
                            color:Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                      ],
                    ),
                  ),
                  Obx(
                          ()=>Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          IconButton(onPressed: (){
                            itemDetailsController.setQuantityItem(itemDetailsController.quantity + 1);
                          }, icon: const Icon(Icons.add_circle_outline,color: Colors.lightBlueAccent,),),
                          Text(itemDetailsController.quantity.toString(),style: const TextStyle(color: Colors.black),),
                          IconButton(onPressed: (){
                            if(itemDetailsController.quantity > 1){
                              itemDetailsController.setQuantityItem(itemDetailsController.quantity - 1);
                            }
                          }, icon: const Icon(Icons.remove_circle_outline),color: Colors.lightBlueAccent,),
                        ],

                      )
                  ),
                ],
              ),

              const Text(
                "Size",
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.lightBlue,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10,),
              Wrap(
                runSpacing: 8,
                spacing: 8,
                children: List.generate(
                  widget.itemDetail!.base_size!.length,
                    (index) {
                      return Obx(() => GestureDetector(
                          onTap: (){
                            itemDetailsController.setSizeItem(index);
                          },
                          child: Container(
                            height:35,
                            width:70,
                            decoration: BoxDecoration(
                              color: index == itemDetailsController.size ? Colors.lightBlueAccent :  Colors.white,
                              border: Border.all(
                                width: 2,
                                color: itemDetailsController.size == index ? Colors.lightBlueAccent.withOpacity(0.8) : Colors.grey,
                              ),
                              borderRadius: BorderRadius.circular(30),
                            ),
                            alignment : Alignment.center,
                            child: Center(child: Text(widget.itemDetail!.base_size![index].replaceAll("[","").replaceAll("]",""),
                              style: itemDetailsController.size == index? const TextStyle(color: Colors.white):const TextStyle(color: Colors.grey),)),
                          ),
                        ),
                      );
                    },
                ),
              ),
              const SizedBox(height: 16,),
              const Text(
                "Base",
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.lightBlue,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10,),
              Wrap(
                runSpacing: 8,
                spacing: 8,
                children: List.generate(
                  widget.itemDetail!.base_style!.length,
                      (index) {
                    return Obx(() => GestureDetector(
                      onTap: (){
                        itemDetailsController.setStyleItem(index);
                      },
                      child: Container(
                        height:35,
                        width:70,
                        decoration: BoxDecoration(
                          color: index == itemDetailsController.style ? Colors.lightBlueAccent :  Colors.white,
                          border: Border.all(
                            width: 2,
                            color: itemDetailsController.style == index ? Colors.lightBlueAccent.withOpacity(0.8) : Colors.grey,
                          ),
                          borderRadius: BorderRadius.circular(30),
                        ),
                        alignment : Alignment.center,
                        child: Center(child: Text(widget.itemDetail!.base_style![index].replaceAll("[","").replaceAll("]",""),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: itemDetailsController.style == index? const TextStyle(color: Colors.white):const TextStyle(color: Colors.grey),)),
                      ),
                    ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 16,),
              const Text(
                "Description",
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.lightBlue,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10,),
              Text(
                widget.itemDetail.description,
                textAlign: TextAlign.justify,
                style: const TextStyle(
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 10,),
              Material(
                elevation: 4,
                color: Colors.lightBlueAccent,
                borderRadius: BorderRadius.circular(30),
                child: InkWell(
                  onTap: (){
                    addItemToCart();
                  },
                  borderRadius: BorderRadius.circular(30),
                  child: Container(
                    alignment: Alignment.center,
                    height: 50,
                    child: const Text("Add To Cart",style: TextStyle(color: Colors.white),),
                  ),
                ),
              ),
              const SizedBox(height: 20,),
            ],
          ),
        ),
      ),
    );
  }
  @override
  void initState() {
    super.initState();
    validateFavouriteList();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          FadeInImage(
            height: MediaQuery.of(context).size.height * 0.5,
            width: MediaQuery.of(context).size.width,
            fit: BoxFit.cover,
            placeholder: const AssetImage('images/img.png'),
            image: NetworkImage(
              widget.itemDetail!.image!,
            ),
            imageErrorBuilder: (context,error,stackTraceError){
              return const Center(
                child: Icon(
                  Icons.broken_image_outlined,
                ),
              );
            },
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: itemInfoWidget(),
          ),
          //todo: favorite add , shopping cart redirect , back
          Positioned(
            top: MediaQuery.of(context).padding.top,
            left: 0,
            right: 0,
            child: Container(
              color: Colors.transparent,
              child: Row(
                children: [
                  IconButton(onPressed: (){Get.back();}, icon: const Icon(Icons.arrow_back_ios_new,color: Colors.lightBlueAccent,)),
                  const Spacer(),
                  Obx(()=> IconButton(onPressed: (){
                      if(itemDetailsController.isFavorite){
                        // delete from db user favorites
                        deleteFromFavouriteList();
                      }else{
                        // add into db user favorites
                        addToFavouriteList();
                      }
                    }, icon: Icon(itemDetailsController.isFavorite?Icons.bookmark:Icons.bookmark_outline),),
                  ),
                  IconButton(onPressed: (){
                    Get.to(CartListScreen());
                  }, icon: const Icon(Icons.shopping_cart)),
                ],
              ),
            ),
          )
        ],
      ),
    );


  }
}
