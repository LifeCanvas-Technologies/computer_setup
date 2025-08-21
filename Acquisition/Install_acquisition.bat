@echo off
if /I %cd% neq C:\Windows\System32 (
	echo You need to run this installer as an Administrator
	pause
	exit
)

cd /D "%~dp0"
SETLOCAL ENABLEDELAYEDEXPANSION
for /F "tokens=1* delims==" %%a in (config_acquisition.ini) do (
    set "%%a=%%b"
)

REM echo =====================System Setup=======================
REM echo:

REM ::format hard drive
REM REM set /P do_this_step="Format new hard drive, Letter: %drive_letter%, Name: %drive_name%? (y/n)"
REM REM if %do_this_step% equ y (
		REM REM echo Mount hard drive
		REM REM echo select disk 1 > format_drive.txt
		REM REM echo create partition primary>> format_drive.txt
		REM REM echo format fs=ntfs quick label="%drive_name%">> format_drive.txt
		REM REM echo assign letter=%drive_letter%>> format_drive.txt
		REM REM diskpart /s format_drive.txt
REM REM )

REM REM echo:
REM REM set /P do_this_step="Create D:\SmartSPIM_Data folder and set permissions? (y/n)"
REM REM if %do_this_step% equ y (
	REM REM mkdir %drive_letter%:\SmartSPIM_Data
	REM REM icacls %drive_letter%:\SmartSPIM_Data /grant Everyone:^(OI^)^(CI^)F /T
REM REM )

REM ::create directories
REM REM if not exist %top_directory% mkdir %top_directory%
REM REM if not exist %install_files_directory% mkdir %install_files_directory%
REM REM icacls %top_directory% /grant Everyone:(RX) /T

REM ::set admin username and password
REM echo:
REM set /P do_this_step="Set password for current user (%username%) to %admin_password%? (y/n)"
REM if %do_this_step% equ y (
	REM net user %username% %admin_password%
REM )

REM ::set timezone automatically
REM echo:
REM set /P do_this_step="Enable location services and set timezone automatically? (y/n)"
REM if %do_this_step% equ y (
	REM reg add HKLM\SOFTWARE\Policies\Microsoft\Windows\AppPrivacy /v LetAppsAccessLocation /t REG_DWORD /d 1 /f
	REM reg add HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\tzautoupdate /v Start /t REG_DWORD /d 3 /f
	REM reg add HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\W32Time\Parameters
	REM sc config w32time start=auto
	REM sc start w32time
	REM w32tm /resync
REM )

REM ::power and sleep settings
REM echo:
REM set /P do_this_step="Switch to High Performance power setting and never turn off monitor? (y/n)"
REM if %do_this_step% equ y (
	REM powercfg /setactive %high_performance_GUID%
	REM powercfg /change monitor-timeout-ac 0
	REM powercfg /change standby-timeout-ac 0
	REM powercfg /change hibernate-timeout-ac 0
REM )

REM REM ::map network drive and save auto-reconnect script
REM REM set script_text=net use %reconnect_drive%: \\%reconnect_ip_address%\%reconnect_drive% /user:%reconnect_user% %reconnect_password% /persistent:yes
REM REM %script_text%
REM REM echo %script_text% > "%reconnect_directory%\%reconnect_name%"

REM :: configure ethernet
REM echo:
REM set /P do_this_step="Configure static IP address for %adapter_name%, address: %ip_address%, subnet: %subnet_mask%, default gateway: %default_gateway%? (y/n)"
REM if %do_this_step% equ y (
	REM netsh interface ip set address name=%adapter_name% static %ip_address% %subnet_mask% %default_gateway%
REM )

REM :: set wallpaper
REM echo:
REM set /P do_this_step="Set background image to %wallpaper_image%? (y/n)"
REM if %do_this_step% equ y (
	REM WallP 0 %wallpaper_image%
REM )

REM :: Create LCT Directory
REM echo:
REM set /P do_this_step="Create %top_directory%% and set permissions? (y/n)"
REM if %do_this_step% equ y (
	REM mkdir %top_directory%%
	REM icacls %top_directory%% /grant Everyone:^(OI^)^(CI^)F /T
REM )

REM echo =====================Downloads=======================
REM echo:
REM set /P do_this_step="Download installation files? (y/n)"
REM if %do_this_step% equ y (
	REM curl -L %install_files_url%%install_files_id% -o %install_files_temp%
	REM tar -xzvf %install_files_temp% -C %top_directory%
	REM del %outfile%
	
	REM mklink C:\Users\Public\Desktop\ImageJ %install_files_directory%\Fiji.app\ImageJ-win64.exe
REM )

REM echo =====================Installation=======================
REM echo:
REM echo Install the following utility applications:
REM echo CP210xVCPInstaller_x64
REM echo DCAM-API for Windows (25.2.6927)
REM echo Optotune_Cockpit_1.0.9181
REM echo Coherent_Connection_Setup_v4.0.1.2
REM echo DotNetFX
REM echo Vortran Stradus Laser
REM echo HCImageLive_x64
REM echo mightyZAPTotalManager0.9.11_x64
REM echo VC_redist.x64
REM echo vcredist_x64
REM set /P do_this_step="(y/n)"
REM if %do_this_step% equ y (
cd /D %install_files_directory%
	REM start /wait CP210x_Universal_Windows_Driver\CP210xVCPInstaller_x64.exe
	REM cd "DCAM-API for Windows (25.2.6927)"
	REM start /wait Setup.exe
	REM cd /D %install_files_directory%
	REM start /wait msiexec.exe /i "Optotune cockpit.msi"
	REM cd /D "Vortran - 4 line\DotNetFX"
	REM start /wait dotnetfx.exe
	REM cd /D %install_files_directory%
	REM cd /D "Vortran - 4 line"
	REM start /wait msiexec.exe /i "Setup.msi"
	REM start /wait Coherent_Connection_Setup_v4.0.1.2.exe
	REM start /wait "HCImageLive_x64 461 Install.exe"
	REM start /wait "mightyZAPTotalManager0.9.11_x64.exe"
	REM start /wait VC_redist.x64.exe
	REM start /wait vcredist_x64.exe	
REM )

REM echo Install the following National Instruments applications:
REM echo ni-labview-2023-runtime-engine_23.3_online
REM echo ni-visa_20.0_online_repack2
REM echo ni-vision-runtime_23.0_online
REM set /P do_this_step="(y/n)"
REM if %do_this_step% equ y (
	REM echo "National Instruments Serial Number: B04P13401"
	REM start /wait ni-labview-2023-runtime-engine_23.3_online.exe
	REM start /wait ni-visa_20.0_online_repack2.exe
	REM start /wait ni-vision-runtime_23.0_online.exe
REM )

@echo on
set /P do_this_step="Install SmartSPIM 6? (y/n)"
if %do_this_step% equ y (
	cd /D "%~dp0"
	echo %smartspim_folder%
	xcopy %smartspim_folder% "C:\ProgramData\SmartSPIM 6" /E /I /H /K /Y
	REM start /wait smartspim_6.0.0-86_windows_x64.nipkg
)


@ENDLOCAL
pause