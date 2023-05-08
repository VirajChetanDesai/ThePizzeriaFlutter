<?php
include '../connection.php';

$backupID = $_POST['backup_id'];

$resultQuery = mysqli_query($connectNow,"DELETE FROM backup_table where bitem_id = $backupID");

if($resultQuery){
    echo json_encode(array(
        "success" => true,
    ));
}else{
    echo json_encode(array(
        "success" => false,
    ));
}