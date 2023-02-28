<div style="display: block; padding: 10px; font-family: Helvetica, Arial, sans-serif; background: #00b3ed; color: #fff;" class="bottom">
<?php
$username = $_SESSION['market']['username']; 
$getAuctionBugs = mysqli_fetch_array($mysqli->query("SELECT `marketBalance` FROM `User` WHERE `login` = '".$username."'")); 
$auctionBugs = $getAuctionBugs['marketBalance'];
?>
<center>Welcome, <?= ucfirst($username) ?>! You have <?= $auctionBugs ?> bugs in you'r market balance</br>
<a href="./shelves">Home</a> | <a href="./myAuctions">My Auctions</a> | <a href="./financial">Add Funds</a> | <a href="./wardrobe">Wardrobe</a> | <a href="./safe">Vault</a> | <a href="./logout">Logout</a></div>
</center>
