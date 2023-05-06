import 'package:flutter/material.dart';

class Item {
  int? item_id;
  String? pizza_name;
  double? rating;
  double? price;
  List<String>? tags;
  List<String>? base_size;
  List<String>? base_style;
  String? description;
  String? image;

  Item(
      {this.item_id, this.pizza_name, this.rating, this.tags, this.price, this.base_size, this.base_style, this.description, this.image});

  factory Item.fromJson(Map<String, dynamic> json)=> Item(
    item_id: int.parse(json["item_id"]),
    pizza_name: json["name"],
    rating: double.parse(json["rating"]),
    tags: json["tags"].toString().split(', '),
    price: double.parse(json["price"]),
    base_size: json["pizza_size"].toString().split(', '),
    base_style: json["base"].toString().split(', '),
    description: json["description"],
    image: json["image"],
  );

  factory Item.fromJson2(Map<String, dynamic> json)=> Item(
    item_id: int.parse(json["bitem_id"]),
    pizza_name: json["bname"],
    rating: double.parse(json["brating"]),
    tags: json["btags"].toString().split(', '),
    price: double.parse(json["bprice"]),
    base_size: json["bpizza_size"].toString().split(', '),
    base_style: json["bbase"].toString().split(', '),
    description: json["bdescription"],
    image: json["bimage"],
  );
}