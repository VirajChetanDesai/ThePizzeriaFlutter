import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:pizzeria/Users/Controllers/order_now_controller.dart';
import 'package:pizzeria/Users/model/cart.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:pizzeria/Users/Cart/cart_screen.dart';
import 'package:pizzeria/Users/Item/ItemDetails.dart';
import 'package:pizzeria/Users/fragments/search_fragment.dart';
import 'package:pizzeria/Users/model/item.dart';
import 'package:http/http.dart' as http;
import 'package:pizzeria/api_connection/api_connection.dart';
import 'package:pizzeria/user_preferences/current_user.dart';
import 'package:pizzeria/Users/Controllers/cart_list_controller.dart';
import 'package:get/get.dart';

class OrderNowScreen extends StatelessWidget {
  final List<Map<String,dynamic>> selectedCartList;
  final  double totalAmount;
  final List<int> selectedCartID;
  OrderNowController orderNowController = Get.put(OrderNowController());
  OrderNowScreen(this.selectedCartList,this.totalAmount,this.selectedCartID,{super.key});
  List<String> deliverySystemList = ['DTDC','DHL','FEDx','UPS'];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text("Delivery System", style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 10,
          ),),
        automaticallyImplyLeading: false,
        backgroundColor: Colors.black,
      ),
      body: ListView(
          //choose delivery type
          prototypeItem: Padding(
            padding: const EdgeInsets.all(18.0),
              child: Column(
                children: deliverySystemList.map((e) {
                  return Obx(() => RadioListTile<String>(
                    tileColor: Colors.black,
                    dense: true,
                    activeColor: Colors.lightBlueAccent,
                    title: Text(
                      e,
                      style: const TextStyle(fontSize: 16, color: Colors.white),
                    ),
                    value: e,
                    groupValue: orderNowController.deliverySystem,
                    onChanged: (deliverySystem) {
                      orderNowController.setDelivery(deliverySystem!);
                    },
                  ));
                }).toList(),
              )

          ),
          //choose payment method
      ),
    );
  }
}
