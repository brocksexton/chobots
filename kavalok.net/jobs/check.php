<?php

if(isset($_POST['submit'])) 
{
$ip = $_SERVER['REMOTE_ADDR'];
$query = $mysqli->query("SELECT * FROM `job_apps` WHERE `ip` = '$ip'");
$title = $mysqli->real_escape_string($_POST['title']);
$query10 = $mysqli->query("SELECT * FROM `jobs_available` WHERE `job` = '$title'");
if(mysqli_num_rows($query10) >= 1) {
if (mysqli_num_rows($query) <= 0) {
	$firstname = $mysqli->real_escape_string($_POST['firstname']);
	$lastname = $mysqli->real_escape_string($_POST['lastname']);
	$username = $mysqli->real_escape_string($_POST['choname']);
	$date = date('Y-m-d H:i:s');
	$email = $mysqli->real_escape_string($_POST['email']);
	$age = $mysqli->real_escape_string($_POST['age']);
	$country = $mysqli->real_escape_string($_POST['country']);
	$online_time = $mysqli->real_escape_string($_POST['hours']);
	$experience = $mysqli->real_escape_string($_POST['experience']);
	$why = $mysqli->real_escape_string($_POST['why']);
	$website = $mysqli->real_escape_string($_POST['website']);
	$mysqli->query("INSERT INTO job_apps (rank, first_name, last_name, username, date, email, location, online_time, age, experience, why, website, ip) VALUES ('$title','$firstname','$lastname','$username','$date','$email','$country','$online_time','$age','$experience','$why','$website','$ip')");
	$error = "Application successfully submitted";
} else { $error = "You have already submitted an application."; }
} else { $error = "Job does not exist"; }
}

?>