<!DOCTYPE HTML>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
	<title>Chobots Market</title>
<?php
session_start();
include("header.php");
if(empty($_SESSION['market']['username'])) {
	$ref = $_SERVER['REQUEST_URI'];
	header("Location: ./login?r=$ref");
}

$auctionId = $_GET['auction'];
$currentInfo = $mysqli->query("SELECT * FROM `MarketSales` WHERE `id` = '".$auctionId."'");
$getCurrentBid = mysqli_fetch_array($currentInfo);
$auctionExists = mysqli_num_rows($currentInfo);

$finishTime = $getCurrentBid['endDate'];

if(empty($auctionId) || ($auctionExists != '1' || $getCurrentBid['active'] == 'false')) { 
	header("Location: ./shelves?v=1");
}

$date = date('Y-m-d H:i:s');
$strDate = strtotime($date);

$userInfo = mysqli_fetch_array($mysqli->query("SELECT `gameChar_id`,`marketBalance` FROM `User` WHERE `login` = '".$username."' LIMIT 1"));
$gameCharInfo = mysqli_fetch_array($mysqli->query("SELECT `money` FROM `GameChar` WHERE `id` = '".$userInfo['gameChar_id']."'"));

if($getCurrentBid['buyer'] == $username) {
	$amIWinner = '1';
} else {
	$amIWinner = '0';
}

if($strDate < $finishTime) {
	$finished = '0'; // Hasn't Finished
} else {
	$finished = '1'; // Finished
}

if($getCurrentBid['createdBy'] == $username) {
	$iAmOwner = '1'; // Person is owner
} else {
	$iAmOwner = '0'; // Person isn't owner
}

if(isset($_POST['complete'])) {
	if($amIWinner == '1' && $finished == '1') {
		$buyer = $getCurrentBid['buyer'];
		$buyerId = mysqli_fetch_array($mysqli->query("SELECT `gameChar_id` FROM `User` WHERE `login` = '".$buyer."' LIMIT 1"));
		if($buyer && $buyerId['gameChar_id']) {
			$soldItemId = $getCurrentBid['itemId'];
			$price = $getCurrentBid['currentBid'];
			$mysqli->query("UPDATE `StuffItem` SET `used` = b'0', `gameChar_id` = '".$buyerId['gameChar_id']."' WHERE `id` = '".$soldItemId."'");
			$mysqli->query("UPDATE `User` SET `marketBalance` = marketBalance - $price WHERE `login` = '".$buyer."'");
			$mysqli->query("UPDATE `User` SET `marketBalance` = marketBalance + $price WHERE `login` = '".$getCurrentBid['createdBy']."'");
			$mysqli->query("UPDATE `MarketSales` SET `active` = 'false' WHERE `id` = '".$auctionId."'");
			header("Location: ./");
		} else { $message = "No buyers!"; }
	} else { $message = "You aren't owner"; }
}

if(isset($_POST['deny'])) {
	if($amIWinner == '1' && $finished == '1') {
		$soldItemId = $getCurrentBid['itemId'];
		$mysqli->query("UPDATE `StuffItem` SET `gameChar_id` = '".$userInfo['gameChar_id']."' WHERE `id` = '".$soldItemId."'");
		//$mysqli->query("UPDATE `User` SET `marketBalance` = marketBalance - 5000 WHERE `login` = '".$username."'");
		$mysqli->query("UPDATE `MarketSales` SET `active` = 'false' WHERE `id` = '".$auctionId."'");
		header("Location: ./logout");
	} else { $note = "Your not the owner of that item"; }
}

if(isset($_POST['bid'])) {
	$newBid = $mysqli->real_escape_string($_POST['newBid']);
	if($userInfo['marketBalance'] >= $newBid) { // Check if you have enough bugs
		if($finished == '0') { // make sure the bid hasnt finished
			if($iAmOwner == '0') { // make sure you're not owner
				if($newBid > $getCurrentBid['currentBid']) {
					$mysqli->query("UPDATE `MarketSales` SET `buyer` = '".$username."', `currentBid` = '".$newBid."', `bidNum` = bidNum + 1 WHERE `id` = '".$auctionId."'");
					$message = "You successfully placed a bid on this auction";
				} else { $message = "You cant bid less than the current bid"; }
			} else { $message = "You cannot bid on your own item"; }
		} else { $message = "This auction has already finished"; }
	} else { $message = "You don't have enough bugs in your market balance to bid on this item"; }
}

$currentInfo = $mysqli->query("SELECT * FROM `MarketSales` WHERE `id` = '".$auctionId."'");
$getCurrentBid = mysqli_fetch_array($currentInfo);

if($v == '1') {
	$note = "This auction doesn't exist.";
}

?>

<style type="text/css">
	body { font-family: Helvetica, Arial, sans-serif; }
</style>
	  <link rel="icon" href = "/favicon.png" type="image/png">
	  <link href="/stylesheets/style.css" rel="stylesheet" type="text/css" media="screen" />

</head>
<body>

	<div class="wrapper">
	<div class="content general">
	<div class="text"> 
	<div class="menu">
		<ul>
    <li><span><span><a href="/index"><span><span>Home</span></span></a></li>
	<li><span><span><a href="/management/shop"><span><span>Shop</span></span></a></li>
	<li><span><span><a href="http://blog.<?php echo $url; ?>/"><span><span>Community</span></span></a></li>
	<li><span><span><a href="/management"><span><span>Management</span></span></a></li>
    <li class="current"><span><span><a href="/market/"><span><span>Market</span></span></a></li>
	<li class="play"><a href="/play"></a></li>
	  	</ul>
	</div> 
    <div class="logo"><a href="http://<?= $url ?>/"><img src="/images/logo_inner.png" alt="Chobots" /></a></div> 
    <div class="inner">
	<h1>Place your bid</h1>
	<center>
<form method="post" style="display: inline-block;">
<?php
$theItem = mysqli_fetch_array($mysqli->query("SELECT `type_id`,`color` FROM `StuffItem` WHERE `id` = '".$getCurrentBid['itemId']."'"));
$itemInfo = mysqli_fetch_array($mysqli->query("SELECT `fileName`,CAST(`premium` AS unsigned integer) AS `premium` FROM `StuffType` WHERE `id` = '".$theItem['type_id']."'"));
if($getCurrentBid['buyer'] == $username) {
	if($finished == '1') {
		echo "<h2><u>You have won this item</u></h2>";
	} else {
		echo "<h2><u>You are winning this item</u></h2>";
	}
}
?>
This item was listed by <?= ucfirst($getCurrentBid['createdBy']) ?></br>
<embed src='/game/ItemViewer.swf?name=<?= $itemInfo['fileName'] ?>&color=0x<?= dechex($theItem['color']) ?>&citizen=<?= $itemInfo['premium'] ?>' wmode='transparent' width='200' height='200'></embed>

<table width="100%" cellpadding="5" cellspacing="0">

<?php 
if($getCurrentBid['currentBid'] == $getCurrentBid['startingBid']) {
?>
<tr>
<td width="50%" align="right"><b>Starting bid</b></td>
<td>    <?= $getCurrentBid['startingBid'] ?> <div style='width: 15px; height: 15px; display: inline-block;background: url(http://<?= $url ?>/images/bug-coin.png) no-repeat; position: relative; top: 1px;'></div></td>
</tr>
<?php } else { ?>
<tr>
<td align="right"><b>Current bid</b></td>
<td><?= $getCurrentBid['currentBid'] ?> <div style='width: 15px; height: 15px; display: inline-block;background: url(http://<?= $url ?>/images/bug-coin.png) no-repeat; position: relative; top: 1px;'></div></td>
</tr>
<?php } ?>
<?php if($getCurrentBid['bidNum'] != '0') { ?>
<tr>
<td align="right"><b>Highest Bidder</b></td>
<td><?= ucfirst($getCurrentBid['buyer']) ?></td>
</tr>
<?php } ?>
<tr>
<td align="right"><b>Number of Bids</b></td>
<td><?= $getCurrentBid['bidNum'] ?></td>
</tr>
<?php if($iAmOwner == '0') { // Not Owner
if($finished == '0') { // Not Finished ?>
<tr>
<td align="right"><b>Your bid</b></td>
<td><input name="newBid" type="number" min="<?php $newBid = $getCurrentBid['currentBid'] + 1; echo $newBid; ?>" value="<?= $newBid ?>"><div style='width: 15px; height: 15px; display: inline-block;background: url(http://<?= $url ?>/images/bug-coin.png) no-repeat; position: relative; top: 4px;'></div></td>
</tr>
<?php 
$note = "By pressing 'Place Bid' you're confirming that you would like to purchase this item up for sale in the Chobots Market. By doing so, you're ensuring you'll be able to pay for the item if you win. At the end of the billing period if you don't have enough bugs to cover the costs, your account will be held until you either <b>a)</b> Place enough bugs into your market to cover the cost, or <b>b)</b> Forfeit the item and be barred from the Chobots Market.";
} ?>
<?php } ?>
</table>
<br/>

<?php
if($iAmOwner == '1' && $finished == '1') {
	echo "<h2><u>Waiting for payment to complete transaction</u></h2>";
$note = "If you deny the auction, your item will be returned to you and you'll be billed 5000 bugs for your listing."; ?>
<?php } 
if($iAmOwner == '0' && $finished == '0') { ?>
<input style="width:100%;" type="submit" name="bid" value="Place Bid">
<?php } else if($iAmOwner == '0' && $finished == '1') { ?>
<input style="width:100%;" type="submit" name="complete" value="Pay and Recieve Item">
<?php } ?>
</form>
<font color="red"><?php echo "</br>".$message; ?></font>
<br/><br/>
</center>
<?php if($note) { ?><p><font size=2><b>Note:</b> <?= $note ?></font></p><?php } ?>
	</div>
	</div>
    <div style="clear:left;"></div>
	</div>
	
	</div>
	<?php if(empty($username)) { ?><div style="display: block; padding: 10px; font-family: Helvetica, Arial, sans-serif; background: #00b3ed; color: #fff;" class="bottom">Welcome, guest! <a href='/market/login.php'>Click here</a> to login to the auction house!</div><?php } else { include("footer.php"); }?>
</body>
</html>