<?php
include '../connection.php';
$user_id = $_POST['user_id'];
$item_id = $_POST['item_id'];
$quantity = $_POST['quantity'];
$style = $_POST['style'];
$size = $_POST['size'];

$resultQuery = mysqli_query($connectNow,"INSERT INTO cart_table (user_id,item_id,quantity,style,size) VALUES ('$user_id','$item_id','$quantity','$style','$size')");

if($resultQuery){
    echo json_encode(array(
        "success"=>true
    ));
}else{
    echo json_encode(array(
        "success"=>false
    ));
}