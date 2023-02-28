<?php
if(isset($_POST['login'])) {
	$username = strtolower($mysqli->real_escape_string($_POST['username']));
	$password = $mysqli->real_escape_string($_POST['password']);
	$checkmod = mysqli_num_rows($mysqli->query("SELECT `id` FROM `User` WHERE `login` = '".$username."' AND `password` = '".$password."' AND `moderator` = '1'"));
	$checkModExists = mysqli_num_rows($mysqli->query("SELECT `login` FROM `bypassMaint` WHERE `login` = '".$username."'"));
	
	if($checkmod == '1') {
		header('Location: /');
		if($checkModExists) {
			$mysqli->query("UPDATE `bypassMaint` SET `ip` = '".$current_ip."' WHERE `login` = '".$username."'");
		} else {
			$mysqli->query("INSERT INTO `bypassMaint` (login,ip) VALUES ('".$username."','".$current_ip."')");
		}
	} else { $message = 'Wrong Details / Dont have access to this'; }
}
?>
<html>
<head>
<title><?php echo $c_url; ?> - Your Family Game!</title>
</head>
<body>
<center>
<style>body{padding:0px;margin:0px;font:15px arial,helvetica,clean,sans-serif;color:#575757;background:#E8F1FB url(http://<?php echo $url; ?>/images/body_bg.gif) repeat-x scroll left -60px;}a{color:#575757}div.settle{background-image:url("http://<?php echo $url; ?>/images/Bauarbeiten.png");background-repeat:no-repeat;background-position:center center;position:relative;}div.settle2{padding-top:400px;padding-bottom:0px;margin:3px;font:15px arial,helvetica,clean,sans-serif;}div.boldIt{font:30px arial,helvetica,clean,sans-serif;}a:link{text-decoration:none}a:visited{text-decoration:none}</style>
<div class="settle">
<img src="http://<?php echo $url; ?>/images/logo.png">
<div class="settle2">
<?php if($_GET['b'] == '1') { echo "<font size='4' color='red'><b>".$message."</b></font></br>"; ?>
<b>Moderators can bypass maintenance. Please enter your details.</br>
<form method="post">
<p>Username: <input name="username"></p>
<p>Password: <input name="password"></p>
<input type="submit" name="login" value="Login">
</form>

<?php } else { echo $c_url; ?> is currently in maintenance, please check back later!<br/>
If you require assistance, please email <b><i>Support</i></b><br/><br/>
<div class="boldIt"><b><?= $current_ip ?> - <a href="?b=1">Bypass Maintenance</a></b></div>
<?php } ?>
</div>
</div>
</center>
</body>
</html>