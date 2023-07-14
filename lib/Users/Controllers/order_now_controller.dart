import 'package:get/get.dart';

class OrderNowController extends GetxController{
  RxString _deliverySystem = "DTDC".obs;
  RxString _paymentSystem = "HDFC".obs;

  String get deliverySystem => _deliverySystem.value;
  String get paymentSystem => _paymentSystem.value;

  setDelivery(String deliverySystem){
    _deliverySystem = deliverySystem as RxString;
  }
  setPayment(String paymentSystem){
    _paymentSystem = paymentSystem as RxString;
  }
}