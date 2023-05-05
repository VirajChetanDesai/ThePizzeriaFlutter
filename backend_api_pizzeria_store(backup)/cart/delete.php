<?php
include '../connection.php';

$cartID = $_POST['cart_id'];

$resultQuery = mysqli_query($connectNow,"DELETE FROM cart_table where cart_id = $cartID");

if($resultQuery){
    echo json_encode(array(
        "success" => true,
    ));
}else{
    echo json_encode(array(
        "success" => false,
    ));
}