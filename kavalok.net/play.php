<!DOCTYPE html>
<html lang="en">

	<?php 
	session_start();
	require "./prepend.php";
	
	?>

<head>
	<title>Chobots - Play Now</title>
	<meta name="keywords" content="play, game, virtual world, chobots, chobots.icu, play now" />
	<meta name="author" content="Chobots">
	<meta charset="utf-8">
	
	<link href="/assets/stylesheets/style.css" rel="stylesheet" type="text/css">
	<link href="/assets/images/councilor.png" rel="icon" type="image/png">
	<link href='http://fonts.googleapis.com/css?family=Open+Sans:400,700' rel='stylesheet' type='text/css'>
	<link href='http://fonts.googleapis.com/css?family=Lobster' rel='stylesheet' type='text/css'>
	<link href='http://fonts.googleapis.com/css?family=Montserrat' rel='stylesheet' type='text/css'>
	<style>
		#message2{
	
				width:100%;
				padding:3px;
				#font-family:Helvetica,Arial,sans-serif;
				font-family: 'Rubik', sans-serif !important;
				#background:#0069AF;
				background:#0069AF;
				color:#fff;
				font-weight:normal;
				text-align:center;
				#border-radius:15px !important;
				#padding:5px !important;
				#margin-bottom:0.5% !important;
				#position: relative;
	
				#border-bottom-right-radius:20% !important;
				#border-bottom-left-radius:20% !important;
	
				#background: #4B79A1;  /* fallback for old browsers */
				#background: -webkit-linear-gradient(to top, #283E51, #4B79A1);  /* Chrome 10-25, Safari 5.1-6 */
				#background: linear-gradient(to top, #283E51, #4B79A1); /* W3C, IE 10+/ Edge, Firefox 16+, Chrome 26+, Opera 12+, Safari 7+ */
	background: #2b5876;  /* fallback for old browsers */
	background: -webkit-linear-gradient(to bottom, #4e4376, #2b5876);  /* Chrome 10-25, Safari 5.1-6 */
	background: linear-gradient(to bottom, #4e4376, #2b5876); /* W3C, IE 10+/ Edge, Firefox 16+, Chrome 26+, Opera 12+, Safari 7+ */
	
	
			}
			</style>
<style>
	#onlineUsers{

			width:100%;
			padding:3px;
			#font-family:Helvetica,Arial,sans-serif;
			font-family: 'Rubik', sans-serif !important;
			#background:#0069AF;
			background:#0069AF;
			color:#fff;
			font-weight:normal;
			text-align:center;
			#border-radius:15px !important;
			#padding:5px !important;
			#margin-bottom:0.5% !important;
			#position: relative;

			#border-bottom-right-radius:20% !important;
			#border-bottom-left-radius:20% !important;

			#background: #4B79A1;  /* fallback for old browsers */
			#background: -webkit-linear-gradient(to top, #00c9ff, #1abdf3);  /* Chrome 10-25, Safari 5.1-6 */
			#background: linear-gradient(to top, #00c9ff, #1abdf3); /* W3C, IE 10+/ Edge, Firefox 16+, Chrome 26+, Opera 12+, Safari 7+ */
background: #2b5876;  /* fallback for old browsers */
background: -webkit-linear-gradient(to bottom, #00c9ff, #1abdf3);  /* Chrome 10-25, Safari 5.1-6 */
background: linear-gradient(to bottom, #00c9ff, #1abdf3); /* W3C, IE 10+/ Edge, Firefox 16+, Chrome 26+, Opera 12+, Safari 7+ */


		}
		</style>
</head>
<body>
		<div id="message2">
			<span>Chobots doesn't encrypt passwords, please use a brand new never used password.</span>
		</div>
		<div id="onlineUsers">
			<?php

		$result = $mysqli->query("SELECT * FROM `UserServer` ORDER BY `id`");
		$count = mysqli_num_rows($result);

		echo "<font size='3' color='#FFF'/>" . number_format($count) . " Online Users<br>";
		  ?>
		</div>
		&nbsp; ( )
     	<div class="topContainer">
		<div class="navBg">
			<div class="nav">
             <div class="logo">
			<img src="http://i.imgur.com/xp1tGAR.png" width="160" height="60">

            </div>
				<ul>
					<li><a href="/">Home</a></li>
                    <li><a href="https://www.penguinchat.icu/">Club Penguin</a></li>
					<li><a href="http://www.chobots.icu/management">Management</a></li>
					<li><a href="https://cardiacar.rest">Stats</a></li>
                    <li><a href="https://discord.gg/u3NwjKtjJn">Discord</a></li>
				</ul>
			</div>
		</div>
	</div>
                  <div class="stone">
          <img src="/assets/images/asteroidsmall.png" width="80" height="76">
</div>
<div class="gameContainer">
<object width="922px" height="537px">
<param name="movie" value="../game/client.swf">
<embed style="border: 2px solid #fff; border-radius: 5px;" src="../game/client.swf" width="922px" height="537px"></embed>
</object>
</div>

 
	<div class="footerContainer">
		<div class="footer">
           <a href="http://www.chobots.icu/game/client.swf"><img src="https://www.chobots.icu/images/fullscreen.png" width="117" height="49" align="left"></a> 
           <a href="http://blog.chobots.icu/p/about.html"><img src="/assets/images/about.png" width="117" height="49" align="right"></a> 
				Copyright &copy; 2016 - chobots.icu&trade; <br>
			Copyright &copy; 2007-2011 - Chobots&trade; by Vayersoft LLC<br>
			All rights reserved - <a href="/jobs.html">Jobs</a> - <a href="/terms.html">Terms</a> - <a href="/privacy.html">Privacy</a> | Site By: Hershvir/hershey#0001 
		</div>
	</div>
	
</body>
</html>
