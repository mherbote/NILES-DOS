IF %1*==* init_all

IF NOT %1*==* TYPE %1 >> init_nil.bld

TYPE init_nil.bld

ask "              AUSWAHL : ",0123456789x
cls
if errorlevel 11 goto end
if errorlevel 10 init_9
if errorlevel 9 init_8
if errorlevel 8 init_7
if errorlevel 7 init_6
if errorlevel 6 init_5
if errorlevel 5 init_4
if errorlevel 4 init_3
if errorlevel 3 init_2
if errorlevel 2 init_1
if errorlevel 1 init_0

:end
ECHO          *** ABARBEITUNG BEENDET ***
ECHO ÿ
ECHO #   LETZTE AKTIONEN :  LOESCHEN INSTALL-PFAD,    #
ECHO #                      SPEEDDISK,                #
ECHO #                      SUPERDIRECTORY,           #
ECHO #                      CHECKSUM                  #
ECHO ÿ

:error
ECHO DISKETTE MIT ##  INSTALL-NILES  ## IN LAUFWERK A EINLEGEN
ECHO ÿ
PAUSE
inst_vol A NILES_INST
IF ERRORLEVEL 1 GOTO error

A:
CD \INSTALL
A:\INSTALL\del_inst.bat
