@echo off
:: Usage: run.bat [master^|worker] [MASTER_IP] [WORKER_IP]
set ROLE=%1
set MASTER_IP=%2
set WORKER_IP=%3

if "%ROLE%"=="master" (
    set MASTER_IP=%MASTER_IP%
    call master\deploy\windows.bat
) else if "%ROLE%"=="worker" (
    set MASTER_IP=%MASTER_IP%
    set WORKER_IP=%WORKER_IP%
    call worker\deploy\windows.bat
) else (
    echo Usage: run.bat [master^|worker] [MASTER_IP] [WORKER_IP]
)
