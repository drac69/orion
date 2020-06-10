set MPVDIR=C:\projects\mpv\%cc%\%platform%
setlocal enableextensions

if %platform%==x86 set mpv_platform=i686
if %platform%==x64 set mpv_platform=x86_64

if not exist %MPVDIR% mkdir %MPVDIR%
cd %MPVDIR%

if exist %MPVDIR%\mpv-1.dll goto :def
appveyor DownloadFile "https://downloads.sourceforge.net/project/mpv-player-windows/libmpv/mpv-dev-x86_64-20200607-git-12415db.7z?r=https%3A%2F%2Fsourceforge.net%2Fprojects%2Fmpv-player-windows%2Ffiles%2Flibmpv%2Fmpv-dev-x86_64-20200607-git-12415db.7z%2Fdownload&ts=1591817998" -FileName mpv-dev.7z
7z x -y mpv-dev.7z

:def
if exist %MPVDIR%\mpv.def goto :lib
appveyor DownloadFile "https://raw.githubusercontent.com/mpv-player/mpv/master/libmpv/mpv.def" -FileName mpv_dl.def
echo EXPORTS > mpv.def
type mpv_dl.def >> mpv.def

:lib
if exist %MPVDIR%\mpv.lib goto :install
lib /def:mpv.def /name:mpv-1.dll /out:mpv.lib /MACHINE:%platform%

:install
copy /y %MPVDIR%\mpv.lib %QTDIR%\lib\mpv.lib
copy /y %MPVDIR%\mpv-1.dll %QTDIR%\bin\mpv-1.dll
xcopy %MPVDIR%\include %QTDIR%\include\mpv /y /s /e /h /i