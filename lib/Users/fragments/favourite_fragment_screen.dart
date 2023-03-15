import 'package:flutter/material.dart';

class FavouriteFragmentScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Center(child: Text('Favourites'),),
        automaticallyImplyLeading: false,
      ),
      body: Center(
        child: Text('Favourites Fragment Screen'),
      ),
    );
  }
}
