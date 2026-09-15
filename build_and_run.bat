@echo off
title Build and Run HR System
echo Building...
set PATH=D:\SDK\flutter\bin\mingit\cmd;D:\SDK\flutter\bin;%PATH%
call flutter build windows --debug
if errorlevel 1 (
    echo Build failed!
    pause
    exit /b 1
)
echo Starting app...
start "" "build\windows\x64\runner\Debug\system_hr.exe"
