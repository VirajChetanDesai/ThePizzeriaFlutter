<?php
include '../connection.php';

$itemID = $_POST['item_id'];
$name = $_POST['name'];
$rating = $_POST['rating'];
$tags = $_POST['tags'];
$price = $_POST['price'];
$pizzaSize = $_POST['pizza_size'];
$base = $_POST['pizza_base'];
$description = $_POST['description'];
$image = $_POST['image'];
$adminEmail = $_POST['admin_email'];


$resultQuery = mysqli_query($connectNow,"UPDATE items_table SET name = '$name', rating = '$rating', tags = '$tags', price = '$price', pizza_size = '$pizzaSize', base = '$base', description = '$description', image = '$image' WHERE item_id = '$itemID'");

if($resultQuery){
    echo json_encode(array(
        "success" => true,
    ));
}else{
    echo json_encode(array(
        "success" => false,
    ));
}