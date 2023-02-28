<?php
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
<link href="./stylesheets/style.css" rel="stylesheet" type="text/css" media="screen"/>
<link href="/stylesheets/bootstrap.css" rel="stylesheet" type="text/css" />
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
<div id="content" />
<div id="notifications" style="width:75%; text-align:left; margin: 0 auto; border-radius:none !important;" />

<div class="panel panel-default">

<div class="panel-body">
<?php include_once("includes/header.php"); ?>
</br>
<div class="row">

<div class="col-md-4" style="background-color:#ECEFF1;border-width:0px;border-style:dashed;border-radius:3px;height:100%;background: #FFEEEE;  /* fallback for old browsers */
background: -webkit-linear-gradient(to bottom, #DDEFBB, #FFEEEE);  /* Chrome 10-25, Safari 5.1-6 */
background: linear-gradient(to bottom, #DDEFBB, #FFEEEE); /* W3C, IE 10+/ Edge, Firefox 16+, Chrome 26+, Opera 12+, Safari 7+ */
">
&nbsp;
<br>
<div class="well" style="text-align:center;">
<strong>My Balance</strong>
<br />
<span style="font-size:28px;"><?= $GameChar["emeralds"] ?> Emeralds</span>
</div>
<br>
<a href="shop-cart"><button type="button" class="btn btn-default" style="width:100%;"><span class="glyphicon glyphicon-shopping-cart" aria-hidden="true"></span> SHOPPING CART</button> </a> <br>
<br>
What are you looking for today?
<?php $getItem = htmlspecialchars($_GET["sort"]); if(!$getItem) { $getItem = "item"; } ?>

<a href="shop"><button type="button" class="btn btn-primary" style="width:100%;">Items</button> </a> <br>
<br>
<a href="shop?sort=body"><button type="button" class="btn btn-success" style="width:100%;">Bodies</button> </a> <br>
<br>
<a href="shop?sort=chat"><button type="button" class="btn btn-primary" style="width:100%;">Chat Bubbles</button> </a> <br>
<br>
<a href="shop?sort=playercard"><button type="button" class="btn btn-success" style="width:100%;">Playercards</button> </a> <br>
<br>
<hr>
</div>

<div class="col-md-8" style="max-width: 100% !important;">
<span style="font-size:20px;"><strong>
<?php
switch($getItem)
{
    case 'body': echo "Bodies";  break;
	case 'chat':  echo "Chat Bubbles";  break;
    case 'item':  echo "Items";  break;
	case 'playercard':  echo "Playercard";  break;
}
if($_GET['page']) {
	$page = $_GET['page'];
	$limit = 5 * $page - 5;
} else {
	$page = 1;
	$limit = 0;
}
?> 
</strong></span></div><br><br><center><table style='width:35%;'>

<?php
$check1 = $mysqli->query("SELECT * FROM `Tr2` WHERE `item` = '".$getItem."' AND `enabled` = '1' LIMIT $limit,5");
while($row = mysqli_fetch_array($check1)) {
	
$amount_left = $row['amount_left'];
if($amount_left >= '1') {
if($getItem == 'item') { 
	$swfName = mysqli_fetch_array($mysqli->query("SELECT * FROM `StuffType` WHERE `id` = '".$row['real_id']."'")); 
	$getSwfName = $swfName['fileName']; 
}

?>

<tr style='background-color:#FAFAFA;margin:7px;border:solid;border-width:1px;border-radius:16% !important;border-color:#FAFAFA;'>
<td>
<center>
<?php
switch($getItem) {
    case "item": 	$randomColor = hexdec(sprintf('#%06X', mt_rand(0, 0xFFFFFF)));
					echo '<embed src="/game/ItemViewer.swf?name='.$getSwfName;
					if($row["color"] == true) { echo '&color='.$randomColor; }
					echo '&citizen=0" quality=autolow wmode="transparent" width="188" height="180"></embed>'; 
					break;
	case "chat": echo '<embed src="/game/ItemViewer.swf?type=bubble&name='.$row["real_id"].'" quality=autolow wmode="transparent" width="188" height="180"></embed>'; break;
	case "playercard": echo '<embed src="/game/ItemViewer.swf?type=playercard&name='.$row["real_id"].'" quality=autolow wmode="transparent" width="188" height="180"></embed>'; break;
	default: echo '<img src="./images/'.$row['picture_name'].'" width="188" height="180">'; 
}?></br>
<a><strong><?php echo $row['name']; ?></strong></a><br>
<strong><?= $row['emeralds']." Emeralds"; ?></strong>
&nbsp;
<br><br>
<?php if($row['color']) { ?><small><b><span class="glyphicon glyphicon-tint" aria-hidden="true"></span> Custom Color Available</b></small><br> <?php } ?>
<a style='width:100%;font-weight:bold;border-radius:0 !important;' class='btn btn-primary' href='/management/continue?item=<?= $row['id']; ?>' role='button'>LEARN MORE</a>
</center>
</td>
</tr>
<tr><td>&nbsp;</td></tr>


<?php } } ?>
</table></center>
<center><ul class="pagination">
<?php
$check2 = $mysqli->query("SELECT * FROM `Tr2` WHERE `item` = '".$getItem."' AND `enabled` = '1'");
$pageNumbers = mysqli_num_rows($check2);
$totalPages = ceil($pageNumbers / 5);
if($totalPages == 0) { $totalPages = 1; }
for ($i=1; $i<=$totalPages; $i++) {
	if($i == $page) { $bb = "<b>".$i."</b>"; } else { $bb = $i; }
    echo "<li><a href='/management/shop?sort=".$getItem."&page=".$i."'>".$bb."</a></li>";
}
?>

<br /><br /><br /><br /> </ul></center>
</div>
</div>

</div>
</div>
</div>
</div>
</html>