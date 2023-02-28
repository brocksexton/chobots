<!DOCTYPE HTML>
<head>
<?php
session_start();
$username = $_SESSION['market']['username'];
if(empty($_SESSION['market']['username'])) {
	$ref = $_SERVER['REQUEST_URI'];
	header("Location: ./login?r=$ref");
}
$getInfo = mysqli_fetch_array($mysqli->query("SELECT `marketBalance`,`gameChar_id` FROM `User` WHERE `login` = '".$username."'"));
$char = mysqli_fetch_array($mysqli->query("SELECT `money` FROM `GameChar` WHERE `id` = '".$getInfo['gameChar_id']."'"));
if($getInfo['marketBalance'] < 0) {
	$message = "You have a negative amount of bugs in your Market balance. Please top-up to regain access to the Market.";
}

$getMoney = mysqli_fetch_array($mysqli->query("SELECT `money` FROM `GameChar` WHERE `id` = '".$getInfo['gameChar_id']."'"));
$getMoney = $getMoney['money'];
if(isset($_POST['toChobot'])) {
	$amountToChobot = $mysqli->real_escape_string($_POST['amountToChobot']);
	if($getInfo['marketBalance'] >= $amountToChobot) {
		$mysqli->query("UPDATE `GameChar` SET `money` = money + $amountToChobot WHERE `id` = '".$getInfo['gameChar_id']."'");
		$mysqli->query("UPDATE `User` SET `marketBalance` = marketBalance - $amountToChobot WHERE `login` = '".$username."'");
		$message = "We successfully added $amountToChobot bugs to your Chobot from your Market Balance";
	} else { $message = "You dont have enough bugs in your Market Balance to do this"; }
}

if(isset($_POST['toMarket'])) {
	$amountToMarket = round($mysqli->real_escape_string($_POST['amountToMarket']),0);
	if($amountToMarket == "50%") {
		$amountToMarket = floor($getMoney / 2);
	} else if($amountToMarket == "100%") {
		$amountToMarket = $getMoney;
	}

	if($amountToMarket <= $getMoney) {
		$mysqli->query("UPDATE `User` SET `marketBalance` = marketBalance + $amountToMarket WHERE `login` = '".$username."'");
		$mysqli->query("UPDATE `GameChar` SET `money` = money - $amountToMarket WHERE `id` = '".$getInfo['gameChar_id']."'");
		$message = "We successfully added $amountToMarket bugs to your Market Balance from your Chobot";
	} else { $message = "You dont have enough bugs on your Chobot to do this"; }
}
$char = mysqli_fetch_array($mysqli->query("SELECT `money` FROM `GameChar` WHERE `id` = '".$getInfo['gameChar_id']."'"));

?>
	<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
	<title>Chobots Market</title>
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
	<h1>Manage your Balance</h1>
	<table width="100%" cellpadding="5" cellspacing="0">
	<tr>
		<th>Chobots -> Market</th>
		<th>Market -> Chobot</th>
	</tr>
	<tr>
		<td width="50%" align="center">Bugs to add 
		<form style='display:inline;' method="post">
			<select style="width:50%;" name="amountToMarket">
				<option value="1000">1000 Bugs</option>
				<option value="5000">5000 Bugs</option>
				<option value="10000">10000 Bugs</option>
				<option value="50%">Half of my Bugs ( <?= floor($char['money']/2) ?> )</option>
				<option value="100%">All of my Bugs ( <?= $char['money'] ?> )</option>
			</select></br>
			<input name="toMarket" type="submit" style="width:50%;" value="Add funds to Market">
		</form>
		</td>
		<td width="50%" align="center">Bugs to add
			<form method="post" style='display:inline;'>
				<input type="number" style="width:50%;" name="amountToChobot">
				<input name="toChobot" type="submit" style="width:50%;" value="Add funds to Chobot">
			</form>
		</td>
	</tr>
	</table>
	<center><font color="red"><?php echo "</br>".$message."</br></br>"; ?></font></center>
	</div>
	</div>
    <div style="clear:left;"></div>
	</div>
	
	</div>
	<?php include("footer.php"); ?>
</body>
</html>