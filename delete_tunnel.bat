@echo off
setlocal enabledelayedexpansion

:: ���� 1: ����.cloudflaredĿ¼
cd C:\Users\%USERNAME%\.cloudflared

:: ���� 2: �г��������ȡ����
echo �������
set /a TunnelIndex=0
for /f "skip=2 tokens=2" %%A in ('cloudflared tunnel list') do (
    set /a TunnelIndex+=1
    set "TunnelName[!TunnelIndex!]=%%A"
    echo !TunnelIndex!: %%A
)

:: ���� 3: ��ʾ�û�ѡ��Ҫɾ�������
set /p TunnelChoice=��ѡ��Ҫɾ����������������֣�: 

:: ���� 4: ��ȡѡ�����������
if !TunnelChoice! geq 1 (
    set "TunnelName=!TunnelName[%TunnelChoice%]!"
    goto :DeleteTunnel
) else (
    echo ��Ч��ѡ�������ѡ��
    pause
    goto :Menu
)

:DeleteTunnel
:: ���� 5: ��ʾ�û��Ƿ�ɾ��ѡ�������
set /p DeleteTunnel=�Ƿ�ɾ����� "%TunnelName%"��������Y��N��: 
if /i "%DeleteTunnel%"=="Y" (
    cloudflared tunnel delete "%TunnelName%"
    echo ��� "%TunnelName%" ��ɾ����
) else (
    echo ȡ��ɾ����� "%TunnelName%"
)

:: ����
exit
