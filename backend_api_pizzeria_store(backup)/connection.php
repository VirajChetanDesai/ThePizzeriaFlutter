<?php
$serverHost = "localhost:4306";
$user = "root";
$password = "";
$database = "pizzeria_app";
$connectNow = new mysqli($serverHost,$user,$password,$database);
if(!$connectNow){
    print('Unable to connect');
}
