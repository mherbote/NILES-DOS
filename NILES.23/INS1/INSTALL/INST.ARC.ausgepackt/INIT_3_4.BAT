ECHO ÿ
ECHO         DATENBANK - PAKET mit dBFORMAT
ECHO                       ...
ECHO ÿ
ASK "       QUELL-LAUFWERK WŽHLEN (A/B) : ",abx
IF ERRORLEVEL 3 GOTO uninst
IF ERRORLEVEL 2 inst_da4 B
IF ERRORLEVEL 1 inst_da4 A

:uninst
init_3 nul
