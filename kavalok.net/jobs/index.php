<!DOCTYPE HTML>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<title><?php echo $c_url; ?> - Jobs</title>
<link rel="stylesheet" href="panel.css" type="text/css" media="screen" title="no title" charset="utf-8">
<script type="text/rocketscript" data-rocketsrc="https://ajax.googleapis.com/ajax/libs/jquery/1.6.4/jquery.js"></script>
<script type="text/rocketscript" data-rocketsrc="https://ajax.googleapis.com/ajax/libs/jqueryui/1.8.16/jquery-ui.js"></script>
<script type="text/rocketscript" data-rocketsrc="transitions.js"></script>

</script>
</head>
<body>
<div id="top">
<h1><?php echo $c_url; ?> JOB APPLICATION</h1>
</div>
<div id="cont">
<a href="http://<?php echo $url; ?>" class="back">Return to <?php echo $c_url; ?></a>
<div id="areas">
<table align="center">
<tr>
<th colspan=2><h1>Current Openings</h1></th>
<tr>
<?php
$getdata = $mysqli->query("SELECT * FROM `jobs_available`");
if (mysqli_num_rows($getdata) >= 1) {
while($row = mysqli_fetch_array($getdata)) { 
if ($row['enabled'] == 'true') {
if($row['id'] != '4') { ?>
<td><a href="http://<?php echo $url; ?>/jobs/<?php echo htmlspecialchars($row['job']); ?>" class="areaButton"><b><?php echo htmlspecialchars($row['job']); ?></b><br/><font color=#ff0000 size="4"><?php echo htmlspecialchars($row['amount']); ?>  Openings</font></a></td>
<?php } else if($row['id'] == '4') { ?>

<tr><td><a href="http://<?php echo $url; ?>/jobs/<?php echo htmlspecialchars($row['job']); ?>" class="areaButton"><b><?php echo htmlspecialchars($row['job']); ?></b><br/><font color=#ff0000 size="4"><?php echo htmlspecialchars($row['amount']); ?> Openings</font></a></td></tr>

<?php } else if(($row['id'] >= 5) && ($row['id'] <= '6')) { ?>

<td><a href="http://<?php echo $url; ?>/jobs/<?php echo htmlspecialchars($row['job']); ?>" class="areaButton"><b><?php echo htmlspecialchars($row['job']); ?></b><br/><font color=#ff0000 size="4"><?php echo htmlspecialchars($row['amount']); ?> Openings</font></a></td>

<?php }}}} ?></tr></table>
</div>
</div>
</body>
</html>
