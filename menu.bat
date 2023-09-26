@echo off

:Menu
cls
echo 请选择操作:
echo 1: 创建隧道
echo 2: 启动隧道
echo 3: 删除隧道
echo 4: 退出

set /p Choice=请选择操作（输入数字）: 

if "%Choice%"=="1" (
    call create_tunnel.bat
    pause
    goto Menu
) else if "%Choice%"=="2" (
    call start_tunnel.bat
    pause
    goto Menu
) else if "%Choice%"=="3" (
    call delete_tunnel.bat
    pause
    goto Menu
) else if "%Choice%"=="4" (
    exit /b
) else (
    echo 无效的选项，请重新选择。
    pause
    goto Menu
)
