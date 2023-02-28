<?php
include('./functions.php');
include("./checkmystatus.php");
sec_session_start();
if(login_check($mysqli) != true) {
	header('Location: /management/?r=./shop');
}
function is_staff($mysqli, $myusername) {
    $query = "SELECT staff FROM User WHERE login = ?";
    $stmt = $mysqli->prepare($query);
    $stmt->bind_param("s", $myusername);
    $stmt->execute();
    $stmt->bind_result($staff);
    $stmt->fetch();
    $stmt->close();
    return ($staff == 1) ? true : false;
}

?>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<script type="text/javascript" src="jscolor/jscolor.js"></script>
<meta http-equiv="content-type" content="text/html; charset=utf-8"/>
<title><?php echo $c_url; ?> - Your Family Game! - Shop</title>
<meta name="keywords" content="family virtual world, kids and parents, kids education, learn by playing, fun online games for children, fun games for children, online games for kids, games on line for kids, children online games, online games for children, online games for preschool, online games for preschoolers, online games for preschool children, educational online games for children, free online games for young children, online games for small children"/>
<meta name="description" content="<?php echo $c_url; ?> is an entertaining virtual world, a family game aimed at creating an interesting, safe and learning environment for your kids."/>
<meta http-equiv="Pragma" content="no-cache"/>
<meta http-equiv="Expires" content="-1"/>
<link rel="icon" href="/favicon.png" type="image/png">
<link href="./stylesheets/style.css" rel="stylesheet" type="text/css" media="screen"/>
<link href="/stylesheets/bootstrap.css" rel="stylesheet" type="text/css" />
<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.6/css/bootstrap.min.css" integrity="sha384-1q8mTJOASx8j1Au+a5WDVnPi2lkFfwwEAa8hDDdjZlpLegxhjVME1fgjWPGmkzs7" crossorigin="anonymous">
<link rel="stylesheet" href="./stylesheets/site.min.css">
<style type="text/css">.error label{color:red!important;}.error_message{display:none;}.error_message ul{margin:0!important;}.error_message ul li{color:red!important;list-style:circle!important;margin-left:15px!important;width:80%!important;}.success_message{display:none;color:green!important;}p.iText label span{color:#00B3ED;display:inline;font-family:"trebuchet MS";font-size:15px;padding-right:5px;}.loading .loader{display:block!important;}.loading .disableWhileLoading{opacity:0.15;filter:alpha(opacity= 15);zoom:1;}.loader{display:none;margin-bottom:0;margin-left:250px;margin-right:0;margin-top:-46px;position:absolute;}.clear{clear:both;}a:active,a:hover,a:visited,a:link{text-decoration:none;}</style>
<link href="https://fonts.googleapis.com/icon?family=Material+Icons" rel="stylesheet">
<style>
        @import url(https://<?= $url; ?>/website/css/nunito.css);
        @import url(https://fonts.googleapis.com/css?family=Rubik);
        @import url(https://fonts.googleapis.com/css?family=Open+Sans+Condensed:300,700);
        @import url('https://fonts.googleapis.com/css?family=Karla');

        html,
        body    {
        margin: 0;
        padding: 0;
        height: 100%;
        font-family: 'Rubik', sans-serif !important;
}

		
        #content {

            text-align:center;
            padding-left:60px;
            padding-right:40px;
            padding-top:15px;
            margin-bottom:30px;


        }
		.navbar-inverse {

            #border-bottom-right-radius:35% !important;
            #border-bottom-left-radius:35% !important;
            border-radius:0px !important;
            text-align:center !important;

        }

@font-face {
  font-family: 'Material Icons';
  font-style: normal;
  font-weight: 400;
  src: url(https://example.com/MaterialIcons-Regular.eot); /* For IE6-8 */
  src: local('Material Icons'),
       local('MaterialIcons-Regular'),
       url(https://example.com/MaterialIcons-Regular.woff2) format('woff2'),
       url(https://example.com/MaterialIcons-Regular.woff) format('woff'),
       url(https://example.com/MaterialIcons-Regular.ttf) format('truetype');
}
div.wrapper {
    margin: 0px auto;
    width: 1135px;
    padding: 0px 250px;
    overflow: hidden;
}

</style>

</head>
<body>
<!--<div class="wrapper">
	<div class="content ingame onblue">
		<div class="menu">
			<ul>
				<li><span><span><a href="/index"><span><span>Home</span></span></a></li>
				<li class="current"><span><span><a href="/management/shop"><span><span>Shop</span></span></a></li>
				<li><span><span><a href="http://blog.<?php echo $url; ?>/"><span><span>Community</span></span></a></li>
				<li><span><span><a href="/management"><span><span>Management</span></span></a></li>
				<li><span><span><a href="/market/"><span><span>Market</span></span></a></li>
				<li class="play"><a href="/play"></a></li>
			</ul>
		</div> 
	</div>
</div>-->
<?php
if(isset($_POST['activate']))
{
	$sql = "UPDATE `User` SET `activated`=1,`chatEnabled`=1 WHERE `login` = '$myusername'";
	$mysqli->query($sql);
	$message = $myusername." has successfully been activated!";
}
?>
<div id="content">
<div id="notifications" style="width:75%; text-align:left; margin: 0 auto; border-radius:none !important;" />
<div class="panel panel-default">
<div class="panel-body">
<p><b>My Account</b></p><center>
<?php
$date1 = new DateTime(date('Y-m-d', strtotime($mycheck1["citizenExpirationDate"])));
$date2 = new DateTime(date('Y-m-d'));
$difference = $date1->diff($date2)->days;
if (new DateTime() > new DateTime($mycheck1["citizenExpirationDate"]) && $difference < 8) {
	$expired = true;
} elseif($difference < 7 ) { 
	$expiring = true;
}
if($expiring or $expired) {
?>
<div style='text-align:center !important;'>
<div class='alert alert-warning' role='alert'>
<h1><i class='material-icons' style='font-size:65px;'>card_membership</i></h1>
<?php 
if($expired) { 
	echo "<h3>Your Citizenship expired " . $difference ." days ago.</h3>";
} elseif($expiring) { 
	echo "<h3>Your Citizenship will expire in " . $difference ." days.</h3>"; 
} ?>
Don't miss out on your favorite features...<br>
<a href='./citizenship'><b>Renew Your Citizenship</b></a></small>
</div>
</div>
<hr>
<?php } ?>
<?php include_once("includes/header.php"); ?>
<!--<img src="/images/logo.png" style="width:25%;pointer-event:none;">-->
<div class="row">
<div class="col-md-6">
<div class="well" style='background-color:#e0c01d;color:white;'>
<strong><i class="material-icons">card_membership</i><br>My Balance</strong>
<br />
<span style="font-size:28px;"><?= number_format($GameChar["money"]); ?> Bugs</span>
<!--<a href='./emeralds'><button class="btn btn-warning" style=" width:100%;">Buy Emeralds</button></a>-->
</div>
<br>
<a href='team'><button class="btn btn-danger" style=" width:100%;">Manage your team</button></a>
<br>
<br>
<a href='https://kavalok.net/market'><button class='btn btn-success' style=' width:100%;'>Chobots Market</button></a><br>
<!--<br>
<a href='https://www.chobots.ca/citizenship'><button class='btn btn-success' style=' width:100%;'>Extend Citizenship</button></a><br>-->
<br>
<a href='shop'><button class='btn btn-success' style=' width:100%;'>Premium $hop</button></a><br>

<?php
if (is_staff($mysqli, $myusername)) {
    echo "<a href='https://kavalok.net/game/SecuredKavalokClient2022.swf'><button class='btn btn-success' style=' width:100%;'>Staff Panel</button></a><br>";
}
?>

<br>
</div>
<div class="col-md-6" style="border-color:grey#EEEEEE;border-width:0px;border-style:dashed;border-left-width:2.5px;">
<h3 style='text-align:left;'>
Hi, <?= ucfirst($myusername); ?>!
</h3>
<embed src="/char/<?= $myusername ?>" width="235" height="308" /></embed>
<table class="table table-condensed" style="border:none !important;font-weight:bold;">
<tr>
<td>
<small>Email</small></td>
<td>
<small><?= $mycheck1["email"]; ?><br><strong><a href="update-email">[Update]</a></strong></small>
</td>
</tr>
<tr>
<td>
<small>Password</small></td>
<td>
<small>**********<br><strong><a href="update-password">[Update]</a></strong></small>
</td>
</tr>
<tr>
<td>
<small>Citizenship<br>Expires</small></td>
<td>
<small>
<?= date_format(date_create($mycheck1["citizenExpirationDate"]), "F d, Y"); ?>
</small></td>
</tr> <tr>
<td>
<small>Bugs</small></td>
<td>
<small><?= number_format($GameChar['money']); ?></small></td>
</td>
</tr>
<tr>
<!--<td>
<small>&nbsp;&nbsp;</small></td>
<td>

<small><strong><a href="modify_name">[Change Username]</a></strong></small>
</td>-->
</tr>
</table>
</div>

</div>
</div>
</div>
<!--<footer>
<center>
<div id="content" />
<div class="well" style="width:75%;margin-left: auto; margin-right: auto ; padding:7px;" />
<center>
<span class="copyright">Chobots &#8482; Vayersoft LLC &copy; 2007-2010. All rights reserved. This Chobots instance is a re-creation and is for educational and entertainment purposes only.<br />
Any in-game purchases or donations go towards supporting the server costs.</span><br />
<a href="/privacy.php" target="_blank">Privacy Policy</a> |
<a href="/terms.php" target="_blank">Terms and Conditions</a> |
<a href="/support/" target="_blank">Contact Us</a><br><br>
</center>
</div>
</div>
</center>
</footer>-->
</html>