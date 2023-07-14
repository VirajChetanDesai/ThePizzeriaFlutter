import 'package:flutter/material.dart';

class Favourite{
  int? favourite_id;
  String? user_id;
  int? item_id;
  String? pizza_name;
  double? rating;
  double? price;
  List<String>? tags;
  List<String>? base_size;
  List<String>? base_style;
  String? description;
  String? image;
  Favourite({this.favourite_id,this.user_id,this.item_id,
    this.pizza_name,this.rating,this.price,this.tags,this.base_size,this.base_style,
    this.description,this.image});
  factory Favourite.fromJson(Map<String,dynamic> json)=> Favourite(
    favourite_id: int.parse(json['favourite_id']),
    user_id: json['user_id'],
    item_id: int.parse(json['item_id']),
    pizza_name: json['name'],
    rating: double.parse(json['rating']),
    price: double.parse(json['price']),
    tags: json['tags'].toString().split(','),
    base_style: json['base_style'].toString().split(','),
    base_size: json['base_size'].toString().split(','),
    description: json['description'],
    image: json['image'],
  );
}