<?php
include('./functions.php');

sec_session_start();
if(login_check($mysqli) == true) {
	header('Location: /management/me');
}
include("./checkmystatus.php");
$nouser = false;
if(isset($_POST['username'], $_POST['password'])) { 
   $login = strtolower($_POST['username']);
   $password = $_POST['password'];
	if(baned($login, $mysqli) == true) {
  		if(login($login, $password, $mysqli) == true) {
			$ref = $_GET['r'];
			if($ref) {
				header("Location:$ref");
			} else {
				header('Location: ./me.php');
			}
		} else { $nouser = true; }
	} else { $nouser = true; }
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
<link rel="stylesheet" href="./stylesheets/site.min.css">
<style type="text/css">.error label{color:red!important;}.error_message{display:none;}.error_message ul{margin:0!important;}.error_message ul li{color:red!important;list-style:circle!important;margin-left:15px!important;width:80%!important;}.success_message{display:none;color:green!important;}p.iText label span{color:#00B3ED;display:inline;font-family:"trebuchet MS";font-size:15px;padding-right:5px;}.loading .loader{display:block!important;}.loading .disableWhileLoading{opacity:0.15;filter:alpha(opacity= 15);zoom:1;}.loader{display:none;margin-bottom:0;margin-left:250px;margin-right:0;margin-top:-46px;position:absolute;}.clear{clear:both;}a:active,a:hover,a:visited,a:link{text-decoration:none;}</style>
<script>
function HideContent(d) {
document.getElementById(d).style.display = "none";
}
function ShowContent(d) {
document.getElementById(d).style.display = "block";
}
function ReverseDisplay(d) {
if(document.getElementById(d).style.display == "none") { document.getElementById(d).style.display = "block"; }
else { document.getElementById(d).style.display = "none"; }
}
//--></script>
<style>


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

#closeButton {
    position: absolute;
    top: 0;
    right: 0;
}

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

      #message3{

            display:none;
            width:100%;
            padding:3px;
            height:20%;
            #font-family:Helvetica,Arial,sans-serif;
            font-family: 'Rubik', sans-serif !important;
            #background:#0069AF;
            background:white;
            color:default;
            font-weight:normal;
            padding-top:1%;
            padding-left:5%;
            margin-bottom:19px;
            #text-align:center;
            #border-radius:15px !important;
            #padding:5px !important;
            #margin-bottom:0.5% !important;
            #position: relative;



            #border-bottom-right-radius:20% !important;
            #border-bottom-left-radius:20% !important;


        }

        .msgbtn {

            background:#0069AF;
            color:white;
            border:5px;
            margin-left:5px;
            border-style:solid;
            border-color:#0069AF;
            text-align:center;
            font-weight:bold;
            width:auto;
            padding:5px;
            border-radius:10%;

        }

        .msgbtn:hover {

            background:#01579B;
            border-color:#01579B;
            box-shadow:none;


        }

        #notification {

            width:100%;
            #font-family:Helvetica,Arial,sans-serif;
            font-family: 'Rubik', sans-serif !important;
            background:greysmoke;
            color:#fff;
            font-weight:normal;
            text-align:center;
            #margin:5px;
            border-radius:15px;

        }

        body {

            #background-color:#E0F7FA;
            #background-color:#CCD1D9; #actual color
            #font-family: 'Nunito', sans-serif !important;
            font-family: 'Karla', sans-serif !important;

            #background: #b92b27;  /* fallback for old browsers */
            #background: -webkit-linear-gradient(to bottom, #1565C0, #b92b27);  /* Chrome 10-25, Safari 5.1-6 */
            #background: linear-gradient(to bottom, #1565C0, #b92b27); /* W3C, IE 10+/ Edge, Firefox 16+, Chrome 26+, Opera 12+, Safari 7+ */



        }

        div.footer {
	       position: relative;
	       clear: both;
	       color: #666;
	       padding: 35px 20px;
	       font-size: 12px;
        }

        div.footer a {
	       margin-left: 10px;
	       font-size: 10px;
	       color: #666;
        }

        div.footer .copyright {
            margin-right: 35px;
        }

        body.girls div.footer {
            position: relative;
            clear: both;
            color: #666;
            padding: 35px 166px;
            font-size: 12px;
        }

        #header {

            border:solid;
            border-color:black;
            border-width:0px;

            font-size:21px;

            padding-top:15px;
            padding-bottom:15px;

            padding-left:21px;

            #background-color:#4DD0E1;
            background-color:inherit;
            color:white;
            width:100%;

        }

        #message {

            border:solid;
            border-color:black;
            border-width:0px;

            font-size:16px;
            #color:white;

            border-radius:15px;
            margin:0px;
            width:65%;

            padding-top:25px;
            padding-bottom:25px;

            background-color:#F5F5F5;
            width:100%;

            text-align:left;
            padding-left:14px;

            width: 50%;
            margin: 0 auto;
            bottom: 0;
            position: absolute;


        }

        #content {

            text-align:center;
            padding-left:60px;
            padding-right:40px;
            padding-top:15px;
            margin-bottom:30px;


        }

        .panel {



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

.material-icons {
  font-family: 'Material Icons';
  font-weight: normal;
  font-style: normal;
  font-size: 24px;  /* Preferred icon size */
  display: inline-block;
  line-height: 1;
  text-transform: none;
  letter-spacing: normal;
  word-wrap: normal;
  white-space: nowrap;
  direction: ltr;

  /* Support for all WebKit browsers. */
  -webkit-font-smoothing: antialiased;
  /* Support for Safari and Chrome. */
  text-rendering: optimizeLegibility;

  /* Support for Firefox. */
  -moz-osx-font-smoothing: grayscale;

  /* Support for IE. */
  font-feature-settings: 'liga';
}


    </style>
</head>
<style type="text/css">
         @import url(https://fonts.googleapis.com/css?family=Rubik);

        * {

            #font-family: "Rubik", sans-serif !important;
            border-radius:0px !important;

        }

        .alert {

            border-width:0px;
            border-left-width:7px;
            #border-right-width:9px;
            border-radius:0px !important;
            #text-align:center;
            #display:none;
            width:65%;
            margin: auto;

        }
    </style>
<body>

<div class="container-fluid" style="width:75%;">
<form method="POST" action="" ?>
<div class="jumbotron">
<p>Login to Management</p>
<div class="panel panel-default">
<div class="panel-body">
<?php if($nouser) { ?>
<div class="alert alert-danger" role="alert"><strong>You have entered the wrong username or password.</strong></div>
<?php } ?>
<form style="margin:auto;">
<div class="form-group">
<label for="exampleInputEmail1">Username</label>
<input type="text" class="form-control" id="exampleInputEmail1" placeholder="" value="" name="username">
</div>
<div class="form-group">
<label for="exampleInputEmail1">Password</label>
<input type="password" class="form-control" value="" name="password" id="exampleInputEmail1" placeholder="">
</div>
<!--
<div class="form-group" onClick="javascript:ShowContent('uniquename')">
 <input type="checkbox" name="keeplogin" value="true"> <label for="keeplogin">Keep me signed in on all devices inside my home.</label>
<div id="uniquename" style="display:none;" class="panel panel-default">
<div class="panel-body">
<p style="font-size:14px !important;">Your account will be automatically logged in on any device inside your home. Not recommended for public locations, mobile networks or if others in your home also play Chobots.<br><br>You may disable this feature anytime by logging out or contacting Support.</p>
<a href="javascript:HideContent('uniquename')">
Close this message
</a>
</div>
</div>
</div>-->

<input type="submit" class="btn btn-default" value="Login" name="submit"> <a href="./forgot" /><input type="button" class="btn btn-daneger" value="Restore Password" ?></a>
</form>
</div>
</div>
</div>
</form>
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