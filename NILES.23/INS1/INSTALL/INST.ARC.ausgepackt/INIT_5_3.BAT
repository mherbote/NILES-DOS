ECHO ÿ
ECHO         TABELLENKALKULATIONS - PAKET mit MULTIPLAN
ECHO                       ...
ECHO ÿ
ASK "       QUELL-LAUFWERK WŽHLEN (A/B) : ",abx
IF ERRORLEVEL 3 GOTO uninst
IF ERRORLEVEL 2 inst_mul B
IF ERRORLEVEL 1 inst_mul A

:uninst
init_5 nul
