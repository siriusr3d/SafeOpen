@echo off
setlocal
setlocal enabledelayedexpansion
:begin
cls

TITLE USBSafeOpen v1.0

call :banner

echo,&&echo,&&echo 			checking for removable drives. . .

for /F "tokens=4 USEBACKQ" %%a in (`ver`) do (
	for /f "tokens=1 delims=. USEBACKQ" %%v in ('%%a') do set ver=%%v 
)

if %ver% lss 6 goto winxp
if %ver% geq 6 goto vistawin7

:winxp
set usb=5C003F003F005C00530054004F0052004100470045002300520065006D006F007600610062006C0065004D0065006400690061
set cnt=1
for %%a in (D E F G H I J K L M N O P Q R S T U V X Y Z) do (
	for /f "tokens=1,3 USEBACKQ" %%x in (`reg query "HKLM\System\MountedDevices" ^| find "\DosDevices\%%a:"`) do (
		call set dataA=%%x
		call set dataB=%%y
		call set drvltr=!dataA:~12,2!
		call set chk=!dataB:~0,102!
		if exist !drvltr! (
			set ad^!cnt!=!drvltr!
			set rmd^!cnt!=!chk!
			set /a cnt+=1
		)
	)
)
:open
cls
call :banner
set /a cnt-=1
set flg=0
set opt=1
for /l %%b in (1,1,!cnt!) do (
	if !rmd%%b!==%usb% (
		set drvno!opt!=%%b
		set /a flg+=1
		call :volname !ad%%b! !opt!
		set /a opt+=1
	)
)
set /a opt-=1
if %flg%==0 goto rescan
if %flg%==1 start !ad%opt%! && goto end
if not %flg%==1 echo a. all drives && echo q. quit && set /p rr=Select a drive to open: 
if "%rr%" equ "q" goto end
if "%rr%" equ "a" (
	for /L %%a in (1,1,!opt!) do ( start !ad%%a! )
	goto end
)
if %rr% gtr %opt% (
	echo Invalid option selected. Select a correct drive option.
	pause
	set /a cnt+=1
	goto open
)
start !ad%rr%!
goto end
:rescan
cls
echo,&&echo,
echo 	***************************************************************
echo 	*		No removable drives found. . .		      *
echo 	*	     Please insert a removable drive. . .	      *
echo 	***************************************************************
echo,&&echo,
set /p ch=To scan again enter s or enter q to quit: 
if %ch%==s goto begin
if %ch%==q goto end
if not %ch%==s if not %ch%==q goto rescan
:end
endlocal
endlocal
exit

:vistawin7
set usb=5F003F003F005F00550053004200530054004F00520023004400690073006B
set cnt=1
for %%a in (D E F G H I J K L M N O P Q R S T U V X Y Z) do (
	for /f "tokens=1,3 USEBACKQ" %%x in (`reg query HKLM\System\MountedDevices /F %usb% /S ^|find "\DosDevices\%%a:"`) do (
		call set dataA=%%x
		call set dataB=%%y
		call set drvltr=!dataA:~12,2!
		call set chk=!dataB:~0,62!
		if exist !drvltr! (
			set ad^!cnt!=!drvltr!
			set rmd^!cnt!=!chk!
			set /a cnt+=1
		)
	)
)
goto open

:volname
for /f "tokens=6 USEBACKQ" %%v in (`vol %1`) do echo %2. %1 Drive, "%%v"
goto :EOF

:banner
echo " ************************************************************************************* "
echo "	 _     _ ______ ______   ______          ___       _______                   	"
echo "	(_)   (_/ _____(____  \ / _____)        / __)     (_______)                  	"
echo "	 _     ( (____  ____)  ( (____  _____ _| |__ _____ _     _ ____  _____ ____  	"
echo "	| |   | \____ \|  __  ( \____ \(____ (_   __| ___ | |   | |  _ \| ___ |  _ \ 	"
echo "	| |___| _____) | |__)  )_____) / ___ | | |  | ____| |___| | |_| | ____| | | |	"
echo "	 \_____(______/|______/(______/\_____| |_|  |_____)\_____/|  __/|_____|_| |_|	"
echo "	                                                          |_|                	"
echo " ************************************************************************************* "
goto :EOF
