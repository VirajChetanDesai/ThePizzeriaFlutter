<?php
include '../connection.php';
$currentOnlineUserID = $_POST['currentOnlineUserID'];

$resultQuery = mysqli_query($connectNow,"SELECT * FROM cart_table INNER JOIN items_table ON cart_table.item_id = items_table.item_id WHERE cart_table.user_id = '$currentOnlineUserID'");

if($resultQuery->num_rows > 0){
    $cartRecord = array();
    while($rowFound = $resultQuery->fetch_assoc()){
        $cartRecord[] = $rowFound;
    }
    echo json_encode(array(
        "success"=>true,
        "cartData"=>$cartRecord,
    ));
}else{
    echo json_encode(array("success"=>false));
}
