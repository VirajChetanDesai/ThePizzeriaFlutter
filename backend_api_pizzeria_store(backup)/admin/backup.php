<?php
include '../connection.php';

$ItemId= $_POST['ItemID'];
$AdminEmail = $_POST['AdminEmail'];
$resultQuery = mysqli_query($connectNow,"SELECT * FROM backup_table where bitem_id=$ItemId and badmin_email = '$AdminEmail'");

if($resultQuery->num_rows > 0){
    $itemsRecord = array();
    while($rowFound = $resultQuery->fetch_assoc()){
        $itemsRecord[] = $rowFound;
    }
    echo json_encode(
        array(
            "success"=>true,
            "itemsData"=> $itemsRecord,
        )
    );
}else{
    echo json_encode(array("success"=>false));
}