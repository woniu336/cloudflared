@echo off
setlocal enabledelayedexpansion

:: 步骤 2: 创建新目录
mkdir C:\Cloudflared\bin

:: 步骤 3: 复制并重命名 cloudflared.exe (使用当前路径)
copy "cloudflared.exe" C:\Cloudflared\bin\cloudflared.exe

:: 步骤 4: 以管理员身份打开 CMD 并转到 C:\Cloudflared\bin
powershell -command "Start-Process cmd -ArgumentList '/c cd /d C:\Cloudflared\bin' -Verb RunAs"

:: 步骤 5: 安装 cloudflared
cloudflared.exe service install

:: 步骤 6: 登录并验证 cloudflared
cloudflared.exe tunnel login

:: 提示用户验证成功
echo Cloudflared 验证成功。

:: 步骤 7: 创建隧道名称
set /p TunnelName=请输入隧道名称: 

:: 步骤 8: 运行 cloudflared tunnel create 命令
cloudflared tunnel create %TunnelName%

:: 步骤 9: 提示输入域名
set /p DomainName=请输入你的域名: 


:: 步骤 10: 创建 yml 配置文件 
set /p PortNumber=请输入端口号: 

(
echo tunnel: %TunnelName%
echo credentials-file: C:\Users\%USERNAME%\.cloudflared\%TunnelName%.json
echo.
echo ingress:
echo   - hostname: %DomainName%
echo     service: http://localhost:%PortNumber%
echo   - service: http_status:404
echo.
echo logfile: C:\Cloudflared\cloudflared.log
) > "C:\Users\%USERNAME%\.cloudflared\%TunnelName%.yml"

:: 重命名最新生成的 JSON 文件为隧道名称
for /f %%F in ('dir /b /o:d "C:\Users\%USERNAME%\.cloudflared\*.json"') do (
    set "JsonFile=%%F"
)

ren "C:\Users\%USERNAME%\.cloudflared\!JsonFile!" "%TunnelName%.json"

:: 步骤 11: 创建路由

cloudflared tunnel route dns %TunnelName% %DomainName%

::  步骤 12:启动隧道
cloudflared.exe tunnel --config "C:\Users\%USERNAME%\.cloudflared\%TunnelName%.yml" run

:: 结束
exit
