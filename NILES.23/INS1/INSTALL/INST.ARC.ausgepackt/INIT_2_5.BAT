ECHO ÿ
ECHO         DATENBANK - PAKET mit CLIPPER 87
ECHO                       ...
ECHO ÿ
ASK "       QUELL-LAUFWERK WŽHLEN (A/B) : ",abx
IF ERRORLEVEL 3 GOTO uninst
IF ERRORLEVEL 2 inst_cli B
IF ERRORLEVEL 1 inst_cli A

:uninst
init_2 nul
