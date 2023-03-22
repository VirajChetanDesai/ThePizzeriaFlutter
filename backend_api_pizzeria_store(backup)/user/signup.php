<?php
include '../connection.php';
//post = send data , get = recieve data
$userName = $_POST['user_name'];
$userEmail = $_POST['user_email'];
$userPassword = md5($_POST['user_password']);
//query to add user into db if they do not exist
$result_query = mysqli_query($connectNow,"INSERT INTO user_table(user_name,user_email,user_password) VALUES ('$userName','$userEmail','$userPassword')");
//if successful the value success is given as true else false
if($result_query){
    echo json_encode(array("success"=>true));
}else{
    echo json_encode(array("success"=>false));
}