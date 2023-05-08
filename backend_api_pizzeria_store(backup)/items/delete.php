<?php
include '../connection.php';

$ItemId= $_POST['ItemID'];

$resultQuery=mysqli_query($connectNow,"DELETE FROM items_table where item_id=$ItemId");

if($resultQuery){
    echo json_encode(
        array(
            "success"=>true,
        )
    );
}else{
    echo json_encode(array("success"=>false));
}