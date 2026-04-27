ECHO ÿ
ECHO     XTREE - PAKET
ECHO ÿ
ASK "      QUELL-LAUFWERK WŽHLEN (A/B) ? ",abx
IF ERRORLEVEL 3 GOTO uninst
IF ERRORLEVEL 2 inst_xtr B
IF ERRORLEVEL 1 inst_xtr A

:uninst
init_0 nul
