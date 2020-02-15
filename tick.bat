@echo off
rem 切换到本文件所在盘符，如：  d:
%~d0
rem 进入本文件所在目录，如： cd d:\kdb
cd %~dp0
set KX_VERIFY_SERVER=NO
set SSL_VERIFY_SERVER=NO

rem 设置QHOME，其中%~dp0 为当前批处理文件的路径。
set QHOME=%~dp0\q

rem tickerplant         sym指定schema文件为tick/sym.q ;        ./db指定log和hdb目录，可根据需要修改
start "tickerplant(5010)"  %QHOME%\w32\q.exe tick/tick.q sym -p 5010
ping 127.0.0.1 -n 1 -w 100 > nul

rem rdb   :5010 和 :5012 分别为tickerplant和hdb的端口
start "rdb(5011)"  %QHOME%\w32\q.exe tick/r.q :5010 :5012 -p 5011
ping 127.0.0.1 -n 1 -w 100 > nul

rem hdb
if not exist hdb md hdb
start "hdb(5012)" %~dp0\q\w32\q.exe hdb -p 5012 

rem 股票行情接口
start "csmd(5013)" %~dp0\q\w32\q.exe tick/csmd.q sym :5010 -p 5013

rem ctp期货行情接口
start "cfmd(5014)" %~dp0\q\w32\q.exe tick/cfmd.q sym :5010 -p 5014
cd %~dp0

