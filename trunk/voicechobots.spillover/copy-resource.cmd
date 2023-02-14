set folder=%1
if not exist %folder%\flash-resources goto end
if not exist bin\resources\%folder% md bin\resources\%folder%
if exist %folder%\flash-resources\*.xml xcopy /d /y %folder%\flash-resources\*.xml bin\resources\%folder%\
if exist %folder%\flash-resources\*.swf xcopy /d /y %folder%\flash-resources\*.swf bin\resources\%folder%\
if exist %folder%\flash-resources\*.jpg xcopy /d /y %folder%\flash-resources\*.jpg bin\resources\%folder%\
if exist %folder%\flash-resources\*.png xcopy /d /y %folder%\flash-resources\*.png bin\resources\%folder%\
if exist %folder%\flash-resources\*.gif xcopy /d /y %folder%\flash-resources\*.gif bin\resources\%folder%\
if exist %folder%\flash-resources\*.mp3 xcopy /d /y %folder%\flash-resources\*.mp3 bin\resources\%folder%\
:end