<!DOCTYPE HTML>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
	<title>Chobots Market</title>
<?php
session_start();
include("header.php");

$itemId = $_GET['item'];
$checkOwner = mysqli_num_rows($mysqli->query("SELECT `id` FROM `StuffItem` WHERE `id` = '".$itemId."' AND `gameChar_id` = '".$getAuctionBugs['gameChar_id']."' LIMIT 1"));

if(empty($_SESSION['market']['username'])) {
	$ref = $_SERVER['REQUEST_URI'];
	header("Location: ./login?r=$ref");
}

if($checkOwner != 1) {
	header("Location: ./shelves");
}

$theItem = mysqli_fetch_array($mysqli->query("SELECT `type_id`,`color`,`gameChar_id` FROM `StuffItem` WHERE `id` = '".$itemId."'"));
$itemInfo = mysqli_fetch_array($mysqli->query("SELECT `fileName`,CAST(`premium` AS unsigned integer) AS `premium`,`shop_id` FROM `StuffType` WHERE `id` = '".$theItem['type_id']."'"));
$shop = mysqli_fetch_array($mysqli->query("SELECT `name` FROM `Shop` WHERE `id` = '".$itemInfo['shop_id']."'"));
if(isset($_POST['create'])) {
	$getNum = mysqli_num_rows($mysqli->query("SELECT `id` FROM `MarketSales` WHERE `createdBy` = '".$username."'"));
	if($getNum <= '4') {
		if($shop['name'] != "agentsShop") {
			if($shop['name'] != "shopItems") {
				$dateNow = strtotime(date('Y-m-d H:i:s'));
				$bid = $mysqli->real_escape_string($_POST['bid']);
				$endDate = $mysqli->real_escape_string($_POST['endDate']);
				$mysqli->query("INSERT INTO `MarketSales` (`active`,`itemId`,`createdBy`,`currentBid`,`startingBid`,`endDate`,`createdDate`) VALUES ('true','".$itemId."','".$username."','".$bid."','".$bid."','".$endDate."','".$dateNow."')");
				$mysqli->query("UPDATE `StuffItem` SET `gameChar_id` = '0' WHERE `id` = '".$itemId."'");
				echo "<script>window.close();</script>";
			} else { $message = "You cannot put items bought with Emeralds in the Market"; }
		} else { $message = "You cannot put items from the Agents shop in the Market"; }
	} else { $message = "You can only have 4 auctions in the Market at a time"; }
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
	<li><span><span><a href="/shop/index"><span><span>Shop</span></span></a></li>
	<li><span><span><a href="http://blog.<?php echo $url; ?>/"><span><span>Community</span></span></a></li>
	<li><span><span><a href="/management"><span><span>Management</span></span></a></li>
    <li class="current"><span><span><a href="/market/"><span><span>Market</span></span></a></li>
	<li class="play"><a href="/play"></a></li>
	  	</ul>
	</div> 
    <div class="logo"><a href="http://<?= $url ?>/"><img src="/images/logo_inner.png" alt="Chobots" /></a></div> 
    <div class="inner">
	<h1>Chobots Market</h1>
	<center>
	<?php $getExists = mysqli_num_rows($mysqli->query("SELECT `id` FROM `MarketSales` WHERE `itemId` = '".$itemId."' AND `active` = 'true'")); if($getExists >= '1') { $message = "This item is already in the market!"; } else { ?>
<form method="post" style="display: inline-block;">
<table width="100%" cellpadding="5" cellspacing="0">
<tr>
<td align="right"><b>Price</b></td>
<td>
<input name="bid" min="0" value="1000" type="number">
<div style="width: 15px; height: 15px; display: inline-block;background: url(http://<?= $url ?>/images/bug-coin.png) no-repeat; position: relative; top: 2px;"></div>
</td>
</tr>

<tr>
<td align="right"><b>End Date</b></td>
<td>
<select name="endDate" style="width: 100%">
<option value="<?= $date = strtotime(date('Y-m-d H:i:s', strtotime('+1 day'))); ?>"><?php echo date("M jS", strtotime('+1 day')); ?> (Tomorrow)</option>
<option value="<?= $date = strtotime(date('Y-m-d H:i:s', strtotime('+2 day'))); ?>"><?php echo date("M jS", strtotime('+2 day')); ?> (2 Days)</option>
</select>
</td>
</tr>

<tr>
<td align="right"><b>Item</b></td>
<td>
<embed src='/game/ItemViewer.swf?name=<?= $itemInfo['fileName'] ?>&color=0x<?= dechex($theItem['color']) ?>&citizen=<?= $itemInfo['premium'] ?>' wmode='transparent' width='100' height='100'></embed>
</br>
<input type="submit" name="create" value="Add item to the Market">
</td>
</tr>
</table>
</form>
<?php } ?>
<?php if($note) { ?><p><font size=2><b>Note:</b> <?= $note ?></font></p><?php } ?>
<center><font color="red"><?php echo "</br>".$message; ?></font></center>
	</div>
	</div>
    <div style="clear:left;"></div>
	</div>
	
	<div class="decor all">&nbsp;</div>
	</div>
	<?php if($username) { include("footer.php"); } else { ?><div style="display: block; padding: 10px; font-family: Helvetica, Arial, sans-serif; background: #00b3ed; color: #fff;" class="bottom">Welcome, guest! <a href='./login.php'>Click here</a> to login to the auction house!</div><?php } ?>
</body>
</html>