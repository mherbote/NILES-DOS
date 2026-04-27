ECHO ÿ
ECHO     UTILITIES - PAKET
ECHO ÿ
ASK "      QUELL-LAUFWERK WŽHLEN (A/B) ? ",abx
IF ERRORLEVEL 3 GOTO uninst
IF ERRORLEVEL 2 inst_uti B
IF ERRORLEVEL 1 inst_uti A

:uninst
init_0 nul
