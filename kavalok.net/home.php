<!DOCTYPE html>
<html lang="en">

	<?php 
	session_start();
	require "./prepend.php";
	
	?>

<head>
	<title>Chobots - Virtual World for Kids</title>
	<meta name="keywords" content="chobots, game, virtual world, play, kids, free, cho, chobots.in" />
	<meta name="author" content="Chobots">
        <meta name="description" content="Chobots is a free, fun virtual world for kids, where you can dress up your character, chat with friends and use Chobots magic you find anywhere else.">
	<meta charset="utf-8">

	
	<link href="\assets\stylesheets/styleindex.css" rel="stylesheet" type="text/css">
	<link href="\assets\images\councilor.png" rel="icon" type="image/png">
	<link href='http://fonts.googleapis.com/css?family=Open+Sans:400,700' rel='stylesheet' type='text/css'>
	<link href='http://fonts.googleapis.com/css?family=Lobster' rel='stylesheet' type='text/css'>
	<link href='http://fonts.googleapis.com/css?family=Montserrat' rel='stylesheet' type='text/css'>
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
	<div id="onlineUsers">
			<?php

		$result = $mysqli->query("SELECT * FROM `UserServer` ORDER BY `id`");
		$count = mysqli_num_rows($result);

		echo "<font size='3' color='#FFF'/>" . number_format($count) . " Online Users<br>";
		  ?>
		</div>
		&nbsp;
		&nbsp;
    <div class="video">
    <iframe width="560" height="315" src="https://www.youtube.com/embed/nkrRLe41sR0" frameborder="0" allowfullscreen></iframe>
    </div>
   <div class="topContainer"> 
</div>
<div class="magic">
<img src="\assets\images\magic.png" width="258" height="235" align="right"></a>
 </div>
</div>
<div class="eu">
<img src="http://i.imgur.com/ADxUkJ8.png" align="right"></a>
</div>
 <div class="become">
 <a href="/play.php"><img src="\assets\images\become.png" width="210" height="108" align="right"></a>
 </div>
<div class="play">
   <a href="/play.php"><img src="\assets\images\play.png" width="176" height="91" align="right"></a>
   </div>
   
<div class="gameContainer">
			<div class="nav">
				<ul>
					<li><a href="/">Home</a></li>
                    <li><a href="https://www.penguinchat.icu/">Club Penguin</a></li>
					<li><a href="http://www.chobots.icu/management">Management</a></li>
					<li><a href="https://cardiacar.rest">Stats</a></li>
                    <li><a href="https://discord.gg/u3NwjKtjJn">Discord</a></li>
				</ul>
				</ul>
			</div>
            
 <div class="swfz">
		<object width="495px" height="230px">
   			<param name="movie" value="assets/pic2.png"> 
    		<embed style="border: 2px solid #fff; border-radius: 5px;" src="assets/pic2.png" width="495px" height="230px"></embed>
		</object>
<object width="495px" height="230px">
   			<param name="movie" value="assets/pic3.png"> 
    		<embed style="border: 2px solid #fff; border-radius: 5px;" src="assets/pic3.png" width="495px" height="230px"></embed>
		</object>
	</div>
    
		</div>
	</div>
</div>

	<div class="footerContainer">
		<div class="footer">
           <a href="http://blog.chobots.ca/p/contact.html"><img src="\assets\images\support.png" width="117" height="49" align="left"></a> 
           <a href="http://blog.chobots.ca/p/about.html"><img src="\assets\images\about.png" width="117" height="49" align="right"></a> 
			Copyright &copy; 2016 - Chobots.ca&trade; <br>
			Copyright &copy; 2007-2011 - Chobots&trade; by Vayersoft LLC<br>
			All rights reserved - <a href="/jobs.html">Jobs</a> - <a href="/terms.html">Terms</a> - <a href="/privacy.html">Privacy</a> | Site By: Hershvir/hershey#0001
		</div>
	</div>
</body>
</html>
