ECHO    off
CLS
GOTO    New
        ask "(a)lte oder (n)eue Version NILES-DOS ?",an
CLS
ECHO    Bitte warten, das Programm wird geladen !
IF      errorlevel 2 GOTO NEW

:OLD
COPY    \niles.old\install.dat \install.dat >NUL
        \niles.old\iold
GOTO    End

:NEW
COPY    \niles.new\install.dat \install.dat >NUL
        \niles.new\install
GOTO    End

:End
DEL     install.dat
