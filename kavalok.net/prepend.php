<?php
error_reporting(1);
ini_set('display_errors', 1);
//error_reporting(E_ALL);

$host = "localhost"; // Database Host
$user = "username"; // Database Username
$pass = "password"; // Database Password
$database = "dbname"; // Database Name
$url = "example.com"; // Url without http://
$c_url = "Chobots"; // Name of your chobots
$paypal = "email@email.com"; // Payments go to this paypal
$free_bugs = "true"; //Free Bugs
$free_citizen = "true"; // Free Citizen
$twitter_consumerKey = "";
$twitter_consumerSecret = "";


///////////////DONT TOUCH BELOW/////////////////
$mysqli = new mysqli($host, $user, $pass, $database);
$current_ip = $_SERVER['REMOTE_ADDR'];

$cur_dir = explode('/', getcwd());
$cur_dir = $cur_dir[count($cur_dir)-1];
$website = mysqli_fetch_array($mysqli->query("SELECT * FROM `website` WHERE `id` = '1'"));

if(($website['maintenance'] == 'true') && (basename($_SERVER['PHP_SELF']) != "maintenance.php")) {
	header('Location: /maintenance');
} else if(basename($_SERVER['PHP_SELF']) == "maintenance.php") {
	header('Location: /');
}

if(($cur_dir == 'jobs') && ($website['jobs_enabled'] == 'false')) {
	header('Location: /jobsmaintenance');
} else if((($cur_dir == 'shop') && ($website['shop_enabled'] == 'false')) && (basename($_SERVER['PHP_SELF']) != "maintenance.php")) {
	header('Location: /shop/maintenance');
}

?>
