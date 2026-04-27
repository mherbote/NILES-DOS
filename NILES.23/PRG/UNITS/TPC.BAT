ECHO    off
:Zyk
IF      %1*==* GOTO End
        d:\sp\pas\tp5\tpc %1 /Td:\sp\pas\tp5 >CON

SHIFT   1
GOTO    Zyk

:End
