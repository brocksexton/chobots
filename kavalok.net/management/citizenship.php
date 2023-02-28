<?php
include('./functions.php');
include("./checkmystatus.php");
sec_session_start();
if(login_check($mysqli) != true) {
	header('Location: /management/?r=./citizenship');
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
<?php
if(isset($_POST['submit']))
{
	//session_start();
	echo $_POST["hidfield"];
}
?>
<div id="content" />
<div id="notifications" style="width:75%; text-align:left; margin: 0 auto; border-radius:none !important;" />
<div class="panel panel-default">
<div class="panel-body">

<?php include_once("includes/header.php"); ?>
<p><b>Purchase Citizenship</b></p>
<b>Your Emerald balance is: </b> <?= $GameChar["emeralds"]; ?><br>
<a href='./emeralds'> Top-up my Emeralds! </a>
<br>
<br>
<form method="POST" action="">
<div class="panel panel-default">

<table class="table table-striped" style="font-size:13px;text-align:center;border-radius:15px !important;">
<tr class="active">
<td>
<b>Plan</b>
</td>
<td>
<b>Price</b>
</td>
<td>
<b>Bonus</b>
</td>
<td>
<b>Select</b>
</td>
</tr>

<?php
$getPackages = $mysqli->query("SELECT * FROM `CitizenshipPackages`");
while($row = mysqli_fetch_array($getPackages)){
	$swfName1 = mysqli_fetch_array($mysqli->query("SELECT `fileName` FROM `StuffType` WHERE `id` = '".$row['item1']."'"));
	$swfName2 = mysqli_fetch_array($mysqli->query("SELECT `fileName` FROM `StuffType` WHERE `id` = '".$row['item2']."'"));

?>
<tr>
	<td>
	<a data-toggle="modal" data-target=".bs-example-modal-lg2" style="font-weight:bold;"><?= $row["package"]; ?></a>
	</td>
	<td><strong>$<?= $row["price"]; ?></strong><br>Renews Monthly<br>at $<?= $row["renewPrice"]; ?>.
	<br>
	<strong>Recurring</strong>
	</td>
	<td>1 month of Citizenship<br><?= $row['bugs']; ?> Bugs<br>
	<embed src="/game/ItemViewer.swf?name=<?= $swfName1['fileName']; ?>&color=0x0&citizen=0" quality=autolow wmode="transparent" width="75" height="75"></embed>
	<?php if($swfName2) { ?>
	&nbsp;<embed src="/game/ItemViewer.swf?name=<?= $swfName2['fileName']; ?>&color=0x0&citizen=0" quality=autolow wmode="transparent" width="75" height="75"></embed>
	<?php } ?>
	</td>
	<td class="active">
	<input type="radio" name="amount" value="1" onClick="document.getElementById('hidfield').value='$4.99';document.getElementById('hidfield1').value='Citizen Tier 1'">
	</td>
</tr>
<?php } ?>
</table>
<div class="container" style="text-align:center;" />

</div>
<div class="list-group">
<input type="submit" style="width:100%;color:white;background-color:#337AB7;" class="list-group-item" value="Check Out" name="submit" />
</div>
</div></center>
</div>
</form>
</div>
</div>
</div>
</div>
<footer>

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
</footer>
</html>