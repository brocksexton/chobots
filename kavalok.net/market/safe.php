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
	<script type="text/javascript">
function addCode(key){
	var code = document.forms[0].code;
	if(code.value.length < 4){
		code.value = code.value + key;
	}
	if(code.value.length == 4){
		document.getElementById("message").style.display = "block";
		setTimeout(submitForm,1000);	
	}
}

function removeCode(){
	var code = document.forms[0].code;
	if(code.value.length >= 1){
		code.value = code.value.slice(0, -1);
	}
}


function submitForm(){
	document.forms[0].submit();
}

function emptyCode(){
	document.forms[0].code.value = "";
}
</script>
<style>

#keypad {margin:auto; margin-top:20px;}

#keypad tr td {
	vertical-align:middle; 
	text-align:center; 
	border:1px solid #000000; 
	font-size:18px; 
	font-weight:bold; 
	width:40px; 
	height:30px; 
	cursor:pointer; 
	background-color:#666666; 
	color:#CCCCCC;}
#keypad tr td:hover {background-color:#999999; color:#0000FF;}

.display {
	width:130px; 
	margin:10px auto auto auto; 
	background-color:#000000; 
	color:#0000FF; 
	font-size:18px; 
	border:1px solid #999999;
}
#message {
	text-align:center; 
	color:#0000FF; 
	font-size:14px; 
	font-weight:bold; 
	display:none;
}
</style>
	
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
	<h1>Crack the Vault</h1>
	<center>
	
	<?php
		$itemDate = date('Y-m-d H:i:s');
		
		//$_POST['code'] = 1234;
		if(isset($_POST["code"])) {
			$number = $mysqli->real_escape_string($_POST['code']);
			$exists = $mysqli->query("SELECT `id` FROM `Vault` WHERE `active` = '1' AND `pin1` = '".substr($number, -4, 1)."' AND `pin2` = '".substr($number, -3, 1)."' AND `pin3` = '".substr($number, -2, 1)."' AND `pin4` = '".substr($number, -1, 1)."'");
			$pins = mysqli_fetch_array($exists);
			if(mysqli_num_rows($exists) == 1) { //WINNER
				echo "<h2>You've won a prize! <a href='./prizes'>Click here to claim your prize</a></h2>";
				$mysqli->query("UPDATE `Vault` SET `active` = '0',`winner` = '".$_SESSION['market']['username']."' WHERE `id` = '".$pins['id']."'");
			} else { // NOT WINNER
				echo "<h2><font color='red'>Wrong code, try again</font></h2>"; 
				$date = date('Y-m-d');
				$code = substr($number, -4, 1).substr($number, -3, 1).substr($number, -2, 1).substr($number, -1, 1);
				$mysqli->query("INSERT INTO `Vault_Tries` (`gameChar_id`,`code`,`date`) VALUES ('".$getAuctionBugs['gameChar_id']."','".$code."','".$date."')");
			}
		}
		$getDate = $mysqli->query("SELECT `id` FROM `Vault_Tries` WHERE `gameChar_id` = '".$getAuctionBugs['gameChar_id']."' AND `date` = CURDATE()");
		$turns = mysqli_num_rows($getDate);
	?>
	
	<p><font color="red">
		<?php
			echo "You have "; echo 3-$turns." turns left!";
		?>
	</font></p>
	<?php
		$getVaults = mysqli_num_rows($mysqli->query("SELECT `id` FROM `Vault` WHERE `winner` IS NULL AND `active` = '1'"));
		if($turns < 3 && $getVaults > 0) {
	?>
	<p>Go ahead, give it your best shot</p>

	<form method="post"> 
		<table id="keypad" cellpadding="5" cellspacing="3">
			<tr>
				<td onclick="addCode('1');">1</td>
				<td onclick="addCode('2');">2</td>
				<td onclick="addCode('3');">3</td>
			</tr>
			<tr>
				<td onclick="addCode('4');">4</td>
				<td onclick="addCode('5');">5</td>
				<td onclick="addCode('6');">6</td>
			</tr>
			<tr>
				<td onclick="addCode('7');">7</td>
				<td onclick="addCode('8');">8</td>
				<td onclick="addCode('9');">9</td>
			</tr>
			<tr>
				<td onclick=""></td>
				<td onclick="addCode('0');">0</td>
				<td onclick="removeCode()"><</td>
			</tr>
		</table>
		
		<input type="text" name="code" value="" maxlength="4" class="display" readonly="readonly" />
		<p id="message">Cracking Vault...</p>
		
	</form>
		
		
	<?php
	} else if($getVaults == 0) {
		echo "<p>There're no prizes at the minute. Please try again later</p>";
	} else {
		echo "<p>Sorry you're out of turns, try again tomorrow!</p>";
	} 
	?>
	<hr>
		<h2>People who have won!</h2>
	<table style="width:100%;" border="1px">
		<tr>
			<th>User</th>
			<th>Prize</th>
			<th>Code</th>
		</tr>
		
		<?php $getWinners = $mysqli->query("SELECT `winner`,`prizeType`,`prize`,`pin1`,`pin2`,`pin3`,`pin4` FROM `Vault` WHERE `winner` IS NOT NULL");
		while($row = mysqli_fetch_array($getWinners)) {
		?>
		<tr>
			<td><center><?= ucfirst($row['winner']) ?></center></td>
			<td><center>
			<?php 
				if($row["prizeType"] == "Item") {
					$itemInfo2 = mysqli_fetch_array($mysqli->query("SELECT `fileName`,`premium` FROM `StuffType` WHERE `id` = '".$row['prize']."'"));
					echo "<div><embed src='/game/ItemViewer.swf?name=".$itemInfo2['fileName']."&color=0xFFFFFF' quality=autolow wmode='transparent' width='100' height='100'></embed></div>";
				} else if($row["prizeType"] == "Bugs") {
					echo "<div><embed src='/game/ItemViewer.swf?bugs=".$row['prize']."' quality=autolow wmode='transparent' width='100' height='100'></embed></div>";
				} else if($row["prizeType"] == "Emeralds") {
					echo "<div><embed src='/game/ItemViewer.swf?emeralds=".$row['prize']."' quality=autolow wmode='transparent' width='100' height='100'></embed></div>";
				} else {
					echo "<div><embed src='/game/ItemViewer.swf?days=".$row['prize']."' quality=autolow wmode='transparent' width='100' height='100'></embed></div>";
				}
			?></center></td>
			<td><center><?= $row["pin1"].$row["pin2"].$row["pin3"].$row["pin4"] ?></center></td>
		</tr>
		<?php } ?>
	</table>
	</center>
	</div>
	<div class="blockInfo">
		<center>
		<h2>Prizes!</h2>
			<table style="width:100%;">
				<tr>
				<?php $getPrizes = $mysqli->query("SELECT `prize`,`prizeType` FROM `Vault` WHERE `active` = 1"); 
				while($row1 = mysqli_fetch_array($getPrizes)) {
					if($row1["prizeType"] == "Item") {
						$itemInfo = mysqli_fetch_array($mysqli->query("SELECT `fileName`,`premium` FROM `StuffType` WHERE `id` = '".$row1['prize']."'"));
						echo "<div><embed src='/game/ItemViewer.swf?name=".$itemInfo['fileName']."&color=0xFFFFFF' quality=autolow wmode='transparent' width='100' height='100'></embed></div>";
					} else if($row1["prizeType"] == "Bugs") {
						echo "<div><embed src='/game/ItemViewer.swf?bugs=".$row1['prize']."' quality=autolow wmode='transparent' width='100' height='100'></embed></div>";
					} else if($row1["prizeType"] == "Emeralds") {
						echo "<div><embed src='/game/ItemViewer.swf?emeralds=".$row1['prize']."' quality=autolow wmode='transparent' width='100' height='100'></embed></div>";
					} else {
						echo "<div><embed src='/game/ItemViewer.swf?days=".$row1['prize']."' quality=autolow wmode='transparent' width='100' height='100'></embed></div>";
					}
				}
				?>
				</tr>
			</table>
			<?php $unclaimed = mysqli_num_rows($mysqli->query("SELECT `id` FROM `Vault` WHERE `winner` = '".$_SESSION['market']['username']."' AND `claimed` = 'false'"));
			if($unclaimed >= 1) { echo "<h2><font color='red'><a href='./prizes'>You have unclaimed prizes</font></font></h2>"; }
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