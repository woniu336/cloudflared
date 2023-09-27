@echo off
setlocal enabledelayedexpansion

:: 步骤 4: 以管理员身份打开 CMD 并转到 C:\Cloudflared\bin
powershell -command "Start-Process cmd -ArgumentList '/c cd /d C:\Cloudflared\bin' -Verb RunAs"

:: 步骤 2: 列出隧道并提取名称
echo 隧道名称
set /a TunnelIndex=0
for /f "skip=2 tokens=2" %%A in ('cloudflared tunnel list') do (
    set /a TunnelIndex+=1
    set "TunnelName[!TunnelIndex!]=%%A"
    echo !TunnelIndex!: %%A
)

:: 步骤 3: 提示用户选择隧道
set /p TunnelChoice=请选择要启动的隧道（输入数字）: 

:: 步骤 4: 获取选定的隧道名称
if !TunnelChoice! geq 1 (
    set "TunnelName=!TunnelName[%TunnelChoice%]!"
    goto :StartTunnel
) else (
    echo 无效的选项，请重新选择。
    pause
    goto :Menu
)

:StartTunnel
:: 步骤 5: 提示用户是否启动选定的隧道
set /p StartTunnel=是否启动隧道 "%TunnelName%"？（输入Y或N）: 
if /i "%StartTunnel%"=="Y" (
    cloudflared tunnel --config "C:\Users\%USERNAME%\.cloudflared\%TunnelName%.yml" run
) else (
    echo 取消启动隧道 "%TunnelName%"
)

:: 结束
exit
