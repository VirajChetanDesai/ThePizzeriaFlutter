<?php
include '../connection.php';
$adminEmail = $_POST['admin_email'];
$adminPassword =$_POST['admin_password'];
$result_query = mysqli_query($connectNow,"SELECT * FROM admin_table where admin_email = '$adminEmail' and admin_password = '$adminPassword'");

if($result_query->num_rows > 0){
    $adminRecord = array();
    while($rowfound = $result_query->fetch_assoc()){
        $adminRecord = $rowfound;
    }
    echo json_encode(
            array(
                'success'=>true,
                'admin_data'=>$adminRecord,
            )
        );
    }
    else{
        echo json_encode(
                array(
                    'success'=>false,
                )
            );
    }
