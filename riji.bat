@echo off
set d=%date:~0,4%-%date:~5,2%-%date:~8,2%
set fname=%d%.md
echo --->>%fname%
echo 标题  >>%fname%
chcp 65001
echo %d% %date:~0,2%>>%fname%
echo 天气：日记  >>%fname%
echo --->>%fname%
echo emsp>>%fname%
