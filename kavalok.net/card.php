<?php
function generateRandomString($length = 30) {
    $characters = '0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ';
    $charactersLength = strlen($characters);
    $randomString = '';
    for ($i = 0; $i < $length; $i++) {
        $randomString .= $characters[rand(0, $charactersLength - 1)];
    }
    return $randomString;
}
$ip = $_SERVER["HTTP_CF_CONNECTING_IP"];//$_SERVER['REMOTE_ADDR'];
$hash = generateRandomString();
$date = date("Y-m-d H:i:s");

$website = $mysqli->query("SELECT `id`,`ip` FROM `VerificationCodes` WHERE `ip` = '$ip'");
if(mysqli_num_rows($website) == 1) {
	$mysqli->query("UPDATE `VerificationCodes` SET `code`='$hash',`used`='0',`date`='$date' WHERE `ip` = '$ip'");
} else {
	$mysqli->query("INSERT INTO `VerificationCodes`(`ip`, `code`, `used`, `date`) VALUES ('$ip','$hash','0','$date')");
}
?>
<html>
<head>
	<title><?= $c_url ?></title>
	<meta http-equiv="expires" content="0">
<style type="text/css">
	body {
		overflow:hidden;
	}
</style>
</head>
<body>

<?php $login = strtolower($_GET['char']); ?>

<object type="application/x-shockwave-flash" wmode="transparent"  data="/game/profile.swf?login=<?= $login ?>&hash=<?= $hash ?>" width="100%" height="100%">
	<param name="movie" value="/game/profile.swf?login=<?= $login ?>&hash=<?= $hash ?>" />
</object>

</body>
</html>