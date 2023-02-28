<!DOCTYPE HTML>
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<link rel="icon" href="/favicon.png" type="image/png">
<link href="/stylesheets/style.css" rel="stylesheet" type="text/css" media="screen"/>
<meta http-equiv="content-type" content="text/html; charset=utf-8"/>
<title><?php echo $c_url; ?> - Account Management</title>
<style type="text/css">
.forgot {
	-moz-box-shadow:inset 0px 1px 0px 0px #97c4fe;
	-webkit-box-shadow:inset 0px 1px 0px 0px #97c4fe;
	box-shadow:inset 0px 1px 0px 0px #97c4fe;
	background:-webkit-gradient( linear, left top, left bottom, color-stop(0.05, #3d94f6), color-stop(1, #1e62d0) );
	background:-moz-linear-gradient( center top, #3d94f6 5%, #1e62d0 100% );
	filter:progid:DXImageTransform.Microsoft.gradient(startColorstr='#3d94f6', endColorstr='#1e62d0');
	background-color:#3d94f6;
	-webkit-border-top-left-radius:0px;
	-moz-border-radius-topleft:0px;
	border-top-left-radius:0px;
	-webkit-border-top-right-radius:0px;
	-moz-border-radius-topright:0px;
	border-top-right-radius:0px;
	-webkit-border-bottom-right-radius:0px;
	-moz-border-radius-bottomright:0px;
	border-bottom-right-radius:0px;
	-webkit-border-bottom-left-radius:0px;
	-moz-border-radius-bottomleft:0px;
	border-bottom-left-radius:0px;
	text-indent:0;
	border:1px solid #337fed;
	display:inline-block;
	color:#ffffff;
	font-size:15px;
	font-weight:bold;
	font-style:normal;
	height:31px;
	line-height:31px;
	width:135px;
	text-decoration:none;
	text-align:center;
	text-shadow:1px 1px 0px #1570cd;
}
.forgot:hover {
	background:-webkit-gradient( linear, left top, left bottom, color-stop(0.05, #1e62d0), color-stop(1, #3d94f6) );
	background:-moz-linear-gradient( center top, #1e62d0 5%, #3d94f6 100% );
	filter:progid:DXImageTransform.Microsoft.gradient(startColorstr='#1e62d0', endColorstr='#3d94f6');
	background-color:#1e62d0;
}.forgot:active {
	position:relative;
	top:1px;
}
</style>

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
	<li class="current"><span><span><a href="/management"><span><span>Management</span></span></a></li>
    <li><span><span><a href="http://<?php echo $url; ?>/market/"><span><span>Market</span></span></a></li>
	<li class="play"><a href="/play"></a></li>
</ul>
</div>
<?php
if(isset($_POST['update'])) {
	$new_pass=$mysqli->real_escape_string($_POST['new_pass']);
	$new_pass2=$mysqli->real_escape_string($_POST['new_pass2']);
	if($new_pass == $new_pass2) {
		$checklogin1 = htmlspecialchars($_GET["login"]);
		$mysqli->query("UPDATE User SET password = '".$new_pass."' WHERE login = '".$checklogin1."'");
		$mysqli->query("DELETE FROM `PasswordReset` WHERE login = '".$checklogin1."'");
		header('Location: ./forgot?v=1');
	} else { $message = "Passwords dont match"; }
}

if(isset($_POST['send'])) {
$login = $mysqli->real_escape_string(strtolower($_POST['login']));
$email = $mysqli->real_escape_string(strtolower($_POST['email']));
$result = $mysqli->query("SELECT `email` FROM `User` WHERE `login` = '".$login."' AND `email` = '".$email."'");

if(mysqli_num_rows($result)) {
$checkresult = mysqli_fetch_array($result);
$checkexisting = $mysqli->query("SELECT * FROM PasswordReset WHERE login = '".$login."'");
$showexisting = mysqli_fetch_array($checkexisting);
$datetoday = date("Y-m-d H:i:s");
if(mysqli_num_rows($checkexisting)) {

	$today = new DateTime($todaydate);
	$getexisting = $showexisting['date'];
	$future = new DateTime($getexisting);
	$interval = $today->diff($future);

	if(($interval->format('%d')) >= '1') {
		$from = "From: noreply@".$c_url." \n";
		$code = substr(str_shuffle("0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ"), 0, 30);
$message2 =
"This is an email from $c_url,

A password reset request has been recieved for your login at http://$url/.

To reset your password, please follow this link:http://$url/management/forgot?login=$login&code=$code";

		$email = $checkresult['email'];
		mail($email,"Reset Password",$message2,$from);
		$message="Email sent existing email";
		$mysqli->query("UPDATE `PasswordReset` SET `key`='".$code."',`date`='".$datetoday."' WHERE login = '".$login."'");	
	} else {
		$message = "You have already requested to reset password within the last day!";
	}
} else {
$from = "From: noreply@".$c_url." \n";
$code = substr(str_shuffle("0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ"), 0, 30);
$message2 =
"This is an email from $c_url,

A password reset request has been recieved for your login at http://$url/.

To reset your password, please follow this link:http://$url/management/forgot?login=$login&code=$code";

		$email = $checkresult['email'];
		mail($email,"Reset Password",$message2,$from);
		$message="Email sent";
		$mysqli->query("INSERT INTO `PasswordReset`(`login`, `key`, `date`) VALUES ('".$login."','".$code."','".$datetoday."')");	
	
}
	} else {
		$message = "This user does not exist";
	}
}

?>
<center></br></br></br></br>
<h1>Forgotten your password?</h1>
<?php if(!($_GET['login'] && $_GET['code'])) { ?>
<form method="post">
<p>Username: <input required name="login" size="35"></p>
<p>Email: <input type="email" name="email" size="35"></p>
<input class="forgot" type="submit" name="send" value="Send">
</form>
<?php } else {
$checkcode = htmlspecialchars($_GET["code"]);
$checklogin = htmlspecialchars($_GET["login"]);
$query3 = $mysqli->query("SELECT * FROM `PasswordReset` WHERE `login` = '".$checklogin."' AND `key` = '".$checkcode."'");
if(mysqli_num_rows($query3) >= '1') {
?>

<form method="post">
<p>New Password: <input name="new_pass"></p>
<p>Confirm Password: <input name="new_pass2"></p>
<input class="forgot" type="submit" name="update" value="Change Password">
</form>

<?php
} else { $message="Login and Reset Code do not match!"; }
}
?>
</center>
</br></br></br></br>
<?php if(htmlspecialchars($_GET["v"]) == '1') {
$message = "Password was successfully updated";
} ?>

<center><font color="red"><?php echo $message."</br>"; ?></font></center>
<div class="wrapper">
<div class="footer">
<span class="copyright">Chobots &#8482; Vayersoft LLC &copy; 2007-2009 & Chobots &#8482; <?php echo $c_url; ?> &copy; 2013-2014. <br/> All rights reserved.</span><br/>
<a href="/privacy" target="_blank">Privacy Policy</a>
<a href="/terms" target="_blank">Terms and Conditions</a>
</div></div>