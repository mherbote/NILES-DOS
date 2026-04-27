ECHO ÿ
ECHO         TABELLENKALKULATIONS - PAKET mit PLANSTAR
ECHO                       ...
ECHO ÿ
ASK "       QUELL-LAUFWERK WŽHLEN (A/B) : ",abx
IF ERRORLEVEL 3 GOTO uninst
IF ERRORLEVEL 2 inst_pla B
IF ERRORLEVEL 1 inst_pla A

:uninst
init_5 nul
