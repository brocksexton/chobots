<!DOCTYPE HTML>
<?php
session_start();
if(!empty($_SESSION['market']['username'])) { header("Location: ./shelves"); }
if(!empty($_POST['login'])) {

	$username = $mysqli->real_escape_string($_POST['username']);
	$password = $mysqli->real_escape_string($_POST['password']);

  if($_POST['save']) {
    setcookie("marketLogger", $username, time()+3600*72);
    setcookie("marketPassword", $password, time()+3600*72);
  } else {
    setcookie("marketLogger", $username, time()-3600);
    setcookie("marketPassword", $password, time()-3600);
  }

  $processLogin = mysqli_num_rows($mysqli->query("SELECT `id` FROM `User` WHERE `login` = '$username' AND `password` = '$password' LIMIT 1"));

  if($processLogin == 1) {

    $base = mysqli_fetch_array($mysqli->query("SELECT `id`,`created`,`login`,`moderator` FROM `User` WHERE `login` = '$username' LIMIT 1"));
	$createdDate = strtotime($base['created']);
	
	$strDate = strtotime(date('Y-m-d H:i:s'));
	
	$datediff = $createdDate - $strDate;
    $age = abs(floor($datediff/(60*60*24)));
	
	if($age >= '0') {
    //Establish the sessions
    $_SESSION['market']['username'] = $base['login'];
	$_SESSION['market']['id'] = $base['id'];

	$ref = $_GET['r'];
    if(!empty($ref)) {
		header("Location:$ref");
	} else {
		header("Location:./shelves");
	}
	} else { header("Location: ./login?v=1"); }
  } else { header("Location: ./login?v=2"); }
}

?>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
	<title>Chobots Market</title>
<style type="text/css">
	body { font-family: Helvetica, Arial, sans-serif; }
	</style>
	<link rel="icon" href = "/favicon.png" type="image/png">
	<link href="/stylesheets/style.css" rel="stylesheet" type="text/css" media="screen" />
</head>

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
    <div class="logo"><a href="<?= $url ?>"><img src="/images/logo_inner.png" alt="Chobots" /></a></div> 
    <div class="inner">
	<style>a {color:white;text-decoration:none;} div.bottom {position:fixed;bottom:0px;left:0px;right:0px;}</style>

	<h1>Please login to your account</h1>
	<?php if($_GET['v'] == '1') { echo "You need to be at least 10 days old to access the market</br></br>";
	} else if($_GET['v'] == '2') { echo "Login details dont match, please try again</br></br>"; } ?>
	<form method="post">
	<center>
	<input type="textbox" name="username" value="<?php echo $_COOKIE['marketLogger']; ?>" style="width:200px" placeHolder="Username">
	<input type="password" value="<?php echo $_COOKIE['marketPassword']; ?>" name="password" style="width:200px" placeHolder="Password">
	<input type="checkbox" <?php if(!empty($_COOKIE['marketLogger'])) { echo "checked"; } ?> name="save">Remember me<br/><br/>
	<input type="submit" name="login" value="Login to Chobots Market">
	</center>
	</form><br/>
		<br/>
	</div>
    <div style="clear:left;"></div>
	</div>
	</div>
	<div class="decor all">&nbsp;</div>
	</div>
</body>
</html>