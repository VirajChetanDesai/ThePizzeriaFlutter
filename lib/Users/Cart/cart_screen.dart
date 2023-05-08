import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:pizzeria/Users/model/cart.dart';
import 'package:pizzeria/Users/model/item.dart';
import 'package:pizzeria/api_connection/api_connection.dart';
import 'package:pizzeria/user_preferences/current_user.dart';
import 'package:pizzeria/Users/Controllers/cart_list_controller.dart';
import 'package:http/http.dart' as http;

class CartListScreen extends StatefulWidget {
  const CartListScreen({Key? key}) : super(key: key);

  @override
  State<CartListScreen> createState() => _CartListScreenState();
}

class _CartListScreenState extends State<CartListScreen> {
  final currentOnlineUser = Get.put(currentUser());
  final cartListController = Get.put(CartListController());
  orderNow(var cartList){

  }
  cartItemDeletion(int? cart_id)async{
    try{
      var res = await http.post(
        Uri.parse(API.deleteCartItem),
        body: {
          "cart_id" : cart_id.toString(),
        },
      );
      if(res.statusCode == 200){
        var deletionBody = jsonDecode(res.body);
        if(deletionBody['success'] == true){
          Fluttertoast.showToast(msg: "Item Deleted Successfully");
          getCurrentUserCartList();
        }else{
          Fluttertoast.showToast(msg: "Item could not be deleted");
        }
      }else{
        Fluttertoast.showToast(msg: "Database Currently Inactive");
      }
    }catch(e){
      print(e);
    }
  }

  Future deleteFromCart(int? cart_id) {
    return showDialog(context: context,
        builder: (context) {
          return SimpleDialog(
              title: const Text(
                'Delete from Cart?',
                style: TextStyle(
                    color: Colors.white, fontWeight: FontWeight.bold),
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
                      cartItemDeletion(cart_id);
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
                    setState(() {
                      Get.back();
                    });
                  },
                ),
              ]);
        },
    );
  }

  getCurrentUserCartList() async {
    List<Cart> cartListCurrentUser = [];
    try {
      var res = await http.post(Uri.parse(API.getCartList), body: {
        "currentOnlineUserID": currentOnlineUser.user.user_email.toString(),
      });
      print(res.body);
      if (res.statusCode == 200) {
        var responseBodyOfGetCurrentUserCartList = jsonDecode(res.body);
        if (responseBodyOfGetCurrentUserCartList['success'] == true) {
          (responseBodyOfGetCurrentUserCartList['cartData'] as List)
              .forEach((element) {
            cartListCurrentUser.add(Cart.fromJson(element));
          });
        } else {
          Fluttertoast.showToast(msg: "Cart Empty");
        }
        cartListController.setList(cartListCurrentUser);
      } else {
        Fluttertoast.showToast(msg: "Error");
      }
    } catch (e) {
      print("error" + e.toString());
    }
  }

  calculateTotalAmount() {
    cartListController.setTotal(0);
    if (cartListController.selectedItem.length > 0) {
      cartListController.cartList.forEach((element) {
        if (cartListController.selectedItem.contains(element.cart_id)) {
          double _totalAmount =
              element.price! * double.parse(element.quantity!.toString());
          cartListController.setTotal(cartListController.total + _totalAmount);
        }
      });
    }
  }

  updateCartQuantity(int quantity,int cart_id)async{
    try{
      var res = await http.post(
        Uri.parse(API.updateCart),
        body: {
          "cart_id":cart_id.toString(),
          "quantity":quantity.toString(),
        }
      );
      print(res.body);
      if(res.statusCode == 200){
        var resBody = jsonDecode(res.body);
        if(resBody['success'] == true){
          getCurrentUserCartList();
        }
      }else{
        Fluttertoast.showToast(msg: "Database Unavailable");
      }
    }catch(e){
      print(e);
    }
  }

  @override
  void initState() {
    super.initState();
    getCurrentUserCartList();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text("Cart",style: TextStyle(color: Colors.white),),
        automaticallyImplyLeading: true,
        actions: [
          Obx(()=>
            IconButton(onPressed: (){
              cartListController.setIsSelectedAllItems();
              cartListController.clearAllSelectedItems();
              if(cartListController.isSelectedAll){
                cartListController.cartList.forEach((element) {
                  cartListController.addSelectedItem(element.cart_id!);
                });
              }
              calculateTotalAmount();
            }, icon: Icon(
              cartListController.isSelectedAll? Icons.check_box : Icons.check_box_outline_blank,
              color: cartListController.isSelectedAll?Colors.white:Colors.grey
              ,
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: GetBuilder(
        init: CartListController(),
        builder: (c){
          return Container(
            height: MediaQuery.of(context).size.height/12,
            decoration: BoxDecoration(
              color: Colors.black,
              boxShadow: [
                BoxShadow(
                  offset: Offset(0,-1),
                  color: Colors.black,
                  blurRadius: 6,
                ),
              ],
            ),
            padding: const EdgeInsets.symmetric(horizontal: 16,vertical: 0),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 10.0,horizontal: 4.0),
              child: Row(
                children: [
                  const Text(
                    "Total - ",
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(width: 4,),
                  Obx(()=>
                      Text(
                        "INR "+cartListController.total.toStringAsFixed(2),
                        maxLines: 1,
                        style: TextStyle(color: Colors.white,fontSize: 22,fontWeight: FontWeight.bold),
                      ),),
                  const Spacer(),
                  Material(
                    color: cartListController.selectedItem.length>0? Colors.lightBlueAccent:Colors.white24,
                    borderRadius: BorderRadius.circular(30),
                    child: InkWell(
                      onTap: (){
                        orderNow(cartListController.cartList);
                      },
                      child: const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 25,vertical: 10),
                        child: Text(
                          "Order Now",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          );
        },
      ),
      body: Obx(
        () => cartListController.cartList.length > 0
            ? ListView.builder(
                itemCount: cartListController.cartList.length,
                scrollDirection: Axis.vertical,
                itemBuilder: (BuildContext context, int index) {
                  Cart cartModel = cartListController.cartList[index];
                  Item itemModel = Item(
                    item_id: cartModel.item_id,
                    pizza_name: cartModel.pizza_name.toString(),
                    rating: cartModel.rating,
                    tags: cartModel.tags,
                    price: cartModel.price,
                    base_size: cartModel.base_size,
                    base_style: cartModel.base_style,
                    description: cartModel.description,
                    image: cartModel.image,
                  );
                  return SizedBox(
                    width: MediaQuery.sizeOf(context).width,
                    child: Row(
                      children: [
                        GetBuilder(
                            init: CartListController(),
                            builder: (c) {
                              return IconButton(
                                onPressed: () {
                                  if(cartListController.selectedItem.contains(cartModel.cart_id)){
                                    cartListController.deleteSelectedItem(cartModel.cart_id!);
                                  }else{
                                    cartListController.addSelectedItem(cartModel!.cart_id!);
                                  }
                                  calculateTotalAmount();
                                },
                                icon: Icon(cartListController.selectedItem
                                        .contains(cartModel.cart_id)
                                    ? Icons.check_box
                                    : Icons.check_box_outline_blank),
                                color: cartListController.isSelectedAll
                                    ? Colors.grey
                                    : Colors.grey,
                              );
                            }),
                        Expanded(
                            child: GestureDetector(
                          onTap: () {},
                          child: Container(
                            margin: EdgeInsets.fromLTRB(
                                0,
                                index == 0 ? 16 : 8,
                                16,
                                index == cartListController.cartList.length - 1
                                    ? 16
                                    : 8),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              color: Colors.white,
                              boxShadow: const [
                                BoxShadow(
                                  offset: Offset(0, 0),
                                  blurRadius: 6,
                                  color: Colors.black,
                                )
                              ],
                            ),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Padding(
                                    padding: EdgeInsets.all(10),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.baseline,
                                          textBaseline: TextBaseline.alphabetic,
                                          children: [
                                            Text(
                                              cartModel.pizza_name.toString(),
                                              maxLines: 2,
                                              overflow: TextOverflow.ellipsis,
                                              style: const TextStyle(
                                                fontSize: 18,
                                                color: Colors.black,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            IconButton(
                                                onPressed: () {
                                                  setState(() {
                                                    deleteFromCart(cartModel.cart_id);
                                                  });
                                                },
                                                icon: Icon(
                                                  Icons.delete_forever_outlined,
                                                  color: Colors.red,
                                                )),
                                          ],
                                        ),
                                        const SizedBox(height: 20),
                                        Row(
                                          children: [
                                            Expanded(
                                              child: Text(
                                                "Style : ${cartModel.style!.replaceAll(']', '').replaceAll('[', '')}" +
                                                    "\n" +
                                                    "Size : ${cartModel.size!.replaceAll(']', '').replaceAll('[', '')}",
                                                maxLines: 3,
                                                overflow: TextOverflow.ellipsis,
                                                style: const TextStyle(
                                                  color: Colors.grey,
                                                ),
                                              ),
                                            ),
                                            Padding(
                                              padding: EdgeInsets.only(
                                                  left: 12, right: 12),
                                              child: Text(
                                                "INR" +
                                                    itemModel.price.toString(),
                                                style: const TextStyle(
                                                    fontSize: 20,
                                                    color:
                                                        Colors.lightBlueAccent,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 20),
                                        Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            IconButton(
                                                onPressed: () {
                                                  if(cartModel.quantity! - 1 >0){
                                                    updateCartQuantity(cartModel.quantity!-1, cartModel.cart_id!);
                                                  }
                                                },
                                                icon: Icon(
                                                  Icons.remove_circle_outline,
                                                  color: Colors.grey,
                                                  size: 30,
                                                )),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Text(
                                                cartModel.quantity.toString(),
                                                style: TextStyle(
                                                    color: Colors.black,
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 20),
                                              ),
                                            ),
                                            IconButton(
                                                onPressed: () {
                                                  updateCartQuantity(cartModel.quantity!+1, cartModel.cart_id!);
                                                },
                                                icon: Icon(
                                                  Icons.add_circle_outline,
                                                  color: Colors.grey,
                                                  size: 30,
                                                )),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ))
                      ],
                    ),
                  );
                },
              )
            : Center(child: Text("Cart Is Empty")),
      ),

    );
  }
}
