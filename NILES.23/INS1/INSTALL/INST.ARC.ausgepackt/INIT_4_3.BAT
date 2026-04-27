ECHO ÿ
ECHO         TEXTVERARBEITUNGS - PAKET mit CHI-WRITER
ECHO                       ...
ECHO ÿ
ASK "       QUELL-LAUFWERK WŽHLEN (A/B) : ",abx
IF ERRORLEVEL 3 GOTO uninst
IF ERRORLEVEL 2 inst_chi B
IF ERRORLEVEL 1 inst_chi A

:uninst
init_4 nul
