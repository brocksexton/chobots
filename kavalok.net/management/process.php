<?php
include_once("includes/twitteroauth.php");
include_once("functions.php");
include_once("checkmystatus.php");


if(isset($_REQUEST['oauth_token']) && $_SESSION['token']  !== $_REQUEST['oauth_token']) {
	session_destroy();
	header('Location: me?v=1');
}elseif(isset($_REQUEST['oauth_token']) && $_SESSION['token'] == $_REQUEST['oauth_token']) {

	$connection = new TwitterOAuth($twitter_consumerKey, $twitter_consumerSecret, $_SESSION['token'] , $_SESSION['token_secret']);
	$access_token = $connection->getAccessToken($_REQUEST['oauth_verifier']);
	if($connection->http_code == '200')
	{	
		//Insert user into the database
		$mysqli->query("UPDATE `User` SET `twitterName` = '".$access_token['screen_name']."', `accessToken` = '".$access_token['oauth_token']."', `accessTokenSecret` = '".$access_token['oauth_token_secret']."' WHERE `login` = '".$myusername."'");

		//Unset no longer needed request tokens
		unset($_SESSION['token']);
		unset($_SESSION['token_secret']);
		header('Location: me.php');
	}else{
		header('Location: me?v=1');
	}
		
}else{
	if(isset($_GET["denied"]))
	{
		header('Location: me?v=1');
	}

	//Fresh authentication
	$connection = new TwitterOAuth($twitter_consumerKey, $twitter_consumerSecret);
	$request_token = $connection->getRequestToken("http://".$url."/management/process");
	
	//Received token info from twitter
	$_SESSION['token'] 			= $request_token['oauth_token'];
	$_SESSION['token_secret'] 	= $request_token['oauth_token_secret'];
	
	//Any value other than 200 is failure, so continue only if http code is 200
	if($connection->http_code == '200')
	{
		//redirect user to twitter
		$twitter_url = $connection->getAuthorizeURL($request_token['oauth_token']);
		header('Location: ' . $twitter_url); 
	}else{
		header('Location: me?v=1');
	}
}
?>

