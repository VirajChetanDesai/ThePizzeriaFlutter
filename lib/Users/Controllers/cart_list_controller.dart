import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:pizzeria/Users/model/cart.dart';
class CartListController extends GetxController{
  RxList<Cart> _cartList = <Cart>[].obs;
  RxList<int> _selectedItem = <int>[].obs;
  RxBool _isSelectedAll = false.obs;
  RxDouble _total = 0.0.obs;

  List<Cart> get cartList => _cartList.value;
  List<int> get selectedItem => _selectedItem.value;
  bool get isSelectedAll => _isSelectedAll.value;
  double get total => _total.value;

  setList(List<Cart> list){
    _cartList.value = list;
  }

  addSelectedItem(int itemSelectedId){
    _selectedItem.value.add(itemSelectedId);
    update();
  }

  removeSelectedItem(int itemSelectedId){
    _selectedItem.value.remove(itemSelectedId);
    update();
  }

  setIsSelectedAllItems(){
    _isSelectedAll.value = !_isSelectedAll.value;
  }

  clearAllSelectedItems(){
    _selectedItem.value.clear();
    update();
  }

  setTotal(double overallTotal){
    _total.value = overallTotal;
  }
}