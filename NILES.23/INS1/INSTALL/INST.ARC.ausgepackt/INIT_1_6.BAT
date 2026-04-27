ECHO ÿ
ECHO         LISP - PAKET mit GC-LISP
ECHO                       ...
ECHO ÿ
ASK "       QUELL-LAUFWERK WŽHLEN (A/B) : ",abx
IF ERRORLEVEL 3 GOTO uninst
IF ERRORLEVEL 2 inst_lsp B
IF ERRORLEVEL 1 inst_lsp A

:uninst
init_1 nul
