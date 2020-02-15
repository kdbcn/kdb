@echo off
rem 切换到本文件所在盘符，如：  d:
%~d0
rem 进入本文件所在目录，如： cd d:\tick
cd %~dp0
rem 设置QHOME，其中%~dp0 为当前批处理文件的路径。
set QHOME=%~dp0q
set SSL_VERIFY_SERVER=NO
start "5001" %QHOME%\w32\q.exe -p 5001 -U %QHOME%\qusers


