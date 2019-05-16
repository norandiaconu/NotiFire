@echo off
set notify=false

:checkTime
For /f "tokens=1-2 delims=/:" %%a in ("%TIME%") do (set mytime=%%a%%b)
if %mytime%==1115 set notify=true
if %mytime%==1445 set notify=true
if %notify%==false goto wait
set notify==false

PowerShell -NoProfile -ExecutionPolicy Bypass -Command "& '%~dpn0.ps1' %mytime%"
timeout 5
goto checkTime
exit /b

:wait
timeout 5
goto checkTime
