ECHO    off
CLS
GOTO    new
        \nc\ask "(a)lte oder (n)eue Version NILES-DOS ?",an
IF      errorlevel 2 GOTO NEW

:OLD
        \niles.old\qdv
GOTO    End

:NEW
IF      %1*==* GOTO New1
IF      NOT %1==~ GOTO New1
        \niles.new\qdv NiLeS-soft
GOTO    End

:New1
        \niles.new\qdv

:End
