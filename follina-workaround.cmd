@echo off

setlocal

net session >NUL 2>&1

if %errorLevel% == 0 (
	echo File was run as administrator / with elevated permissions. > NUL
) else (
	echo File MUSST be executed with elevated privileges.
	goto :END
)

mkdir %SystemDrive%\FixIt 2> NUL

set LogFile=%SystemDrive%\FixIt\FixIt.log
set LockFile=%SystemDrive%\FixIt\_20220603_1

if exist %LockFile% goto :END

echo %DATE% %TIME% >> %LogFile%

call :RemoveKey HKCR\ms-msdt %SystemDrive%\FixIt\ms-msdt.reg
call :RemoveKey HKCR\search-ms %SystemDrive%\FixIt\search-ms.reg

:: Bugfix wrong registry key deleted
if exist %SystemDrive%\FixIt\ms-search.reg (
	echo %SystemRoot%\system32\reg.exe import %SystemDrive%\FixIt\ms-search.reg >> %LogFile%
	%SystemRoot%\system32\reg.exe import %SystemDrive%\FixIt\ms-search.reg 1>> %LogFile% 2>&1
	del %SystemDrive%\FixIt\ms-search.reg >> NUL
)

echo %DATE% %TIME% >> %LogFile%
echo. >> %LogFile%

copy /Y NUL %LockFile% 1> NUL 2> NUL

goto END

:::::::::::::::::::::::::::::::::::::::::::::::

:RemoveKey
	setlocal
	set key=%1
	set file=%2

    %SystemRoot%\system32\reg.exe query %key% 1>NUL 2> NUL
		 
	if %errorlevel% == 1 (
		echo Registry key %key% does not exist >> %LogFile%
		goto :EOF
	)

	if not exist %file% (
		echo %SystemRoot%\system32\reg.exe export %key% %file% >> %LogFile%
			 %SystemRoot%\system32\reg.exe export %key% %file% >> %LogFile% 2> NUL
	)
	
	if %errorLevel% == 0 (
		echo %SystemRoot%\system32\reg.exe delete %key% /f >> %LogFile%
			 %SystemRoot%\system32\reg.exe delete %key% /f 1>> %LogFile% 2>&1
	) else (
		echo Error exporting key %key% >> %LogFile%
	)

:: End of subroutine
goto :EOF


:END


