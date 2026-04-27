ECHO ÿ
ECHO         TEXTVERARBEITUNGS - PAKET mit WORD
ECHO                       ...
ECHO ÿ
ASK "       QUELL-LAUFWERK WŽHLEN (A/B) : ",abx
IF ERRORLEVEL 3 GOTO uninst
IF ERRORLEVEL 2 inst_wrd B
IF ERRORLEVEL 1 inst_wrd A

:uninst
init_4 nul
