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

<style>a {color:white;text-decoration:none;} div.bottom {position:fixed;bottom:0px;left:0px;right:0px;}</style>

	<style type="text/css">
	body { font-family: Helvetica, Arial, sans-serif; }
	#shelves { width: 900px; margin: 0px auto; }
	.item { width: 100px; height: 100px; display: inline-block; position: relative; top: -50px; margin: 25px; margin-left: 60px; }
	.shelf { width: 900px; height: 153px; background: url(/images/x1shelf-whole.png) no-repeat; margin: 0px auto; margin-top: 50px; display: block; padding-left: 55px; }
	</style>
	<script src="http://ajax.googleapis.com/ajax/libs/jquery/2.0.0/jquery.min.js"></script>
	<script src="http://ajax.googleapis.com/ajax/libs/jqueryui/1.10.2/jquery-ui.min.js"></script>
	<script type="text/javascript" charset="utf-8">
	$(document).ready(function() {		
		$(".tag").mouseenter(function() {
			if (navigator.userAgent.search("Firefox") >= 0) { // FIREFOX
				$(this).append("<a href='bid?auction=" + $(this).attr('id') + "'><div class='bid' style='width: 100px; height: 45px; "+
				"border-radius: 5px; background: green; color: #fff; font-weight: bold; margin: 0px auto; font-size: 20px; position: absolute; top: 3px; "+
				"text-align: center;  display: inline-block; line-height: 210%;'>VIEW</div></a>");}
			else if (navigator.userAgent.search("Chrome") >= 0) { // CHROME
				$(this).append("<a href='bid?auction=" + $(this).attr('id') + "'><div class='bid' style='width: 100px; height: 40px; "+
				"border-radius: 5px; background: green; color: #fff; font-weight: bold; margin: 0px auto; font-size: 20px; position: absolute; top: 3px; "+
				"text-align: center;  display: inline-block; line-height: 210%;'>VIEW</div></a>");}
			else if (navigator.userAgent.search("Safari") >= 0 && navigator.userAgent.search("Chrome") < 0) { // SAFARI
				$(this).append("<a href='bid?auction=" + $(this).attr('id') + "'><div class='bid' style='width: 100px; height: 40px; "+
				"border-radius: 5px; background: green; color: #fff; font-weight: bold; margin: 0px auto; font-size: 20px; position: absolute; top: 3px; "+
				"text-align: center;  display: inline-block; line-height: 210%;'>VIEW</div></a>");}
			else if (navigator.userAgent.search("Opera") >= 0) { // OPERA
				$(this).append("<a href='bid?auction=" + $(this).attr('id') + "'><div class='bid' style='width: 100px; height: 44px; "+
				"border-radius: 5px; background: green; color: #fff; font-weight: bold; margin: 0px auto; font-size: 20px; position: absolute; top: 3px; "+
				"text-align: center;  display: inline-block; line-height: 210%;'>VIEW</div></a>");}
			else if (navigator.userAgent.search("MSIE") >= 0) { // INTERNET EXPLORER
				$(this).append("<a href='bid?auction=" + $(this).attr('id') + "'><div class='bid' style='width: 100px; height: 45px; "+
				"border-radius: 5px; background: green; color: #fff; font-weight: bold; margin: 0px auto; font-size: 20px; position: absolute; top: 3px; "+
				"text-align: center;  display: inline-block; line-height: 210%;'>VIEW</div></a>");}

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
	
</div>
<h2>My Auctions</h2></br></br>
<div id="shelves">

<?php 
$date = date('Y-m-d H:i:s');
$strDate = strtotime($date);

$myItems = $mysqli->query("SELECT * FROM `MarketSales` WHERE `active` = 'true' AND `createdBy` = '".$username."' ORDER BY `endDate` ASC LIMIT 4");

if(mysqli_num_rows($myItems) == 0) {
	echo "<center><h1>None</h1></center>";
} else {

$num = 0;
while($row = mysqli_fetch_array($myItems)) {
if($num == 0){
	echo "<div class='shelf'>";
}
$finishTime = $row['endDate'];
$seconds = $finishTime - $strDate;

$days    = floor($seconds / 86400);
$hours   = floor(($seconds - ($days * 86400)) / 3600);
$minutes = floor(($seconds - ($days * 86400) - ($hours * 3600))/60);
$seconds = floor(($seconds - ($days * 86400) - ($hours * 3600) - ($minutes*60)));

$itemColor = mysqli_fetch_array($mysqli->query("SELECT `color`,`type_id` FROM `StuffItem` WHERE `id` = '".$row['itemId']."'"));
$itemInfo = mysqli_fetch_array($mysqli->query("SELECT `fileName`,CAST(`premium` AS unsigned integer) AS `premium` FROM `StuffType` WHERE `id` = '".$itemColor['type_id']."'"));

if($hours == 0) {
	$marketDate = $minutes." mins, ".$seconds." secs";
} else if($days >= 1) {
	$marketDate = $days." day, ".$hours." hr, ".$minutes." min";
} else {
	$marketDate = $hours." hr, ".$minutes." mins";
}

if($strDate > $finishTime) {
	$marketDate = "Finished";
	$boxColor = "FF9933"; // Finished
} else {
	$boxColor = "B9F2B5"; // Not finished
}
$marketItem = "<div class='item'><embed src='/game/ItemViewer.swf?name=".$itemInfo['fileName']."&color=0x".dechex($itemColor['color'])."&citizen=".$itemInfo['premium']."' wmode='transparent' width='100' height='100'></embed><div class='tag' id='".$row['id']."' style='width: 100px; min-height: 40px; background: #".$boxColor."; color: #000; text-align: center;  box-shadow: 0px 2px 0px #ddd; padding: 3px; border-radius: 5px;position: relative; display: inline-block; top: -145px; text-align: center; font-size: 10px;'><b>".$row['currentBid']." <div style='width: 15px; height: 15px; display: inline-block;background: url(http://".$url."/images/bug-coin.png) no-repeat; position: relative; top: 4px;'></div></b><br/>".$row['bidNum']." bid<br/><font color='red'>".$marketDate."</font></div></div>";

	$num++;
	echo $marketItem;
	
	
} 
}?>
</div>
<h2>Items I'm winning</h2></br></br>
<?php
$num = 0;
$wonItems = $mysqli->query("SELECT * FROM `MarketSales` WHERE `active` = 'true' AND `buyer` = '".$username."' ORDER BY `endDate` ASC LIMIT 4");

if(mysqli_num_rows($wonItems) == 0) {
	echo "<center><h1>None</h1></center>";
} else {

while($row = mysqli_fetch_array($wonItems)) {
if($num == 0){
	echo "<div class='shelf'>";
}
$num++;
$finishTime = $row['endDate'];
$seconds = $finishTime - $strDate;

$days    = floor($seconds / 86400);
$hours   = floor(($seconds - ($days * 86400)) / 3600);
$minutes = floor(($seconds - ($days * 86400) - ($hours * 3600))/60);
$seconds = floor(($seconds - ($days * 86400) - ($hours * 3600) - ($minutes*60)));

$itemColor = mysqli_fetch_array($mysqli->query("SELECT `color`,`type_id` FROM `StuffItem` WHERE `id` = '".$row['itemId']."'"));
$itemInfo = mysqli_fetch_array($mysqli->query("SELECT `fileName`,CAST(`premium` AS unsigned integer) AS `premium` FROM `StuffType` WHERE `id` = '".$itemColor['type_id']."'"));

if($hours == 0) {
	$marketDate = $minutes." mins, ".$seconds." secs";
} else if($days >= 1) {
	$marketDate = $days." day, ".$hours." hr, ".$minutes." min";
} else {
	$marketDate = $hours." hr, ".$minutes." mins";
}
if($strDate > $finishTime) {
	$marketDate = "Finished / You won!";
}

$boxColor = "B9F2B5"; // Won Bid
$marketItem = "<div class='item'><embed src='/game/ItemViewer.swf?name=".$itemInfo['fileName']."&color=0x".dechex($itemColor['color'])."&citizen=".$itemInfo['premium']."' wmode='transparent' width='100' height='100'></embed><div class='tag' id='".$row['id']."' style='width: 100px; min-height: 40px; background: #".$boxColor."; color: #000; text-align: center;  box-shadow: 0px 2px 0px #ddd; padding: 3px; border-radius: 5px;position: relative; display: inline-block; top: -145px; text-align: center; font-size: 10px;'><b>".$row['currentBid']." <div style='width: 15px; height: 15px; display: inline-block;background: url(http://".$url."/images/bug-coin.png) no-repeat; position: relative; top: 4px;'></div></b><br/>".$row['bidNum']." bid<br/><font color='red'>".$marketDate."</font></div></div>";
	
	if($num <= 4) { echo $marketItem; }
}
echo "</div>";
} ?>

<br/><br/><br/><br/>
	</div>
    <div style="clear:left;"></div>
	</div>
	<div class="decor all">&nbsp;</div>
	</div>
	<?php if(empty($username)) { ?><div style="display: block; padding: 10px; font-family: Helvetica, Arial, sans-serif; background: #00b3ed; color: #fff;" class="bottom">Welcome, guest! <a href='/market/login.php'>Click here</a> to login to the auction house!</div><?php } else { include("footer.php"); }?>
	</body>
</html>