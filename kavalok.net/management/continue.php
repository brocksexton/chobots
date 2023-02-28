<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<?php

include('./functions.php');
include("./checkmystatus.php");
sec_session_start();
if(login_check($mysqli) != true) {
	header('Location: /management/');
}

$getItem = htmlspecialchars($mysqli->real_escape_string($_GET["item"]));
$color = $_POST["color"];
if(isset($_POST['addToCart'])) {
	$array = explode(",",$_SESSION['shop']['items']);
	if(!(in_array($getItem, $array))) {
		if($_SESSION['shop']['items'] != '') {
			$_SESSION['shop']['items'] = $getItem.",".$_SESSION['shop']['items'];
			$_SESSION['shop'][$getItem]['color'] = $color;
		} else {
			$_SESSION['shop']['items'] = $getItem;
			$_SESSION['shop'][$getItem]['color'] = $color;
		}
	}
}

if(isset($_POST['removeFromCart'])) {
	$_SESSION['shop']['items'] = str_replace($getItem, "", $_SESSION['shop']['items']);
}

$randomColour = hexdec(sprintf('#%06X', mt_rand(0, 0xFFFFFF)));
?><!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<script type="text/javascript" src="jscolor/jscolor.js"></script>
<?php session_start(); ?> 
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
<style>


        @import url(https://<?= $url; ?>/stylesheets/nunito.css);
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
		<script type="text/javascript">
		$('.menu li:has(a[href$='+window.location.pathname+window.location.hash+']),.menu li:first').eq(0).addClass('current');
		$('div.menu > ul > li a').click(function(){
		  $('.menu li.current').removeClass('current');  
		  $('.menu li:has(a[href$='+this.pathname+this.hash+'])').addClass('current');
		})
		jscolor.init();
		function changeColor(color) {
			document.getElementById("color").value = intToRGB(color);
			new jscolor.color("color");
		}
		
		function intToRGB(i){
			var c = (i & 0x00FFFFFF)
				.toString(16)
				.toUpperCase();

			return "00000".substring(0, 6 - c.length) + c;
		}
		
		</script>
	</div>
</div>

<div id="content" />
<div id="notifications" style="width:75%; text-align:left; margin: 0 auto; border-radius:none !important;" />
<div class="panel panel-default">
<div class="panel-body">

<div class="row"><div class="col-md-3">
<center>
<a href="./shop"><b>Go Back</b></a><br>
<a href="./shop-cart"><b>Shopping Cart</b></a><br>
<?php 
$getInfo = mysqli_fetch_array($mysqli->query("SELECT * FROM `Tr2` WHERE `id` = '".$getItem."' AND `enabled` = '1'"));
if($getInfo['item'] == 'item') { $swfName = mysqli_fetch_array($mysqli->query("SELECT * FROM `StuffType` WHERE `id` = '".$getInfo['real_id']."'")); $getSwfName = $swfName['fileName']; }

switch($getInfo["item"]) {
    case "item": echo '<embed src="/game/ItemViewer.swf?name='.$getSwfName;
					if($getInfo["color"] == true) { echo '&selectableColor=true&color='.$randomColour; }
					echo '&citizen=0" quality=autolow wmode="transparent" width="188" height="180"></embed>'; 
					break;
	case "chat": echo '<embed src="/game/ItemViewer.swf?type=bubble&name='.$getInfo["real_id"].'" quality=autolow wmode="transparent" width="188" height="180"></embed>'; break;
	case "playercard": echo '<embed src="/game/ItemViewer.swf?type=playercard&name='.$getInfo["real_id"].'" quality=autolow wmode="transparent" width="188" height="180"></embed>'; break;
	default: echo '<img src="./images/'.$getInfo['picture_name'].'" width="188" height="180">'; 
}?>
</center>
</div>
<div class="col-md-5">
<span style="font-size:28px;font-weight:bold;"><?= $getInfo['name']; ?></span><br>
<span style="font-size:18px;"><strong>Price:</strong> <?= $getInfo['emeralds']." Emeralds"; ?></span><br>
<small><strong>Quanity Remaining:</strong> <?= $getInfo['amount_left']; ?></strong></small></small>
<hr>
</div>
<div class="col-md-4">
<div class="panel panel-default" style="border-radius:0 !important;">
<div class="panel-heading" style="border-radius:0 !important;">
<h3 class="panel-title" style="font-weight:bold; border-radius:0 !important;">Purchase Options</h3>
</div>
<div class="panel-body" style="border-radius:0 !important;">
<form method="POST" action="">
<?php if($getInfo["color"]) { ?>
Color: <input style="width:100%" class="color" id="color" value="<?= strtoupper(dechex($randomColour)); ?>" name="color"><br>
<?php } else { ?>
Color: <br><small>Custom color is not available for this item.</small><input style="width:100%;display:none;" class="color" name="color"><br> 
<?php } ?>
<br>
<?php $array = explode(",",$_SESSION['shop']['items']);
if(in_array($getItem, $array)) { ?>
<input class="btn btn-warning" style="border-radius:0 !important;width:100%;" name="removeFromCart" type="submit" value="Remove <?= $getInfo['name']; ?>">
<?php } else { ?>
<input class="btn btn-primary" style="border-radius:0 !important;width:100%;" name="addToCart" type="submit" value="Add <?= $getInfo['name']; ?> to cart">
<?php } ?>
</form>
</div>
</div> </div>
</div>
</html>