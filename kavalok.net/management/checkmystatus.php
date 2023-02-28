<?php
sec_session_start();

$myusername = $_SESSION['login'];

$mycheck = $mysqli->query("SELECT * FROM User WHERE login = '".$myusername."'");
$mycheck1 = mysqli_fetch_array($mycheck);

$GameChar = mysqli_fetch_array($mysqli->query("SELECT * FROM GameChar WHERE id = '".$mycheck1['gameChar_id']."'"));

if($mycheck1['moderator'] == "1") {
	$mystatus = "moderator"; 
}
?>