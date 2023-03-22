<?php
include '../connection.php';
$userEmail = $_POST['user_email'];
$userPassword = md5($_POST['user_password']);

$resultQuery = mysqli_query($connectNow,"SELECT * FROM user_table WHERE user_email='$userEmail' AND user_password='$userPassword'");

if($resultQuery->num_rows > 0){
    $userRecord = array();
    while($rowFound = $resultQuery->fetch_assoc()){
        $userRecord = $rowFound;
    }
    echo json_encode(array(
        "success"=>true,
        "userData"=>$userRecord,
    ));
}else{
    echo json_encode(array("success"=>false));
}
