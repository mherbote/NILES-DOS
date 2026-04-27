ECHO ÿ
ECHO         DATENBANK - PAKET mit dBASE II ( 16-bit )
ECHO                       ...
ECHO ÿ
ASK "       QUELL-LAUFWERK WŽHLEN (A/B) : ",abx
IF ERRORLEVEL 3 GOTO uninst
IF ERRORLEVEL 2 inst_d26 B
IF ERRORLEVEL 1 inst_d26 A

:uninst
init_2 nul
