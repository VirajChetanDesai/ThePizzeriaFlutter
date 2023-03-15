import 'package:flutter/material.dart';

class OrderFragmentScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Center(child: Text('Orders'),),
        automaticallyImplyLeading: false,
      ),
      body: Center(
        child: Text('Order Fragment Screen'),
      ),
    );
  }
}
