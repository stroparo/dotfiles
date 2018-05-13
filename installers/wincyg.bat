@ECHO OFF
ECHO Cygwin installation automated
CD %~dp0

SETLOCAL
SET CYGCATS=archive,base,utils
SET CYGPKGS=%CYGPKGS% mintty bash bashdb bash-completion checkbashisms perl python python3 zsh p7zip unzip zip curl git git-completion lftp mosh ping rsync the_silver_searcher tmux vim vim-common wget whois wput
SET CYGSETUP=%CD%\setup-x86.exe
SET SITE=http://linorg.usp.br/cygwin/
SET LOCALDIR=%LOCALAPPDATA%/cygwin
SET ROOTDIR=C:/cygwin

if exist %CYGSETUP% goto OKSETUP
powershell -Command "Import-Module BitsTransfer; Start-BitsTransfer http://cygwin.com/setup-x86.exe %CD%\setup-x86.exe"
if exist %CYGSETUP% goto OKSETUP
echo "Aborted as there is no setup-x86.exe neither could it be downloaded."
PAUSE
exit 1
:OKSETUP

ECHO INSTALLING PACKAGES..
%CYGSETUP% -q -v -a x86 -d -g -o -Y -O -s %SITE% -l "%LOCALDIR%" -R "%ROOTDIR%" -P %CYGPKGS% -C %CYGCATS%

ECHO.
ECHO Cygwin installation updated
ECHO.
ECHO Categories: %CYGCATS%
ECHO.
ECHO Packages: %CYGPKGS%

ENDLOCAL
PAUSE
EXIT /B 0

