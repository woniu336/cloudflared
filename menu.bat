@echo off

:Menu
cls
echo ��ѡ�����:
echo 1: �������
echo 2: �������
echo 3: ɾ�����
echo 4: �˳�

set /p Choice=��ѡ��������������֣�: 

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
    echo ��Ч��ѡ�������ѡ��
    pause
    goto Menu
)
