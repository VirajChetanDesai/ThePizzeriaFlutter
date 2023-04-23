import 'package:flutter/material.dart';
import 'package:get/get.dart';
class ItemDetailsController extends GetxController{
  RxInt _quantityItem = 1.obs;
  RxInt _sizeItem = 0.obs;
  RxInt _styleItem = 0.obs;
  RxBool _isFavorite = false.obs;
  int get quantity => _quantityItem.value;
  int get size => _sizeItem.value;
  int get style => _styleItem.value;
  bool get isFavorite => _isFavorite.value;

  setQuantityItem(int quantity){
    _quantityItem.value = quantity;
  }
  setSizeItem(int size){
    _sizeItem.value = size;
  }
  setStyleItem(int style){
    _styleItem.value = style;
  }
  setFavoriteItem(bool favorite){
    _isFavorite.value = favorite;
  }
}


