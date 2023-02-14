<?php

function runAndBuild(){
   system('ant build-all');
   system('/etc/init.d/red5 restart');
}

?>