<?php
include '../connection.php';
$resultQuery = mysqli_query($connectNow,"select * from backup_table ORDER BY bitem_id DESC");

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