<?php
include '../connection.php';
$itemName = $_POST['name'];
$itemRating = $_POST['rating'];
$itemTags = $_POST['tags'];
$itemPrice = $_POST['price'];
$itemSizes = $_POST['sizes'];
$itemBase = $_POST['base'];
$itemDescription = $_POST['description'];
$itemImage = $_POST['image'];

$resultQuery = mysqli_query($connectNow,"INSERT INTO items_table(name,rating,tags,price,size,base,description,image) VALUES('$itemName','$itemRating','$itemTags','$itemPrice','$itemSizes','$itemBase','$itemDescription','$itemImage')");

if($resultQuery){
    echo json_encode(array(
        "success" =>true
    ));
}else{
    echo json_encode(array(
        "success" => false
    ));
}