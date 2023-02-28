<!DOCTYPE HTML>
<?php
session_start();
include("header.php");
?>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
	<title>Chobots Market</title>

<style>a {color:white;text-decoration:none;} div.bottom {position:fixed;bottom:0px;left:0px;right:0px;}</style>

	<style type="text/css">
	body { font-family: Helvetica, Arial, sans-serif; }
	#shelves { width: 900px; margin: 0px auto; }
	.item { width: 100px; height: 100px; display: inline-block; position: relative; top: -50px; margin: 25px; margin-left: 60px; }
	.shelf { width: 900px; height: 153px; background: url(/images/x1shelf-whole.png) no-repeat; margin: 0px auto; margin-top: 70px; display: block; padding-left: 55px; }
	</style>
	<script src="http://ajax.googleapis.com/ajax/libs/jquery/2.0.0/jquery.min.js"></script>
	<script src="http://ajax.googleapis.com/ajax/libs/jqueryui/1.10.2/jquery-ui.min.js"></script>
	<script type="text/javascript" charset="utf-8">
	$(document).ready(function() {		
		$(".tag").mouseenter(function() {
			if (navigator.userAgent.search("Firefox") >= 0) { // FIREFOX
				$(this).append("<a href='bid?auction=" + $(this).attr('id') + "'><div class='bid' style='width: 100px; height: 45px; "+
				"border-radius: 5px; background: green; color: #fff; font-weight: bold; margin: 0px auto; font-size: 20px; position: absolute; top: 3px; "+
				"text-align: center;  display: inline-block; line-height: 210%;'>BID</div></a>");}
			else if (navigator.userAgent.search("Chrome") >= 0) { // CHROME
				$(this).append("<a href='bid?auction=" + $(this).attr('id') + "'><div class='bid' style='width: 100px; height: 40px; "+
				"border-radius: 5px; background: green; color: #fff; font-weight: bold; margin: 0px auto; font-size: 20px; position: absolute; top: 3px; "+
				"text-align: center;  display: inline-block; line-height: 210%;'>BID</div></a>");}
			else if (navigator.userAgent.search("Safari") >= 0 && navigator.userAgent.search("Chrome") < 0) { // SAFARI
				$(this).append("<a href='bid?auction=" + $(this).attr('id') + "'><div class='bid' style='width: 100px; height: 40px; "+
				"border-radius: 5px; background: green; color: #fff; font-weight: bold; margin: 0px auto; font-size: 20px; position: absolute; top: 3px; "+
				"text-align: center;  display: inline-block; line-height: 210%;'>BID</div></a>");}
			else if (navigator.userAgent.search("Opera") >= 0) { // OPERA
				$(this).append("<a href='bid?auction=" + $(this).attr('id') + "'><div class='bid' style='width: 100px; height: 44px; "+
				"border-radius: 5px; background: green; color: #fff; font-weight: bold; margin: 0px auto; font-size: 20px; position: absolute; top: 3px; "+
				"text-align: center;  display: inline-block; line-height: 210%;'>BID</div></a>");}
			else if (navigator.userAgent.search("MSIE") >= 0) { // INTERNET EXPLORER
				$(this).append("<a href='bid?auction=" + $(this).attr('id') + "'><div class='bid' style='width: 100px; height: 45px; "+
				"border-radius: 5px; background: green; color: #fff; font-weight: bold; margin: 0px auto; font-size: 20px; position: absolute; top: 3px; "+
				"text-align: center;  display: inline-block; line-height: 210%;'>BID</div></a>");}

			$(this).find(".bid").hide().fadeIn(250);
		});
		$(".tag").mouseleave(function() {
			$(this).find(".bid").html("").fadeOut(150);	
		});
	});
	</script>
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
	<h1>Chobots Market</h1>
	
	<?php 
	if($GET['v'] == '1') { 
		$error = "<font color='red'><b>Error; </b>This item doesn't exist on the market</font>"; 
	} else if($_GET['v'] == '2') {
		$error = "Removed item from the Market. The item has been returned to your wardrobe and 5000 bugs has been deducted from your Market Balance.";
	}
	if($error) { ?><h2><center><?= $error ?></center></h2><?php } ?>
	<div id="shelves">
	<center>
	<form style="display: inline-block;" method="GET">
		<select name="sort_by" id="sort_by" style="width:145.5px">
			<option disabled selected>Filters</option>
			<optgroup label="Time">
				<option value="recent">Most recent</option>
				<option value="oldest">Oldest</option>
				<option value="expire_soon">Ending soon</option>
			</optgroup>
			<optgroup label="Price">
				<option value="least_expensive">Least expensive</option>
				<option value="most_expensive">Most expensive</option>
			</optgroup>
			<optgroup label="Bids">
				<option value="few_bids">Fewest bids</option>
				<option value="most_bids">Most bids</option>
			</optgroup>
		</select><input type="submit" value="Go">	
	</form>&nbsp;&nbsp;&nbsp;
	<form style="display: inline-block;" method="GET">
		<input type="text" name="username" placeHolder="Seller Username" style="width:140px"><input type="submit" value="Go">
	</form>&nbsp;&nbsp;&nbsp;
	<form style="display: inline-block;;" method="GET">
		<input type="text" name="item" placeHolder="Item Name" style="width:140px"><input type="submit" value="Go">
	</form>
</center>
<!--	<a href="FAQ.php"><font color=black><b>FAQ</b></font></a>-->
<br/>
</div></div><div id="shelves">

<?php 
$date = date('Y-m-d H:i:s');
$strDate = strtotime($date);
if($_GET['page']) {
	$page = $_GET['page'];
	$limit = 12 * $page - 12;
} else {
	$page = 1;
	$limit = 0;
}

$sort = $_GET['sort_by'];
if($sort == 'recent') {
	$orderBy = "`createdDate` ASC";
} else if($sort == 'oldest') {
	$orderBy = "`createdDate` DESC";
} else if($sort == 'expire_soon') {
	$orderBy = "`endDate` ASC";
} else if($sort == 'least_expensive') {
	$orderBy = "`currentBid` ASC";
} else if($sort == 'most_expensive') {
	$orderBy = "`currentBid` DESC";
} else if($sort == 'few_bids') {
	$orderBy = "`bidNum` ASC";
} else if($sort == 'most_bids') {
	$orderBy = "`bidNum` DESC";
} else {
	$orderBy = "`endDate` ASC";
}
$whereBase = "WHERE `active` = 'true' AND `endDate` > '".$strDate."'";
if($_GET['item']) { 
	$getItemInfo = mysqli_fetch_array($mysqli->query("SELECT `id`,`premium` FROM `StuffType` WHERE `fileName` = '".$_GET['item']."'"));
	$where = $whereBase." AND `itemId` = '".$getItemInfo['id']."'";
} else if($_GET['username']) {
	$where = $whereBase." AND `createdBy` = '".strtolower($_GET['username'])."'";
} else {
	$where = $whereBase;
}

$first = $mysqli->query("SELECT * FROM `MarketSales` $where ORDER BY $orderBy LIMIT $limit,12"); 
if(mysqli_num_rows($first) == 0) {
	echo "<center><h1><a href='./'><font color='000000'>None found</font></a></h1></center>";
} else {
	
$num = 0;

while($row = mysqli_fetch_array($first)) {
$finishTime = $row['endDate'];
if($num == 0) {
	echo "<div class='shelf'>";
}
$seconds = $finishTime - $strDate;

$days    = floor($seconds / 86400);
$hours   = floor(($seconds - ($days * 86400)) / 3600);
$minutes = floor(($seconds - ($days * 86400) - ($hours * 3600))/60);
$seconds = floor(($seconds - ($days * 86400) - ($hours * 3600) - ($minutes*60)));

$itemColor = mysqli_fetch_array($mysqli->query("SELECT `color`,`type_id` FROM `StuffItem` WHERE `id` = '".$row['itemId']."'"));
$itemInfo = mysqli_fetch_array($mysqli->query("SELECT `fileName`,CAST(`premium` AS unsigned integer) AS `premium` FROM `StuffType` WHERE `id` = '".$itemColor['type_id']."'"));
$creatorInfo = mysqli_fetch_array($mysqli->query("SELECT `citizenExpirationDate`,`agent` FROM `User` WHERE `login` = '".$row['createdBy']."'"));

if($hours == 0) {
	$marketDate = $minutes." mins, ".$seconds." secs";
} else if($days >= 1) {
	$marketDate = $days." day, ".$hours." hr, ".$minutes." min";
} else {
	$marketDate = $hours." hr, ".$minutes." mins";
}

$expirationDate = strtotime($creatorInfo['citizenExpirationDate']);
if($creatorInfo['agent'] == '1') {
	$boxColor = "94C9FF"; // Agent
} else { //} else if($expirationDate > $strDate) {
	$boxColor = "B9F2B5"; // Citizen
} // else { //DISABLE WHILE CITIZEN IS FREE
	//$boxColor = "F1F1F1"; // Normal player
//}

$marketItem = "<div class='item'><embed src='/game/ItemViewer.swf?name=".$itemInfo['fileName']."&color=0x".dechex($itemColor['color'])."&citizen=".$itemInfo['premium']."' quality=autolow wmode='transparent' width='100' height='100'></embed><div class='tag' id='".$row['id']."' style='width: 100px; min-height: 40px; background: #".$boxColor."; color: #000; text-align: center;  box-shadow: 0px 2px 0px #ddd; padding: 3px; border-radius: 5px;position: relative; display: inline-block; top: -145px; text-align: center; font-size: 10px;'><b>".$row['currentBid']." <div style='width: 15px; height: 15px; display: inline-block;background: url(http://".$url."/images/bug-coin.png) no-repeat; position: relative; top: 4px;'></div></b><br/>".$row['bidNum']." bid<br/><font color='red'>".$marketDate."</font></div></div>";

$num++;
if($num <= 4) { echo $marketItem; }
if($num == 5) { echo "</div><div class='shelf'>"; } 
if($num >= 5 && $num <= 8) { echo $marketItem; }
if($num == 9) { echo "</div><div class='shelf'>"; }
if($num >= 9 && $num <= 12) { echo $marketItem; }
} 
echo "</div>";
}
?>
Page
<?php 
$pageNumbers = mysqli_num_rows($first);
$totalPages = ceil($pageNumbers / 12);
if($totalPages == 0) { $totalPages = 1; }
for ($i=1; $i<=$totalPages; $i++) {
	if($i == $page) { $b = "<b>"; $bb = "</b>"; } else { $b = ""; $bb = ""; }
    echo "<a href='./shelves?page=".$i."'><font color='black'>".$b.$i.$bb."</font></a>  "; 
}
echo "<br/><br/><br/><br/>";
?>
	</div>
	</div>
    <div style="clear:left;"></div>
	</div>
	<div class="decor all">&nbsp;</div>
	</div>
	<?php if($username) { include("footer.php"); } else { ?><div style="display: block; padding: 10px; font-family: Helvetica, Arial, sans-serif; background: #00b3ed; color: #fff;" class="bottom">Welcome, guest! <a href='/market/login.php'>Click here</a> to login to the auction house!</div><?php } ?>
	</body>
</html>