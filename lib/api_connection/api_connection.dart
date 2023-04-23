class API{
  static const hostConnect = "http://10.122.3.26/api_pizzeria_store";//uri
  static const hostConnectUser = "http://10.122.3.26/api_pizzeria_store/user";
  static const hostConnectAdmin = "http://10.122.3.26/api_pizzeria_store/admin";
  static const hostConnectItems = "http://10.122.3.26/api_pizzeria_store/items";
  static const validateEmail = '$hostConnectUser/validate_email.php';
  static const signup = '$hostConnectUser/signup.php';
  static const login = '$hostConnectUser/login.php';
  static const adminLogin = '$hostConnectAdmin/admin_login.php';
  static const upload = '$hostConnectItems/upload.php';
  static const retrieve = '$hostConnectItems/retrieve.php';
  static const trending = '$hostConnectItems/trending.php';
}

