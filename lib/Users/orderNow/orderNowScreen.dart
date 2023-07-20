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
import 'package:pizzeria/Users/orderNow/order_confirmation.dart';

class OrderNowScreen extends StatelessWidget {
  final List<Map<String, dynamic>> selectedCartList;
  final double totalAmount;
  final List<int> selectedCartID;
  final OrderNowController orderNowController = Get.put(OrderNowController());
  OrderNowScreen(
    this.selectedCartList,
    this.totalAmount,
    this.selectedCartID, {
    Key? key,
  }) : super(key: key);

  final List<String> deliverySystemList = ['DTDC', 'DHL', 'FedEx', 'UPS'];
  final List<String> paymentSystemList = ['UPI', 'Cash', 'NetBanking'];
  TextEditingController phoneNo = TextEditingController();
  TextEditingController address = TextEditingController();
  TextEditingController instructions = TextEditingController();
  displaySelectedItems() {
    return Column(
        children: List.generate(selectedCartList.length, (index) {
      Map<String, dynamic> item = selectedCartList![index];
      return Container(
        margin: EdgeInsets.fromLTRB(16, index == 0 ? 16 : 0, 16,
            index == selectedCartList.length ? 16 : 10),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: Colors.black,
            boxShadow: const [
              BoxShadow(
                offset: Offset(0, 0),
                blurRadius: 6,
                color: Colors.black26,
              )
            ]),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(20),
                bottomLeft: Radius.circular(20),
              ),
              child: FadeInImage(
                height: 130,
                width: 130,
                fit: BoxFit.cover,
                placeholder: const AssetImage('images/img.png'),
                image: NetworkImage(item['image']),
              ),
            ),
            Expanded(
                child: Padding(
              padding: EdgeInsets.all(8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item['name'],
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 20,
                      color: Colors.white70,
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Text(
                    "size: "+item['size']+" style: "+item['style'],
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 12,
                      color: Colors.white54,
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Text(
                    "INR ${item['totalAmount']/item['quantity']}",
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.lightBlueAccent,
                      fontWeight: FontWeight.bold
                    ),
                  ),
                ],
              ),
            )),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text("Qty "+item["quantity"].toString(),
              style: const TextStyle(color: Colors.white54,fontSize: 12),),
            ),
          ],
        ),
      );
    }));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          "Order Now",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        backgroundColor: Colors.black,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Expanded(
          child: ListView(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  displaySelectedItems(),
                  const SizedBox(
                    height: 10,
                  ),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(8.0),
                    decoration: const BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                    ),
                    child: const Center(
                      child: Text(
                        "Delivery System",
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  ListView.builder(
                    shrinkWrap: true,
                    itemCount: deliverySystemList.length,
                    itemBuilder: (context, index) {
                      final deliverySystem = deliverySystemList[index];
                      return Obx(() => ListTile(
                            tileColor: Colors.black,
                            dense: true,
                            title: Text(
                              deliverySystem,
                              style:
                                  TextStyle(fontSize: 16, color: Colors.white),
                            ),
                            leading: Radio<String>(
                              value: deliverySystem,
                              groupValue: orderNowController.deliverySystem,
                              onChanged: (value) {
                                orderNowController.setDelivery(value!);
                              },
                            ),
                            onTap: () {
                              orderNowController.setDelivery(deliverySystem);
                            },
                          ));
                    },
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(8.0),
                    decoration: const BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                    ),
                    child: const Center(
                      child: Text(
                        "Payment System",
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  ListView.builder(
                    shrinkWrap: true,
                    itemCount: paymentSystemList.length,
                    itemBuilder: (context, index) {
                      final paymentSystem = paymentSystemList[index];
                      return Obx(() => ListTile(
                            tileColor: Colors.black,
                            dense: true,
                            title: Text(
                              paymentSystem,
                              style:
                                  TextStyle(fontSize: 16, color: Colors.white),
                            ),
                            leading: Radio<String>(
                              value: paymentSystem,
                              groupValue: orderNowController.paymentSystem,
                              onChanged: (value) {
                                orderNowController.setPayment(value!);
                              },
                            ),
                            onTap: () {
                              orderNowController.setPayment(paymentSystem);
                            },
                          ));
                    },
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(8.0),
                    decoration: const BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                    ),
                    child: const Center(
                      child: Text(
                        "Phone Number",
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Padding(
                    padding: EdgeInsets.all(5),
                    child: TextField(
                      style: const TextStyle(
                          backgroundColor: Colors.white,
                          color: Colors.black,
                          fontSize: 15),
                      controller: phoneNo,
                      decoration: InputDecoration(
                        hintText: 'Enter Phone Number..',
                        hintStyle: TextStyle(color: Colors.grey),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.lightBlueAccent,
                            width: 2,
                          ),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.grey,
                            width: 1,
                          ),
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(8.0),
                    decoration: const BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                    ),
                    child: const Center(
                      child: Text(
                        "Address",
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Padding(
                    padding: EdgeInsets.all(5),
                    child: TextField(
                      style: const TextStyle(
                          backgroundColor: Colors.white,
                          color: Colors.black,
                          fontSize: 15),
                      controller: address,
                      decoration: InputDecoration(
                        hintText: 'Enter Address..',
                        hintStyle: TextStyle(color: Colors.grey),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.lightBlueAccent,
                            width: 2,
                          ),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.grey,
                            width: 1,
                          ),
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(8.0),
                    decoration: const BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                    ),
                    child: const Center(
                      child: Text(
                        "Delivery Instructions",
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Padding(
                    padding: EdgeInsets.all(5),
                    child: TextField(
                      style: const TextStyle(
                          backgroundColor: Colors.white,
                          color: Colors.black,
                          fontSize: 15),
                      controller: instructions,
                      decoration: InputDecoration(
                        hintText: 'Enter Instructions..',
                        hintStyle: TextStyle(color: Colors.grey),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.lightBlueAccent,
                            width: 2,
                          ),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.grey,
                            width: 1,
                          ),
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Material(
                      color: (phoneNo.text != "" && address.text!="")? Colors.grey : Colors.lightBlueAccent,
                      borderRadius: BorderRadius.circular(10),
                      child: InkWell(
                        onTap: () {
                          if(phoneNo.text != "" && address.text!=""){
                            Get.to(OrderConfirmationScreen(
                                selectedCartID,
                                selectedCartList,
                                totalAmount,
                                paymentSystemList,
                                orderNowController.deliverySystem,
                                phoneNo.text,
                                address.text,
                                instructions.text
                            ));
                          }
                        },
                        borderRadius: BorderRadius.circular(20),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 5, vertical: 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Text(
                                "${totalAmount.toStringAsFixed(2)} INR",
                                style: const TextStyle(
                                  color: Colors.white70,
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const Text(
                                "Pay Now",
                                style: TextStyle(
                                  color: Colors.white70,
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
