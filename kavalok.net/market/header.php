<?php
$username = $_SESSION['market']['username'];
$getAuctionBugs = mysqli_fetch_array($mysqli->query("SELECT `marketBalance`,`gameChar_id` FROM `User` WHERE `login` = '".$username."'")); 
$auctionBugs = $getAuctionBugs['marketBalance'];
if($auctionBugs < 0) {
	header("Location: ./financial");
}
?>