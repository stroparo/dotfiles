@echo OFF
echo Cygwin installation automated
CD %~dp0

SETLOCAL
set CYGCATS=archive,base,utils
set CYGSETUP=%CD%\setup-x86_64.exe
set SITE=http://mirrors.kernel.org/sourceware/cygwin/
rem set SITE=http://linorg.usp.br/cygwin/
rem set SITE=http://cygwin.osuosl.org/
set LOCALDIR=%LOCALAPPDATA%/cygwin
set ROOTDIR=C:/cygwin64

if exist %CYGSETUP% goto OKSETUP
powershell -Command "Import-Module BitsTransfer; Start-BitsTransfer http://cygwin.com/setup-x86_64.exe %CD%\setup-x86_64.exe"
if exist %CYGSETUP% goto OKSETUP
echo "Aborted as there is no setup-x86_64.exe neither could it be downloaded."
pause
exit 1
:OKSETUP

echo Cygwin installation started..

rem %CYGSETUP% -q -v -a x86_64 -d -g -o -Y -O -s %SITE% -l "%LOCALDIR%" -R "%ROOTDIR%" -C %CYGCATS%
rem echo Categories just installed: %CYGCATS%
rem pause

%CYGSETUP% -q -v -a x86_64 -l "%LOCALDIR%" -R "%ROOTDIR%" -P bashdb,bash-completion,checkbashisms -P perl,python,python3,zsh -P p7zip -P unzip,zip
%CYGSETUP% -q -v -a x86_64 -l "%LOCALDIR%" -R "%ROOTDIR%" -P curl,ping,rsync -P lftp -P wget,whois,wput
%CYGSETUP% -q -v -a x86_64 -l "%LOCALDIR%" -R "%ROOTDIR%" -P mosh -P the_silver_searcher -P tmux
%CYGSETUP% -q -v -a x86_64 -l "%LOCALDIR%" -R "%ROOTDIR%" -P git -P git-completion

echo.
echo Cygwin installation complete

ENDLOCAL

pause
exit /B 0

