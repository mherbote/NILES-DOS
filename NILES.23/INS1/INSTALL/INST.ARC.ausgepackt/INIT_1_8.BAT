ECHO ÿ
ECHO         TURBO PASCAL - PAKET  Version 5.0 mit
ECHO                       TOOLBOXEN ...
ECHO ÿ
ASK "       QUELL-LAUFWERK WŽHLEN (A/B) : ",abx
IF ERRORLEVEL 3 GOTO uninst
IF ERRORLEVEL 2 GOTO inst_tpB
IF ERRORLEVEL 1 GOTO inst_tpA

:inst_tpA
ASK "      WELCHE VERSION SOLL INSTALLIERT WERDEN (3/5) ? ",35
IF ERRORLEVEL 2 inst_tpa A 5
inst_tpa A 3

:inst_tpB
ASK "      WELCHE VERSION SOLL INSTALLIERT WERDEN (3/5) ? ",35
IF ERRORLEVEL 2 inst_tpa B 5
inst_tpa B 3

:uninst
init_1 nul
