ECHO ÿ
ECHO         TEXTVERARBEITUNGS - PAKET mit WORDSTAR 4.0 EXTRA
ECHO                       ...
ECHO ÿ
ASK "       QUELL-LAUFWERK WŽHLEN (A/B) : ",abx
IF ERRORLEVEL 3 GOTO uninst
IF ERRORLEVEL 2 inst_wse B
IF ERRORLEVEL 1 inst_wse A

:uninst
init_4 nul
