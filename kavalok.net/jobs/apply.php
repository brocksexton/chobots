<?php
$title = $_GET["title"];
$str = strtoupper($title);
$string = $mysqli->real_escape_string($_GET["title"]); 
?>
<!DOCTYPE HTML>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<title>Job Application - <?php echo $title; ?></title>
<link rel="stylesheet" href="panel.css" type="text/css" media="screen" title="no title" charset="utf-8">
<script type="text/rocketscript" data-rocketsrc="https://ajax.googleapis.com/ajax/libs/jquery/1.6.4/jquery.js"></script>
<script type="text/rocketscript" data-rocketsrc="https://ajax.googleapis.com/ajax/libs/jqueryui/1.8.16/jquery-ui.js"></script>
<script type="text/rocketscript" data-rocketsrc="transitions.js"></script>
<style>textarea{resize:none;}</style>
</head>
<body>
<div id="top">
<h1><?php echo $c_url; ?> - <?php echo $str; ?> APPLICATION</h1>
</div>
<div id="cont">
<a href="/jobs" class="back">Return</a>
<div id="searching">
<div id="results">
<?php
$error = "";
include_once('check.php');?>
<h1><?php echo $error; ?></h1><?php

$sql = "SELECT * FROM `jobs_available` WHERE `job` = '$string'";
$check = $mysqli->query($sql);
$check2 = mysqli_fetch_array($check);

if(mysqli_num_rows($check) >= 1)
{
if ($check2['enabled'] == 'true') {
?>
<form method="POST">
<h1><center><b>Welcome!</b></center></h1>
<div id="items">
Here at <?php echo $c_url; ?>, we're looking for the best of the best to help show all of the potential Chobots has. In order to meet needs and demands, we have requirements for each position, to ensure we make the right pick. Here are a few basic requirements to apply:<br/>
</div>
<ul><table border=0><tr><td align=left>
<li><?php echo $check2['requirement_1']; ?></li>
</td></tr><tr><td align=left>
<li><?php echo $check2['requirement_2']; ?></li>
</td></tr><tr><td align=left>
<li><?php echo $check2['requirement_3']; ?></li>
</td></tr><tr><td align=left>
<li><?php echo $check2['requirement_4']; ?></li>
</td></tr>
</table></ul>

<table border="0" align="center">
<tr>
<td align="left"><b>Your Name</b><spr><FONT COLOR="#ff0000">*</spr></font><br/><font size="2">&nbsp&nbsp&nbsp Who are you?</font><br/><input type="text" class="textField" required name="firstname" value="First" onBlur="if(this.value=='')this.value='First'" onFocus="if(this.value=='First')this.value=''"><br/><input type="text" required class="textField" name="lastname" value="Last" onBlur="if(this.value=='')this.value='Last'" onFocus="if(this.value=='Last')this.value=''"></td>
</tr>
<tr><td> </td></tr>
<tr><td> </td></tr>
<tr><td> </td></tr>
<tr><td> </td></tr>
<tr><td> </td></tr>
<tr><td> </td></tr>
<tr>
<td align=left><b>Your Chobot Name</b><br/><font size="2">&nbsp&nbsp&nbsp Do you have a Chobots account?</font><br/><input type="text" class="textField" required name="choname" value=""></td>
</tr>
<tr><td> </td></tr>
<tr><td> </td></tr>
<tr><td> </td></tr>
<tr><td> </td></tr>
<tr><td> </td></tr>
<tr><td> </td></tr>
<tr>
<td align=left><b>Your Email Address</b><spr><FONT COLOR="#ff0000">*</spr></font><br/><font size="2">&nbsp&nbsp&nbsp How can we contact you?</font><br/><input type="text" class="textField" name="email" required value=""></td>
</tr>
<tr><td> </td></tr>
<tr><td> </td></tr>
<tr><td> </td></tr>
<tr><td> </td></tr>
<tr><td> </td></tr>
<tr><td> </td></tr>
<tr>
<td align=left><b>Your Age</b><spr><FONT COLOR="#ff0000">*</spr></font><br/><font size="2">&nbsp&nbsp&nbsp How old are you?</font><br/><select required name="age">
<option value="  " selected></option>
<option value="12">12</option>
<option value="13">13</option>
<option value="14">14</option>
<option value="15">15</option>
<option value="16">16</option>
<option value="17">17</option>
<option value="18">18</option>
<option value="19">19</option>
<option value="20">20</option>
<option value="21">21</option>
<option value="22">22</option>
<option value="23">23</option>
<option value="24">24</option>
<option value="25">25</option>
<option value="26">26</option>
<option value="27">27</option>
<option value="28">28</option>
<option value="29">29</option>
<option value="30">30+</option>
</select></td>
</tr>
<tr><td> </td></tr>
<tr><td> </td></tr>
<tr><td> </td></tr>
<tr><td> </td></tr>
<tr><td> </td></tr>
<tr><td> </td></tr>
<tr>
<td align=left><b>Your Location</b><spr><FONT COLOR="#ff0000">*</spr></font><br/><font size="2">&nbsp&nbsp&nbsp Where are you from?</font><br/><select required name="country">
<option value="  " selected></option>
<option value="Australia">Australia</option>
<option value="Cananda">Canada</option>
<option value="Germany">Germany</option>
<option value="India">India</option>
<option value="New Zealand">New Zealand</option>
<option value="United Kingdom">United Kingdom</option>
<option value="United States of America">United States</option>
<option value="Other">Other</option></td>
</select>
</tr>
<tr><td> </td></tr>
<tr><td> </td></tr>
<tr><td> </td></tr>
<tr><td> </td></tr>
<tr><td> </td></tr>
<tr><td> </td></tr>
<tr>
<td align=left><b>Your Daily Online Computer Usage</b><spr><FONT COLOR="#ff0000">*</spr></font><br/><font size="2">&nbsp&nbsp&nbsp How often are you online?</font><br/><select required name="hours">
<option value="  " selected></option>
<option value="1-2">1-2 hrs</option>
<option value="3-4">3-4 hrs</option>
<option value="5-6">5-6 hrs</option>
<option value="7-8">7-8 hrs</option>
<option value="9-10">9-10 hrs</option>
<option value="11+">11+ hrs</option>
</select></td>
</tr>
<tr><td> </td></tr>
<tr><td> </td></tr>
<tr><td> </td></tr>
<tr><td> </td></tr>
<tr><td> </td></tr>
<tr><td> </td></tr>
<tr>
<td align=left><b>Your Prior Experience</b><spr><FONT COLOR="#ff0000">*</spr></font><br/><font size="2">&nbsp&nbsp&nbsp What did you do in the past?</font><br/><textarea class="bigTextField" required name="experience" cols="30" rows="2" maxlength="500"></textarea><br></br></td>
</tr>
<tr>
<td align=left><b>Why We Should Hire You (500 characters or less)</b><spr><FONT COLOR="#ff0000">*</spr></font><br/><font size="2">&nbsp&nbsp&nbsp Why do you want this job?</font><br/><textarea required class="bigTextField" name="why" cols="30" rows="2" maxlength="500"></textarea><br></br></td>
</tr>
<tr>
<td align=left><b>Your Website</b><br/><font size="2">&nbsp&nbsp&nbsp Do you own a website?</font><br/><textarea class="bigTextField" name="website" cols="30" rows="2"></textarea></td>
</tr>
</table>
<input name="title" value="<?php echo $string; ?>" readonly hidden>
<br/><input type="submit" name="submit" value="Submit your application &rarr;"><br/></center><br/><br/>
<font align="right"><spr><FONT COLOR="#ff0000">*</spr></font><b>Required</b></font></font>
<br/><?php echo $check2['date']; ?><br/>
<?php } else { 
$error = "Rank does not exist"; 
echo "<h2>". $error."</h2>";
	}
} else {
$error = "Rank does not exist";
echo "<h2>". $error."</h2>";
}
?>
</div>
</div>
</body>
</html>