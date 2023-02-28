<?php
$RemoteService = str_replace(' ', '%20', $RemoteService);
$RemoteService = 'http://game.'.$url.':2834/kavalok/jsp/' . $RemoteService;
//print($RemoteService);
$curl_handle=curl_init();
curl_setopt($curl_handle, CURLOPT_URL,$RemoteService);
curl_setopt($curl_handle, CURLOPT_CONNECTTIMEOUT, 2);
curl_setopt($curl_handle, CURLOPT_RETURNTRANSFER, 1);
curl_setopt($curl_handle, CURLOPT_USERAGENT, 'AdminService');
curl_exec($curl_handle);
if (curl_errno($curl_handle)) {
	die(curl_error($curl_handle));
	//$mysqli->query("INSERT INTO `ClientError`(`created`, `message`, `updated`, `i`) VALUES ('$ip','".curl_error($curl_handle)."','0','$date')");
}
curl_close($curl_handle);
?>