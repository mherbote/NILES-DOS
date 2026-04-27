ECHO ÿ
ECHO         PROLOG - PAKET mit TURBO PROLOG
ECHO                       ...
ECHO ÿ
ASK "       QUELL-LAUFWERK WŽHLEN (A/B) : ",abx
IF ERRORLEVEL 3 GOTO uninst
IF ERRORLEVEL 2 inst_pro B
IF ERRORLEVEL 1 inst_pro A

:uninst
init_1 nul
