::[Bat To Exe Converter]
::
::YAwzoRdxOk+EWAjk
::fBw5plQjdCyDJH2L91c9LRVAX0SDMm/6NbAI/OH16Pm7l14YRt4bfZzQzrueHNMS7EDLZZMj6mwJpJpeWU4LKkD7N14Lu2tPuXKENcuZ/gvzQ16M9Bh+EmZ75w==
::YAwzuBVtJxjWCl3EqQJgSA==
::ZR4luwNxJguZRRnk
::Yhs/ulQjdFa5
::cxAkpRVqdFKZSDk=
::cBs/ulQjdF65
::ZR41oxFsdFKZSTk=
::eBoioBt6dFKZSDk=
::cRo6pxp7LAbNWATEpSI=
::egkzugNsPRvcWATEpSI=
::dAsiuh18IRvcCxnZtBJQ
::cRYluBh/LU+EWAjk
::YxY4rhs+aU+IeA==
::cxY6rQJ7JhzQF1fEqQJjZksaHUrQbjra
::ZQ05rAF9IBncCkqN+0xwdVsHAlTMbSXoVOR8
::ZQ05rAF9IAHYFVzEqQIDKR1RYxSHMsl0Zg==
::eg0/rx1wNQPfEVWB+kM9LVsJDDeDOm6VFrASpu3j6oo=
::fBEirQZwNQPfEVWB+kM9LVsJDDeDOm6VFrASpu3j6oo=
::cRolqwZ3JBvQF1fEqQIfOB5aDBaHMWSsB7cQ7aj/6vyOoUgOFPE+forXw9Q=
::dhA7uBVwLU+EWGqN5kslOylRSKZMXA==
::YQ03rBFzNR3SWATEx0siIQ5HfgGGnqXa
::dhAmsQZ3MwfNWATE100gMQldSwyWL8lzRudMubG77fPHkUQPXfcsSorfeHru
::ZQ0/vhVqMQ3MEVWAtB9wSA==
::Zg8zqx1/OA3MEVWAtB9wSA==
::dhA7pRFwIByZRRnk
::Zh4grVQjdCyDJH2L91c9LRVAX0SDMm/6NbAI/OH16Pm7l14YRt4bfZzQzrueHNMS7EDLZZMj6mwJpPgNCh53bhelIAosrA4=
::YB416Ek+ZG8=
::
::
::978f952a14a936cc963da21a135fa983
@echo off
setlocal
setlocal enabledelayedexpansion
:begin
cls
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