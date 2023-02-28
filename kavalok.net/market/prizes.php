<!DOCTYPE HTML>
<?php
session_start();
include("header.php");
if(empty($_SESSION['market']['username'])) {
	$ref = $_SERVER['REQUEST_URI'];
	header("Location: ./login?r=$ref");
}
?>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
	<title>Chobots Market</title>
<script type="text/javascript" src="/management/jscolor/jscolor.js"></script>
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
	<div class="present_frame">
	<div style="clear:both;"></div></div>
	<div class="price_check">
	<div class="contactForm">
	<h1>Claim your prize!</h1>
	<center>

<?php
$itemDate = date('Y-m-d H:i:s');
if(isset($_POST["claim"])) {
	$getItemInfo = mysqli_fetch_array($mysqli->query("SELECT `id`,`claimed`,`prizeType`,`prize` FROM `Vault` WHERE `winner` = '".$_SESSION['market']['username']."' AND `claimed` = 'false' AND `id` = '".$_POST['id']."'"));
	
	if($getItemInfo['claimed'] == "false") {
		$mysqli->query("UPDATE `Vault` SET `claimed` = 'true' WHERE `id` = '".$_POST['id']."'");
		if($getItemInfo['prizeType'] == "Item") {	
			$getColorInfo = mysqli_fetch_array($mysqli->query("SELECT CAST(`hasColor` AS unsigned integer) AS `hasColor` FROM `StuffType` WHERE `id` = '".$getItemInfo['prize']."'"));
			if($getColorInfo["hasColor"] == 1) {
				$color = hexdec($_POST['color']);
			} else {
				$color = null;
			}
			$mysqli->query("INSERT INTO `StuffItem` (used, type_id, color, gameChar_id, created) VALUES (b'0', '".$getItemInfo['prize']."', '".$color."', '".$getAuctionBugs['gameChar_id']."', '".$itemDate."')");
		} else if($getItemInfo['prizeType'] == "Bugs") {
			$mysqli->query("UPDATE `GameChar` SET `money` = money + '".$getItemInfo['prize']."' WHERE `id` = '".$getAuctionBugs['gameChar_id']."'");
		} else if($getItemInfo['prizeType'] == "Emeralds") {
			$mysqli->query("UPDATE `GameChar` SET `emeralds` = emeralds + '".$getItemInfo['prize']."' WHERE `id` = '".$getAuctionBugs['gameChar_id']."'");
		} else if($getItemInfo['prizeType'] == "Citizen") {
			$exirationDate = mysqli_fetch_array($mysqli->query("SELECT `citizenExpirationDate` FROM `User` WHERE `gameChar_id` = '".$getAuctionBugs['gameChar_id']."'"));
			$expirationDate = $exirationDate['citizenExpirationDate'];
			if(($expirationDate == '') || (strtotime($expirationDate) <= strtotime($itemDate))) {
				$time = strtotime($itemDate." +".$getItemInfo['prize']." days");
			} else {
				$time = strtotime($expirationDate." +".$getItemInfo['prize']." days");
			}
			$citizenend = date('Y-m-d  H:i:s', $time);
			$mysqli->query("UPDATE `User` SET `citizenExpirationDate` = '".$citizenend."' WHERE `gameChar_id` = '".$getAuctionBugs['gameChar_id']."'");
		}
	}
}

$getPrizes = $mysqli->query("SELECT `id`,`prize`,`prizeType` FROM `Vault` WHERE `winner` = '".$_SESSION['market']['username']."' AND `claimed` = 'false'");
if(mysqli_num_rows($getPrizes) != 0) {
while($row = mysqli_fetch_array($getPrizes)) {
	if($row['prizeType'] == 'Item') {
		$getColorInfo = mysqli_fetch_array($mysqli->query("SELECT CAST(`hasColor` AS unsigned integer) AS `hasColor`,`fileName` FROM `StuffType` WHERE `id` = '".$row['prize']."'"));
		echo "<form method='post'>";
		echo "<input hidden readonly style='display:none;' name='id' value='".$row['id']."'>";
		if($getColorInfo['hasColor'] == 1) {
			echo "<p>Please choose a color</p>";
			echo "<script>jscolor.init();</script>";
			echo "<input style='width:90px' class='color' name='color'/>";
		}
		echo "<div><embed src='/game/ItemViewer.swf?name=".$getColorInfo['fileName']."' quality=autolow wmode='transparent' width='100' height='100'></embed></div>";
		echo "<input type='submit' value='Claim' name='claim'/>";
		echo "</form>";
		echo "<hr/>";
	} else if($row['prizeType'] == 'Bugs') {
		echo "<form method='post'>";
		echo "<input hidden readonly name='id' style='display:none;' value='".$row['id']."'>";
		echo "<div><embed src='/game/ItemViewer.swf?bugs=".$row['prize']."' quality=autolow wmode='transparent' width='100' height='100'></embed></div>";
		echo "<input type='submit' value='Claim' name='claim'/>";
		echo "</form>";
		echo "<hr/>";
	} else if($row['prizeType'] == 'Emeralds') {
		echo "<form method='post'>";
		echo "<input hidden readonly name='id' style='display:none;' value='".$row['id']."'>";
		echo "<div><embed src='/game/ItemViewer.swf?emeralds=".$row['prize']."' quality=autolow wmode='transparent' width='100' height='100'></embed></div>";
		echo "<input type='submit' value='Claim' name='claim'/>";
		echo "</form>";
		echo "<hr/>";
	} else if($row['prizeType'] == 'Citizen') {
		echo "<form method='post'>";
		echo "<input hidden readonly name='id' style='display:none;' value='".$row['id']."'>";
		echo "<div><embed src='/game/ItemViewer.swf?days=".$row['prize']."&color=0xFFFFFF' quality=autolow wmode='transparent' width='100' height='100'></embed></div>";
		echo "<input type='submit' value='Claim' name='claim'/>";
		echo "</form>";
		echo "<hr/>";
	}
}
} else {
	echo "<h2><font color='red'>You have no prizes, go try crack the vault</font></h2>";
}
?>
</center>
	</div>
	</div>
	
	</div>
	</div>
    <div style="clear:left;"></div>
	</div>
	
	</div>
	<?php if(empty($username)) { ?><div style="display: block; padding: 10px; font-family: Helvetica, Arial, sans-serif; background: #00b3ed; color: #fff;" class="bottom">Welcome, guest! <a href='/market/login.php'>Click here</a> to login to the auction house!</div><?php } else { include("footer.php"); }?>
</body>
</html>