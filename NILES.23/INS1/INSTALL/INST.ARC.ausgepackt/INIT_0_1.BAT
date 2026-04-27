ECHO ÿ
ECHO     NORTON - PAKET mit KOMMANDER
ECHO                        UTILITIES ...
ECHO ÿ
ASK "      QUELL-LAUFWERK WŽHLEN (A/B) ? ",abx
IF ERRORLEVEL 3 GOTO uninst
IF ERRORLEVEL 2 inst_nc B
IF ERRORLEVEL 1 inst_nc A

:uninst
init_0 nul
