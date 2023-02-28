<?php
function sec_session_start() {
        $session_name = 'sec_session_id'; // Set a custom session name
        $secure = false; // Set to true if using https.
        $httponly = true; // This stops javascript being able to access the session id. 
 
        ini_set('session.use_only_cookies', 1); // Forces sessions to only use cookies. 
        $cookieParams = session_get_cookie_params(); // Gets current cookies params.
        session_set_cookie_params($cookieParams["lifetime"], $cookieParams["path"], $cookieParams["domain"], $secure, $httponly); 
        session_name($session_name); // Sets the session name to the one set above.
        session_start(); // Start the php session
        session_regenerate_id(); // regenerated the session, delete the old one.  
}

function login($login, $password, $mysqli) {
   // Using prepared Statements means that SQL injection is not possible. 
   if ($stmt = $mysqli->prepare("SELECT id, login, password, deleted FROM User WHERE login = ? LIMIT 1")) { 
      $stmt->bind_param('s', $login);
      $stmt->execute();
      $stmt->store_result();
      $stmt->bind_result($user_id, $login, $db_password, $deleted); // get variables from result.
      $stmt->fetch();
	
      $passw = strtr(base64_encode(md5($password, true)), '+/', '-');

      if($stmt->num_rows == 1 && $deleted == '000') { // If the user exists
	if(checkbrute($user_id, $mysqli) == true) { 
            return false;
         } else {
         if($db_password == $passw) { // Check if the password in the database matches the password the user submitted. 
            	// Password is correct! 
               $user_browser = $_SERVER['HTTP_USER_AGENT']; // Get the user-agent string of the user.
               $user_id = preg_replace("/[^0-9]+/", "", $user_id); // XSS protection as we might print this value
               $_SESSION['user_id'] = $user_id; 
               $login = preg_replace("/[^a-zA-Z0-9_\-]+/", "", $login); // XSS protection as we might print this value
               $_SESSION['login'] = $login;
               $_SESSION['login_string'] = $passw.$user_browser;
                return true;    
         } else {
                        // Password is not correct
            // We record this attempt in the database
            $now = time();
            $stmt = $mysqli->prepare("INSERT INTO login_attempts (user_id, time, login) VALUES (?, ?, ?)");
            $stmt->bind_param('iis', $user_id, $now, $login);
            $stmt->execute();
            return false;
         }
      }
      } else {
         return false;
      }
   }
}

function baned($login, $mysqli) {
   // Using prepared Statements means that SQL injection is not possible. 
   if ($stmt = $mysqli->prepare("SELECT baned FROM User WHERE login = ? LIMIT 1")) { 
      $stmt->bind_param('s', $login);
      $stmt->execute();
      $stmt->store_result();
      $stmt->bind_result($baned); // get variables from result.
      $stmt->fetch();

	if($baned == '0') {
		return true;
	} else { return false; }
   }
}

function checkbrute($user_id, $mysqli) {
   // Get timestamp of current time
   $now = time();
   // All login attempts are counted from the past 2 hours. 
   $valid_attempts = $now - (2 * 60 * 60); 
 
   $stmt = $mysqli->prepare("SELECT time FROM login_attempts WHERE user_id = ? AND time > ?");
   $stmt->bind_param('ii', $user_id, $valid_attempts);
   $stmt->execute();
   $stmt->store_result();
 
   if($stmt->num_rows > 5) {
      return true;
   } else {
      return false;
   }
}

function login_check($mysqli) {
   // Check if all session variables are set
   if(isset($_SESSION['user_id'], $_SESSION['login'], $_SESSION['login_string'])) {
     $user_id = $_SESSION['user_id'];
     $login_string = $_SESSION['login_string'];
     $login = $_SESSION['login'];
 
     $user_browser = $_SERVER['HTTP_USER_AGENT']; // Get the user-agent string of the user.
 
     $stmt = $mysqli->prepare("SELECT password FROM User WHERE id = ? LIMIT 1");
     $stmt->bind_param('i', $user_id);
     $stmt->execute();
     $stmt->store_result();
 
     if($stmt->num_rows == 1) { // If the user exists
        $stmt->bind_result($password); // get variables from result.
        $stmt->fetch();
        $login_check = $password.$user_browser;
        if($login_check == $login_string) {
           // Logged In!!!!
           return true;
        } else {
           // Not logged in
           return false;
        }
     } else {
        // Not logged in
        return false;
     }
   } else {
     // Not logged in
     return false;
   }
}
