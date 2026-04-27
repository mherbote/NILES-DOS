ECHO ÿ
ECHO         FORTRAN - PAKET mit FORTRAN 77
ECHO                       ...
ECHO ÿ
ASK "       QEULL-LAUFWER WŽHLEN (A/B) ? ",abx
IF ERRORLEVEL 3 GOTO uninst
IF ERRORLEVEL 2 inst_for B
IF ERRORLEVEL 1 inst_for A

:uninst
init_1 nul
