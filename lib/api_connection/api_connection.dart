class API{
  static const ip = '192.168.191.13';
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
  static const deleteCartItem = '$hostConnectionCart/delete.php';
  static const deleteItemFromDB = '$hostConnectItems/delete.php';
  static const retrieveDeletedItems = '$hostConnectAdmin/backup.php';
  static const retrieveAllDeletedItems = '$hostConnectAdmin/allbackup.php';
  static const deleteBackupDeletedItems = '$hostConnectAdmin/backupdelete.php';
  static const updateItem = '$hostConnectAdmin/update.php';
  static const updateCart = '$hostConnectionCart/update.php';
}

