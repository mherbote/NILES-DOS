IF %2*==BB* GOTO bb
IF %2*==TB* GOTO tb
IF %2*==GW* GOTO gw

:bb
:error1
ECHO DISKETTE MIT ##  BETTER-BASIC  ## IN LAUFWERK %1 EINLEGEN
ECHO                                   ABBRUCH MIT ^C
PAUSE
inst_vol %1 II10_0201
IF ERRORLEVEL 1 GOTO error1

D:\UTILITYS\BATCH\COMMAND.COM /C %1:\install %1
GOTO end

:tb
:error2
ECHO DISKETTE MIT ##  TURBO-BASIC  ## IN LAUFWERK %1 EINLEGEN
ECHO                                  ABBRUCH MIT ^C
PAUSE
inst_vol %1 II10_0101
IF ERRORLEVEL 1 GOTO error2

D:\UTILITYS\BATCH\COMMAND.COM /C %1:\install %1
GOTO end

:gw
:error3
ECHO DISKETTE MIT ##  GW-BASIC  ## IN LAUFWERK %1 EINLEGEN
ECHO                               ABBRUCH MIT ^C
PAUSE
inst_vol %1 II10_0301
IF ERRORLEVEL 1 GOTO error3

D:\UTILITYS\BATCH\COMMAND.COM /C %1:\install %1

:end
init_1 ESC07
