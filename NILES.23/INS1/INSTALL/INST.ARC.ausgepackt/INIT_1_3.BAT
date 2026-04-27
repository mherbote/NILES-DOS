ECHO ÿ
ECHO         C - PAKET mit TURBO C bzw.
ECHO                       MICROSOFT C
ECHO ÿ
ASK "       QUELL-LAUFWERK WŽHLEN (A/B) ? ",abx
IF ERRORLEVEL 3 GOTO uninst
IF ERRORLEVEL 2 inst_ccc B
IF ERRORLEVEL 1 inst_ccc A

:uninst
init_1 nul
