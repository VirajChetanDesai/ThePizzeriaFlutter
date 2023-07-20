import 'package:get/get.dart';

class OrderNowController extends GetxController{
  RxString _deliverySystem = "DTDC".obs;
  RxString _paymentSystem = "UPI".obs;

  String get deliverySystem => _deliverySystem.value;
  String get paymentSystem => _paymentSystem.value;

  setDelivery(String deliverySystem){
    _deliverySystem.value = deliverySystem;
  }
  setPayment(String paymentSystem){
    _paymentSystem.value = paymentSystem;
  }
}