<?php
include '../connection.php';
$userEmail = $_POST['user_email'];
$result_query = mysqli_query($connectNow,"SELECT * FROM user_table where user_email='$userEmail'");
if($result_query->num_rows > 0){
    echo json_encode(array("emailFound"=>true));
}else{
    echo json_encode(array("emailFound"=>false));
}