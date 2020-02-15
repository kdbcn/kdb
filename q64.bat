@echo off
rem 切换到本文件所在盘符，如：  d:
%~d0
rem 进入本文件所在目录，如： cd d:\kdb
cd %~dp0
set SSL_VERIFY_SERVER=NO
set KX_VERIFY_SERVER=NO
rem 设置QHOME，其中%~dp0 为当前批处理文件的路径。
set QHOME=%~dp0q
start "5002" %QHOME%\w64\q.exe -p 5002


