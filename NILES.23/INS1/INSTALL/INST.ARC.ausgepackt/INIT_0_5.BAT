ECHO ÿ
ECHO     QUICK-DOS-PAKET
ECHO ÿ
ASK "      QUELL-LAUFWERK WŽHLEN (A/B) ? ",abx
IF ERRORLEVEL 3 GOTO uninst
IF ERRORLEVEL 2 inst_qdo B
IF ERRORLEVEL 1 inst_qdo A

:uninst
init_0 nul
