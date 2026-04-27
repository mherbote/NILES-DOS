ECHO ÿ
ECHO         DATENBANK - PAKET mit dBASE III PLUS
ECHO                       ...
ECHO ÿ
ASK "       QUELL-LAUFWERK WŽHLEN (A/B) : ",abx
IF ERRORLEVEL 3 GOTO uninst
IF ERRORLEVEL 2 inst_d3p B
IF ERRORLEVEL 1 inst_d3p A

:uninst
init_2 nul
