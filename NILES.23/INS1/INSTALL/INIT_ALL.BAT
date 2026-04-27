CLS
ECHO  ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
ECHO  ³                                                         ³
ECHO  ³           * INSTALLATION FšR ALLE SYSTEME *             ³
ECHO ÿ³                                                         ³
ECHO  ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´
ECHO  ³                                                         ³
ECHO  ³           EINRICHTEN                                    ³
ECHO  ³                                                         ³
ECHO  ³          TEMPORAERES VERZEICHNIS ZUR INSTALLATION:      ³
ECHO  ³                                                         ³
ECHO  ³                    C:\INSTALL                           ³
ECHO  ³                                                         ³
ECHO  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
ECHO ÿ

\BAT\ASK "        SOLL DIESER PFAD EINGERICHTET WERDEN ? (j/n) : ",jn
IF ERRORLEVEL 2 GOTO end

:error
ECHO ÿ
ECHO BITTE DISKETTE MIT  ** INSTALL - NILES **  IN LAUFWERK A: EINLEGEN !
ECHO ÿ
ECHO             ABBRUCH MIT ^C
ECHO ÿ
PAUSE
inst_vol A NILES_INST
IF ERRORLEVEL 1 GOTO error

C:
CD\
MD INSTALL
CD INSTALL
pkxarc A:\INSTALL\inst C:\INSTALL *.* >nul
rem COPY A:\INSTALL\*.* C:\INSTALL > nul

C:\install\init_nil ESCINST

:end
C:
CD \INSTALL
C:\install\init_nil nul
