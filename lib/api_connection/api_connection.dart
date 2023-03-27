class API{
  static const hostConnect = "http://10.122.1.166/api_pizzeria_store";//uri
  static const hostConnectUser = "http://10.122.1.166/api_pizzeria_store/user";
  static const hostConnectAdmin = "http://10.122.1.166/api_pizzeria_store/admin";
  static const hostConnectItems = "http://10.122.1.166/api_pizzeria_store/items";
  //sign in
  static const validateEmail = '$hostConnectUser/validate_email.php';
  static const signup = '$hostConnectUser/signup.php';
  static const login = '$hostConnectUser/login.php';
  static const adminLogin = '$hostConnectAdmin/admin_login.php';
  static const upload = '$hostConnectItems/upload.php';
}

