@echo off
setlocal enabledelayedexpansion

:: ���� 4: �Թ���Ա��ݴ� CMD ��ת�� C:\Cloudflared\bin
powershell -command "Start-Process cmd -ArgumentList '/c cd /d C:\Cloudflared\bin' -Verb RunAs"

:: ���� 2: �г��������ȡ����
echo �������
set /a TunnelIndex=0
for /f "skip=2 tokens=2" %%A in ('cloudflared tunnel list') do (
    set /a TunnelIndex+=1
    set "TunnelName[!TunnelIndex!]=%%A"
    echo !TunnelIndex!: %%A
)

:: ���� 3: ��ʾ�û�ѡ�����
set /p TunnelChoice=��ѡ��Ҫ������������������֣�: 

:: ���� 4: ��ȡѡ�����������
if !TunnelChoice! geq 1 (
    set "TunnelName=!TunnelName[%TunnelChoice%]!"
    goto :StartTunnel
) else (
    echo ��Ч��ѡ�������ѡ��
    pause
    goto :Menu
)

:StartTunnel
:: ���� 5: ��ʾ�û��Ƿ�����ѡ�������
set /p StartTunnel=�Ƿ�������� "%TunnelName%"��������Y��N��: 
if /i "%StartTunnel%"=="Y" (
    cloudflared tunnel --config "C:\Users\%USERNAME%\.cloudflared\%TunnelName%.yml" run
) else (
    echo ȡ��������� "%TunnelName%"
)

:: ����
exit
