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
set LockFile=%SystemDrive%\FixIt\_20220620

if exist %LockFile% goto :END

echo %DATE% %TIME% >> %LogFile%

call :RestoreKey %SystemDrive%\FixIt\ms-msdt.reg
call :RestoreKey %SystemDrive%\FixIt\search-ms.reg

echo %DATE% %TIME% >> %LogFile%
echo. >> %LogFile%

copy /Y NUL %LockFile% 1> NUL 2> NUL

goto END

:::::::::::::::::::::::::::::::::::::::::::::::

:RestoreKey
	setlocal
	set file=%1

	if exist %file% (
		echo %SystemRoot%\system32\reg.exe import %file% >> %LogFile%
			 %SystemRoot%\system32\reg.exe import %file% >> %LogFile% 2> NUL
	)

:: End of subroutine
goto :EOF


:END


