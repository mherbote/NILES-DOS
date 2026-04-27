ECHO    off
IF      not exist \install.bat          GOTO End
IF      not exist \install\inst_vol.exe GOTO End
CLS
TYPE    \install\start.bld
        \bat\ask "                   Bitte Auswahl eingeben: ",123x

IF      errorlevel 4 GOTO End
IF      errorlevel 3 GOTO M
IF      errorlevel 2 GOTO K
IF      errorlevel 1 GOTO Genid

:Genid
CLS
ECHO 
        \bat\ask " Geben Sie bitte das Ziel-Laufwerk  { A ! B } ein: ",abx
IF      errorlevel 3 GOTO End
IF      errorlevel 2 GOTO G2
IF      errorlevel 1 GOTO G1
:G1
        \install\genid A
GOTO    End
:G2
        \install\genid B
GOTO    End

:K
        \install\komp

:M
        \bat\ibh3
:End
