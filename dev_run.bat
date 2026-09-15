@echo off
title HR System - Flutter Dev
set PATH=D:\SDK\flutter\bin\mingit\cmd;D:\SDK\flutter\bin;C:\Windows\System32;C:\Windows\System32\Wbem;%PATH%
cd /d D:\HR\system_hr
echo Starting HR System (hot reload ready)...
echo.
echo  r  = Hot Reload  (fast, keeps state)
echo  R  = Hot Restart (clears state)
echo  q  = Quit
echo.
"D:\SDK\flutter\bin\flutter.bat" run -d windows
pause
