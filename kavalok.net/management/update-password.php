<?php
$username = $_SESSION['login'];
$passlength = false;
$nomatch = false;
$success = false;

if(isset($_POST['submit_pw']))
{
	$new_pass = $mysqli->real_escape_string($_POST['password']);
	$new_pass2 = $mysqli->real_escape_string($_POST['passwordv']);
	if($new_pass == $new_pass2) {
		if(strlen($new_pass) > 6 && strlen($new_pass) < 31) {
			$sql = "UPDATE `User` SET `password`='$new_pass2' WHERE `login` = '$username'";
			$mysqli->query($sql);
			$success = true;
		} else { $passlength = true; }
	} else { $nomatch = true; }
}

include('./functions.php');
include("./checkmystatus.php");
sec_session_start();
if(login_check($mysqli) != true) {
	header('Location: /management/?r=./shop');
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
<link href="/stylesheets/style.css" rel="stylesheet" type="text/css" media="screen"/>
<link href="/stylesheets/bootstrap.css" rel="stylesheet" type="text/css" />
<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.6/css/bootstrap.min.css" integrity="sha384-1q8mTJOASx8j1Au+a5WDVnPi2lkFfwwEAa8hDDdjZlpLegxhjVME1fgjWPGmkzs7" crossorigin="anonymous">
<link rel="stylesheet" href="/stylesheets/site.min.css">
<style type="text/css">.error label{color:red!important;}.error_message{display:none;}.error_message ul{margin:0!important;}.error_message ul li{color:red!important;list-style:circle!important;margin-left:15px!important;width:80%!important;}.success_message{display:none;color:green!important;}p.iText label span{color:#00B3ED;display:inline;font-family:"trebuchet MS";font-size:15px;padding-right:5px;}.loading .loader{display:block!important;}.loading .disableWhileLoading{opacity:0.15;filter:alpha(opacity= 15);zoom:1;}.loader{display:none;margin-bottom:0;margin-left:250px;margin-right:0;margin-top:-46px;position:absolute;}.clear{clear:both;}a:active,a:hover,a:visited,a:link{text-decoration:none;}</style>
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
<div class="wrapper">
	<div class="content ingame onblue">
		<div class="menu">
			<ul>
				<li><span><span><a href="/index"><span><span>Home</span></span></a></li>
				<li class="current"><span><span><a href="/management/shop"><span><span>Shop</span></span></a></li>
				<li><span><span><a href="http://blog.<?= $url; ?>/"><span><span>Community</span></span></a></li>
				<li><span><span><a href="/management"><span><span>Management</span></span></a></li>
				<li><span><span><a href="https://<?= $url; ?>/market/"><span><span>Market</span></span></a></li>
				<li class="play"><a href="/play"></a></li>
			</ul>
		</div> 
	</div>
</div>
<div id="content" />
<div id="notifications" style="width:50%; text-align:left; margin: 0 auto; border-radius:none !important;" />
<div class="panel panel-default">
<div class="panel-body">
<?php include_once("includes/header.php"); ?></br>
<?php if($success) { ?>
<div style="font-weight:bold;" class="alert alert-success alert-dismissable">Your password has been changed!</div>
<?php } ?>
<p><b>Update Password</b></p>
<?php if($passlength) { ?>
<div style="text-align:center;" class="alert alert-warning alert-dismissable">The password must be at least 6 characters <br>and not exceed 30 characters in length. Please try again.</div>
<?php } elseif ($nomatch) { ?>
<div style="text-align:center;" class="alert alert-warning alert-dismissable">The password entries do not match. Please try again.</div>
<?php } ?>
<form method="post" action="" />
New Password
<input type="password" class="form-control" id="password" name="password" placeholder=""> <br>
Confirm New Password
<input type="password" class="form-control" id="password" name="passwordv" placeholder=""> <br>
<input type="submit" name="submit_pw" id="change" value="Save Password" style="margin-top:6px;width:100%;" class="btn btn-success">
</div>
</form>
</div>
<footer>
<center>
<link href="https://<?= $url; ?>/website/css/font-awesome.css" rel="stylesheet">
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
</footer>
</html>