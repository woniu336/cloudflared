@echo off
setlocal enabledelayedexpansion

:: ���� 2: ������Ŀ¼
mkdir C:\Cloudflared\bin

:: ���� 3: ���Ʋ������� cloudflared.exe (ʹ�õ�ǰ·��)
copy "cloudflared.exe" C:\Cloudflared\bin\cloudflared.exe

:: ���� 4: �Թ���Ա��ݴ� CMD ��ת�� C:\Cloudflared\bin
powershell -command "Start-Process cmd -ArgumentList '/c cd /d C:\Cloudflared\bin' -Verb RunAs"

:: ���� 5: ��װ cloudflared
cloudflared.exe service install

:: ���� 6: ��¼����֤ cloudflared
cloudflared.exe tunnel login

:: ��ʾ�û���֤�ɹ�
echo Cloudflared ��֤�ɹ���

:: ���� 7: �����������
set /p TunnelName=�������������: 

:: ���� 8: ���� cloudflared tunnel create ����
cloudflared tunnel create %TunnelName%

:: ���� 9: ��ʾ��������
set /p DomainName=�������������: 


:: ���� 10: ���� yml �����ļ� 
set /p PortNumber=������˿ں�: 

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

:: �������������ɵ� JSON �ļ�Ϊ�������
for /f %%F in ('dir /b /o:d "C:\Users\%USERNAME%\.cloudflared\*.json"') do (
    set "JsonFile=%%F"
)

ren "C:\Users\%USERNAME%\.cloudflared\!JsonFile!" "%TunnelName%.json"

:: ���� 11: ����·��

cloudflared tunnel route dns %TunnelName% %DomainName%

::  ���� 12:�������
cloudflared.exe tunnel --config "C:\Users\%USERNAME%\.cloudflared\%TunnelName%.yml" run

:: ����
exit
