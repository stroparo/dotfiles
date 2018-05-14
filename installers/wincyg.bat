@ECHO OFF
ECHO Cygwin installation automated
CD %~dp0

SETLOCAL
SET CYGCATS=archive,base,utils
SET CYGSETUP=%CD%\setup-x86_64.exe
SET SITE=http://mirrors.kernel.org/sourceware/cygwin/
rem SET SITE=http://linorg.usp.br/cygwin/
rem SET SITE=http://cygwin.osuosl.org/
SET LOCALDIR=%LOCALAPPDATA%/cygwin
SET ROOTDIR=C:/cygwin64

if exist %CYGSETUP% goto OKSETUP
powershell -Command "Import-Module BitsTransfer; Start-BitsTransfer http://cygwin.com/setup-x86_64.exe %CD%\setup-x86_64.exe"
if exist %CYGSETUP% goto OKSETUP
echo "Aborted as there is no setup-x86_64.exe neither could it be downloaded."
PAUSE
exit 1
:OKSETUP

ECHO INSTALLING PACKAGES..

rem %CYGSETUP% -q -v -a x86_64 -d -g -o -Y -O -s %SITE% -l "%LOCALDIR%" -R "%ROOTDIR%" -C %CYGCATS%
rem ECHO Categories just installed: %CYGCATS%
rem PAUSE

%CYGSETUP% -q -v -a x86_64 -l "%LOCALDIR%" -R "%ROOTDIR%" -P bashdb,bash-completion,checkbashisms -P perl,python,python3,zsh -P p7zip -P unzip,zip
%CYGSETUP% -q -v -a x86_64 -l "%LOCALDIR%" -R "%ROOTDIR%" -P curl,ping,rsync -P lftp -P wget,whois,wput
%CYGSETUP% -q -v -a x86_64 -l "%LOCALDIR%" -R "%ROOTDIR%" -P mosh -P the_silver_searcher -P tmux
%CYGSETUP% -q -v -a x86_64 -l "%LOCALDIR%" -R "%ROOTDIR%" -P git -P git-completion

ECHO.
ECHO Cygwin installation complete
ENDLOCAL
PAUSE
EXIT /B 0

