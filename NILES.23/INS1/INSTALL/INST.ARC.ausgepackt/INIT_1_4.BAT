ECHO ÿ
ECHO         FORTH - PAKET mit NILES FORTH
ECHO                       ...
ECHO ÿ
ASK "       QUELL-LAUFWERK WŽHLEN (A/B) ? ",abx
IF ERRORLEVEL 3 GOTO uninst
IF ERRORLEVEL 2 inst_fth B
IF ERRORLEVEL 1 inst_fth A

:uninst
init_1 nul
