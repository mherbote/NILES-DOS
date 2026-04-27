:error
ECHO DISKETTE  ##  dBASEIII Plus  ## IN LAUFWERK %1 EINLEGEN
ECHO                                 ABBRUCH MIT ^C
PAUSE
inst_vol %1 III00_0101
IF ERRORLEVEL 1 GOTO error

D:\UTILITYS\BATCH\COMMAND.COM /C %1:\install %1
init_2 ESC09
