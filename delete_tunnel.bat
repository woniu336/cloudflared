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
    
    :: ���� 6: ɾ����ص�.json��.yml�ļ�
del "C:\Users\%USERNAME%\.cloudflared\%TunnelName%.json" /f /q
del "C:\Users\%USERNAME%\.cloudflared\%TunnelName%.yml" /f /q
echo ����ļ� "%TunnelName%.json" �� "%TunnelName%.yml" ��ɾ����
) else (
echo ȡ��ɾ����� "%TunnelName%"
)

:: ����
exit
