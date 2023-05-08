<?php
include '../connection.php';

$cartID = $_POST['cart_id'];
$quantity = $_POST['quantity'];

$resultQuery = mysqli_query($connectNow,"UPDATE cart_table SET quantity = '$quantity' where cart_id = '$cartID'");

if($resultQuery){
    echo json_encode(array(
        "success" => true,
    ));
}else{
    echo json_encode(array(
        "success" => false,
    ));
}