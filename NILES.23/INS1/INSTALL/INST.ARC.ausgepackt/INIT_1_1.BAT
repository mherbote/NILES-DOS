ECHO ÿ
ECHO     ASSEMBLER - PAKET mit MASM 4.0
ECHO                           LINK,DEBUG,DISASM...
ECHO ÿ
ASK "      QUELL-LAUFWERK WŽHLEN (A/B) ? ",abx
IF ERRORLEVEL 3 GOTO uninst
IF ERRORLEVEL 2 inst_asm B
IF ERRORLEVEL 1 inst_asm A

:uninst
init_1 nul
