cd /D "%~dp0"

SETLOCAL ENABLEDELAYEDEXPANSION

for /F "tokens=1* delims==" %%a in (config.ini) do (
    set "%%a=%%b"
)

::format S: Drive if necessary
diskpart /s diskpart_check.txt > disk_output.txt
findstr /C:"TB" disk_output.txt >nul
@REM del disk_output.txt
if %errorlevel% equ 1 (
    echo format disk
    diskpart /s create_partition.txt
    mkdir S:\SmartSPIM_Data
    icacls S:\SmartSPIM_Data /grant Everyone:(RX) /T
) else (
    echo do not format disk
)

::create directories
if not exist %top_directory% mkdir %top_directory%
if not exist %install_files_directory% mkdir %install_files_directory%
icacls %top_directory% /grant Everyone:(RX) /T

::set admin username and password
net user %admin_user% %admin_password%

::set timezone automatically
reg add HKLM\SOFTWARE\Policies\Microsoft\Windows\AppPrivacy /v LetAppsAccessLocation /t REG_DWORD /d 1 /f
reg add HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\tzautoupdate /v Start /t REG_DWORD /d 3 /f

::power and sleep settings
powercfg /setactive %high_performance_GUID%
powercfg /change monitor-timeout-ac 0
powercfg /change standby-timeout-ac 0
powercfg /change hibernate-timeout-ac 0

::map network drive and save auto-reconnect script
set script_text=net use %reconnect_drive%: \\%reconnect_ip_address%\%reconnect_drive% /user:%reconnect_user% %reconnect_password% /persistent:yes
%script_text%
echo %script_text% > "%reconnect_directory%\%reconnect_name%"

:: configure ethernet
netsh interface ip set address name=%adapter_name% static %ip_address% %subnet_mask% %default_gateway%

:: set wallpaper
WallP 0 %wallpaper_image%

::download files (and automated installs)
curl -L -O %anaconda_file%%anaconda_url%
curl -L -O %imagej_url%%imagej_file%
curl -L -O %imaris_url%%imaris_file%
curl -L -O %destripe_url%%destripe_file%
curl -L -O %stitch_url%%stitch_file%

tar -xzvf %destripe_file% -C %top_directory%
del %destripe_file%
tar -xzvf %stitch_file% -C %top_directory%
del %stitch_file%

if not exist %install_files_directory%\Fiji.app tar -xzvf %imagej_file% -C %install_files_directory%
del %imagej_file%
mklink C:\Users\Public\Desktop\ImageJ %install_files_directory%\Fiji.app\ImageJ-win64.exe

echo Installing Anaconda...
start /wait "" Anaconda3-2020.11-Windows-x86_64.exe /InstallationType=AllUsers AddToPath=1 /RegisterPython=1 /S /D=C:\ProgramData\Anaconda3

call %top_directory%\destripe_v6-master\install.bat
cd /D "%~dp0"


::supervised installs
start /wait AnyDesk.exe
start /wait ChromeSetup.exe

call %top_directory%\Stitching-main\install.bat
cd /D "%~dp0"

@ENDLOCAL
pause