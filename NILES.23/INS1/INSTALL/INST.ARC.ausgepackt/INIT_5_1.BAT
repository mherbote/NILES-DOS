ECHO ÿ
ECHO         TABELLENKALKULATIONS - PAKET mit SUPERCALC 4.0
ECHO                       ...
ECHO ÿ
ASK "       QUELL-LAUFWERK WŽHLEN (A/B) : ",abx
IF ERRORLEVEL 3 GOTO uninst
IF ERRORLEVEL 2 inst_sc4 B
IF ERRORLEVEL 1 inst_sc4 A

:uninst
init_5 nul
