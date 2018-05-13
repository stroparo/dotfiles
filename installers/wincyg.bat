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

%CYGSETUP% -q -v -a x86_64 -l "%LOCALDIR%" -R "%ROOTDIR%" -P curl
%CYGSETUP% -q -v -a x86_64 -l "%LOCALDIR%" -R "%ROOTDIR%" -P rsync
%CYGSETUP% -q -v -a x86_64 -l "%LOCALDIR%" -R "%ROOTDIR%" -P the_silver_searcher
%CYGSETUP% -q -v -a x86_64 -l "%LOCALDIR%" -R "%ROOTDIR%" -P tmux
%CYGSETUP% -q -v -a x86_64 -l "%LOCALDIR%" -R "%ROOTDIR%" -P p7zip
%CYGSETUP% -q -v -a x86_64 -l "%LOCALDIR%" -R "%ROOTDIR%" -P unzip
%CYGSETUP% -q -v -a x86_64 -l "%LOCALDIR%" -R "%ROOTDIR%" -P zip
%CYGSETUP% -q -v -a x86_64 -l "%LOCALDIR%" -R "%ROOTDIR%" -P bashdb
%CYGSETUP% -q -v -a x86_64 -l "%LOCALDIR%" -R "%ROOTDIR%" -P bash-completion
%CYGSETUP% -q -v -a x86_64 -l "%LOCALDIR%" -R "%ROOTDIR%" -P checkbashisms
%CYGSETUP% -q -v -a x86_64 -l "%LOCALDIR%" -R "%ROOTDIR%" -P git
%CYGSETUP% -q -v -a x86_64 -l "%LOCALDIR%" -R "%ROOTDIR%" -P git-completion
%CYGSETUP% -q -v -a x86_64 -l "%LOCALDIR%" -R "%ROOTDIR%" -P perl
%CYGSETUP% -q -v -a x86_64 -l "%LOCALDIR%" -R "%ROOTDIR%" -P python
%CYGSETUP% -q -v -a x86_64 -l "%LOCALDIR%" -R "%ROOTDIR%" -P python3
%CYGSETUP% -q -v -a x86_64 -l "%LOCALDIR%" -R "%ROOTDIR%" -P zsh
%CYGSETUP% -q -v -a x86_64 -l "%LOCALDIR%" -R "%ROOTDIR%" -P lftp
%CYGSETUP% -q -v -a x86_64 -l "%LOCALDIR%" -R "%ROOTDIR%" -P mosh
%CYGSETUP% -q -v -a x86_64 -l "%LOCALDIR%" -R "%ROOTDIR%" -P ping
%CYGSETUP% -q -v -a x86_64 -l "%LOCALDIR%" -R "%ROOTDIR%" -P wget
%CYGSETUP% -q -v -a x86_64 -l "%LOCALDIR%" -R "%ROOTDIR%" -P whois
%CYGSETUP% -q -v -a x86_64 -l "%LOCALDIR%" -R "%ROOTDIR%" -P wput

ECHO.
ECHO Cygwin installation updated
ECHO.
ECHO Categories: %CYGCATS%
ECHO.
ECHO Packages: %CYGPKGS%

ENDLOCAL
PAUSE
EXIT /B 0

