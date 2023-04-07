<?php
include '../connection.php';

$limitItems = 3;
$resultQuery = mysqli_query($connectNow,"select * from items_table ORDER BY rating DESC LIMIT $limitItems");

if($resultQuery->num_rows > 0){
    $itemsRecord = array();
    while($rowFound = $resultQuery->fetch_assoc()){
        $itemsRecord[] = $rowFound;
    }
    echo json_encode(
        array(
            "success"=>true,
            "itemsData"=>$itemsRecord,
        )
    );
}else{
    echo json_encode(array("success"=>false));
}