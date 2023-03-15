import 'package:flutter/material.dart';

class HomeFragmentScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Center(child: Text('Home'),),
        automaticallyImplyLeading: false,
      ),
      body: Center(
        child: Text('Home Fragment Screen'),
      ),
    );
  }
}
