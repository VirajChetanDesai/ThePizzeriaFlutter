class API{
  static const ip = '10.122.3.26';
  static const hostConnect = "http://$ip/api_pizzeria_store";//uri
  static const hostConnectUser = "http://$ip/api_pizzeria_store/user";
  static const hostConnectAdmin = "http://$ip/api_pizzeria_store/admin";
  static const hostConnectItems = "http://$ip/api_pizzeria_store/items";
  static const hostConnectionCart = "http://$ip/api_pizzeria_store/cart";
  static const validateEmail = '$hostConnectUser/validate_email.php';
  static const signup = '$hostConnectUser/signup.php';
  static const login = '$hostConnectUser/login.php';
  static const adminLogin = '$hostConnectAdmin/admin_login.php';
  static const upload = '$hostConnectItems/upload.php';
  static const retrieve = '$hostConnectItems/retrieve.php';
  static const trending = '$hostConnectItems/trending.php';
  static const addtoCart = '$hostConnectionCart/add.php';
  static const getCartList = '$hostConnectionCart/read.php';
}

