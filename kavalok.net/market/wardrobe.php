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
	.shelf { width: 900px; height: 153px; background: url(/images/x1shelf-whole.png) no-repeat; margin: 0px auto; margin-top: 70px; display: block; padding-left: 55px; }
	</style>
	<script src="http://ajax.googleapis.com/ajax/libs/jquery/2.0.0/jquery.min.js"></script>
	<script src="http://ajax.googleapis.com/ajax/libs/jqueryui/1.10.2/jquery-ui.min.js"></script>
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
	<?php if($error) { ?><h2><center><?= $error ?></center></h2><?php } ?>
	<div id="shelves">
	<center>
</center>
<!--	<a href="FAQ.php"><font color=black><b>FAQ</b></font></a>-->
<br/>
</div></div><div id="shelves">
<div class='shelf'>
<?php 

$first = $mysqli->query("SELECT `id`,`color`,`type_id`,CAST(`used` AS unsigned integer) AS `used` FROM `StuffItem` WHERE `gameChar_id` = '".$getAuctionBugs['gameChar_id']."'"); 
$num = 0;

while($row = mysqli_fetch_array($first)) {

$itemInfo = mysqli_fetch_array($mysqli->query("SELECT `shop_id`,`fileName`,CAST(`premium` AS unsigned integer) AS `premium`,`type` FROM `StuffType` WHERE `id` = '".$row['type_id']."'"));
if($itemInfo['type'] == "C" && $row['used'] == 0 && $itemInfo['shop_id'] != '330' && $itemInfo['shop_id'] != '32') {

$marketItem = "<div class='item'><embed src='/game/ItemViewer.swf?itemId=".$row['id']."&name=".$itemInfo['fileName']."&color=0x".dechex($row['color'])."&citizen=".$itemInfo['premium']."' quality=autolow wmode='transparent' width='100' height='100'></embed></div>";

	$num++;
	echo $marketItem;
	if ($num % 4 != 0) { $shelfNeeded = false; } else { $shelfNeeded = true; }
	if($shelfNeeded) { echo "</div><div class='shelf'>"; } 
}
} ?>
</div>
<?php 
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