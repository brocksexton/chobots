<?php
include('./functions.php');
include("./checkmystatus.php");
sec_session_start();
if(login_check($mysqli) != true) {
	header('Location: /management/');
}
if($_GET['delete']) {
	$_SESSION['shop']['items'] = str_replace($_GET['delete'], "", $_SESSION['shop']['items']);
}
$successful = false;
$nofunds = false;
$owned = false;
$file = null;
if(isset($_POST['shop'])) {
	if($_SESSION['shop']['items'] != null) {
	$array = explode(",",$_SESSION['shop']['items']);
	foreach($array as $item) {
		if($item != '') {
			$checkItem = $mysqli->query("SELECT `id`,`name`,`emeralds`,`picture_name`,`item`,`real_id`,`amount_left` FROM `Tr2` WHERE `id` = '".$item."'");
			$checkItemExists = mysqli_num_rows($checkItem);
			$mysql_get_items = mysqli_fetch_array($checkItem);
			if($mysql_get_items['amount_left'] >= '1' && $checkItemExists >= '1') {
				$product_price = $mysql_get_items['emeralds'];
				if($GameChar['emeralds'] < $product_price) {
					$nofunds = true;
				}
				$item_id = $item;
				$user_id = $mycheck1['id'];
				$color = $_SESSION['shop'][$item_id]['color'];
				$product = $mysql_get_items['item'];
				$real_id = $mysql_get_items['real_id'];
				$newvalue = $mysql_get_items['amount_left']-1;
				
				$date = date('Y-m-d H:i:s');
				
				if($product == 'item') {
					$color = hexdec($color);
					$ipn_message = "Bought Item: ".$mysql_get_items['name'];
					$file = 'addStuff.jsp?action=item&userId='.$user_id.'&colour='.$color.'&reason=Bought%20Item&itemId='.$real_id;
				}
				
				if($product == 'bugs') {
					$ipn_message = "Bought ".$real_id." Bugs";
					$file = 'addStuff.jsp?action=bugs&userId='.$user_id.'&amount='.$real_id;
				}
				
				if($product == 'body') {
					if(strpos($mycheck1["purchasedBodies"], $real_id) === false) { // WASNT FOUND
						$ipn_message = "Bought the Body; ".$mysql_get_items['name'];
						$file = 'addStuff.jsp?action=saveStuff&userId='.$user_id.'&type=body&new='.$real_id.'&cost='.$product_price;
					} else { $owned = true; }
				}
				
				if($product == 'playercard') {
					if(strpos($mycheck1["purchasedCards"], $real_id) === false) { // WASNT FOUND
						$ipn_message = "Bought the Playercard; ".$mysql_get_items['name'];
						$file = 'addStuff.jsp?action=saveStuff&userId='.$user_id.'&type=card&new='.$real_id.'&cost='.$product_price;
					} else { $owned = true; }
				}
				
				if($product == 'chat') {
					if(strpos($mycheck1["purchasedBubbles"], $real_id) === false) { // WASNT FOUND
						$ipn_message = "Bought the Chatbubble; ".$mysql_get_items['name'];
						$file = 'addStuff.jsp?action=saveStuff&userId='.$user_id.'&type=chat&new='.$real_id.'&cost='.$product_price;
					} else { $owned = true; }
				}	
				
				if(!$nofunds and !$owned) {
					$mysqli->query("INSERT INTO `ipn_alerts`(`username`,`msg`,`itemid`,`date`) VALUES ('".$username."','".$ipn_message."','".$mysql_get_items['real_id']."','".$date."')");
					unset($_SESSION['shop']['items']);
				
					if($file != null) {
						$RemoteService = $file;
						include('../RemoteService.php');
					}
					$successful = true;
				}
			}
		}
	}
	}
}
?><!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
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
<link rel="stylesheet" href="/stylesheets/.site.min.css">
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
<div id="content" />
<div id="notifications" style="width:75%; text-align:left; margin: 0 auto; border-radius:none !important;" />
<div class="panel panel-default">
<div class="panel-body">
<a href="./shop"><b>Continue Shopping</b></a>
<h4>Shopping Cart</h4>
<p>Please review your shopping cart before continuing...</p>
<?php if($successful) { ?>
	<h1 style="text-align: center;">
	<strong>Thank You!</strong></h1>
	<p style="text-align: center;">
	<strong>Your purchased items or features have been added to your player! If you have any questions, please open a Support Ticket.</strong></p></div></div></div></div><div class="offline-ui offline-ui-up"><div class="offline-ui-content"></div><a href="" class="offline-ui-retry"></a></div><div class="offline-ui offline-ui-up"><div class="offline-ui-content"></div><a href="" class="offline-ui-retry"></a></div><div id="PopupSignupForm_0" widgetid="PopupSignupForm_0">
<?php die; } elseif($_SESSION['shop']['items'] == null) {   ?>
<div class="alert alert-info" role="alert"><?php if(isset($_POST['shop'])) { echo '<strong>Purchase not successful</strong>'; } ?> You need to add items to your cart to checkout.</div>
<?php die; } elseif($nofunds) { ?>
	<div class="alert alert-warning" role="alert"><strong>Purchase not successful.</strong> You do not have enough funds to purchase these items.</div>
<?php } elseif($owned) { ?>
	<div class="alert alert-warning" role="alert"><strong>Purchase not successful.</strong> You already own this item.</div>
<?php } ?>
<center>
<table class="table table-hover" style="text-align:center;">
<tr class="active">
<td>
<strong>Item</strong>
</td>
<td>
<strong>Price</strong>
</td>
<td>
&nbsp;
</td>
</tr>
<?php
$totalPrice = 0;
$array = explode(",",$_SESSION['shop']['items']);
foreach ($array as $itemId) {
	$getInfo = mysqli_fetch_array($mysqli->query("SELECT * FROM `Tr2` WHERE `id` = '".$itemId."' AND `enabled` = '1'"));
	$totalPrice = $totalPrice+$getInfo["emeralds"];
	$_SESSION['shop']['items']
?>
<tr>
<td>
<small><?= $getInfo["name"]; ?></small>
</td>
<td>
<small><?= $getInfo["emeralds"]." Emeralds"; ?></small>
</td>
<td>
<a href="?delete=<?= $itemId; ?>"><small><button class="btn btn-sm btn-danger">Remove</button></small></a>
</td>
</tr>
<?php } ?>
<tr class="active">
<td>
<small><strong style="text-align:right;">TOTAL DUE:</strong></small>
</td>
<td>
<small><?= $totalPrice; ?> Emeralds</small>
</td>
<td>
<form method="POST" action="">
<input type="submit" name="shop" class="btn btn-sm btn-success" value="CHECKOUT" />
</form>
</td>
</tr>
</table>
<br>
<small style="text-align:left;"><strong>Your purchase will be completed using your Emerald Balance.</strong></small>
</center>
</div>
</div>
</div>
</div>
<script type="683a15f1269bfd2adad480ff-text/javascript">
function abp() {
    if ($('.ad').height() == 0) {
        $('.ad').css("height", "90px");
        $('.ad').css("background-image", "url(https://<?= $url; ?>/website/images/adb.png)");
    }
}
$(abp);
</script>
<script src="https://ajax.cloudflare.com/cdn-cgi/scripts/2448a7bd/cloudflare-static/rocket-loader.min.js" data-cf-nonce="683a15f1269bfd2adad480ff-" defer=""></script></body>
</html>