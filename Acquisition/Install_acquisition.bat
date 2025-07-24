@echo off
if %cd% neq C:\Windows\System32 (
	echo You need to run this installer as an Administrator
	pause
	exit
)

cd /D "%~dp0"
SETLOCAL ENABLEDELAYEDEXPANSION
for /F "tokens=1* delims==" %%a in (config_acquisition.ini) do (
    set "%%a=%%b"
)

echo =====================System Setup=======================
echo:

::format hard drive
set /P do_this_step="Format new hard drive, Letter: %drive_letter%, Name: %drive_name%? (y/n)"
if %do_this_step% equ y (
		echo Mount hard drive
		echo select disk 1 > format_drive.txt
		echo create partition primary>> format_drive.txt
		echo format fs=ntfs quick label="%drive_name%">> format_drive.txt
		echo assign letter=%drive_letter%>> format_drive.txt
		diskpart /s format_drive.txt
)

echo:
set /P do_this_step="Create D:\SmartSPIM_Data folder and set permissions? (y/n)"
if %do_this_step% equ y (
	mkdir %drive_letter%:\SmartSPIM_Data
	icacls %drive_letter%:\SmartSPIM_Data /grant Everyone:^(OI^)^(CI^)F /T
)

::create directories
REM if not exist %top_directory% mkdir %top_directory%
REM if not exist %install_files_directory% mkdir %install_files_directory%
REM icacls %top_directory% /grant Everyone:(RX) /T

::set admin username and password
echo:
set /P do_this_step="Set password for current user (%username%) to %admin_password%? (y/n)"
if %do_this_step% equ y (
	net user %username% %admin_password%
)

::set timezone automatically
echo:
set /P do_this_step="Enable location services and set timezone automatically? (y/n)"
if %do_this_step% equ y (
	reg add HKLM\SOFTWARE\Policies\Microsoft\Windows\AppPrivacy /v LetAppsAccessLocation /t REG_DWORD /d 1 /f
	reg add HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\tzautoupdate /v Start /t REG_DWORD /d 3 /f
	reg add HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\W32Time\Parameters
	sc config w32time start=auto
	sc start w32time
	w32tm /resync
)

::power and sleep settings
echo:
set /P do_this_step="Switch to High Performance power setting and never turn off monitor? (y/n)"
if %do_this_step% equ y (
	powercfg /setactive %high_performance_GUID%
	powercfg /change monitor-timeout-ac 0
	powercfg /change standby-timeout-ac 0
	powercfg /change hibernate-timeout-ac 0
)

REM ::map network drive and save auto-reconnect script
REM set script_text=net use %reconnect_drive%: \\%reconnect_ip_address%\%reconnect_drive% /user:%reconnect_user% %reconnect_password% /persistent:yes
REM %script_text%
REM echo %script_text% > "%reconnect_directory%\%reconnect_name%"

:: configure ethernet
echo:
set /P do_this_step="Configure static IP address for %adapter_name%, address: %ip_address%, subnet: %subnet_mask%, default gateway: %default_gateway%? (y/n)"
if %do_this_step% equ y (
	netsh interface ip set address name=%adapter_name% static %ip_address% %subnet_mask% %default_gateway%
)

:: set wallpaper
echo:
set /P do_this_step="Set background image to %wallpaper_image? (y/n)"
if %do_this_step% equ y (
	WallP 0 %wallpaper_image%
)


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