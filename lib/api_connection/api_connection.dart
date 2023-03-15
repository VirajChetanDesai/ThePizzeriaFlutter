class API{
  static const hostConnect = "http://10.122.3.170/api_pizzeria_store";//uri
  static const hostConnectUser = "http://10.122.3.170/api_pizzeria_store/user";
  static const hostConnectAdmin = "http://10.122.3.170/api_pizzeria_store/admin";
  //sign in
  static const validateEmail = '$hostConnect/user/validate_email.php';
  static const signup = '$hostConnect/user/signup.php';
  static const login = '$hostConnect/user/login.php';
  static const adminLogin = '$hostConnectAdmin/admin_login.php';
}

