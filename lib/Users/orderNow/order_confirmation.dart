import 'package:get/get.dart';
import 'package:flutter/material.dart';

class OrderConfirmationScreen extends StatelessWidget {
  final List<int> selectedCartID;
  final List<Map<String, dynamic>> selectedCartList;
  final int totalAmount;
  final double paymentSystemList;
  final String deliverySystem;
  final String phoneNo;
  final String address;
  final String instructions;
  OrderConfirmationScreen(this.selectedCartID,this.selectedCartList,
      this.totalAmount, this.paymentSystemList,
      this.deliverySystem, this.phoneNo , this.address, this.instructions, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
