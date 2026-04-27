ECHO    off
IF      %2*==* GOTO oPar2
        d:\sp\pas\tp5\tpc %1 /Td:\sp\pas\tp5 /U..\units /E..\ > %2
GOTO    End

:oPar2
        d:\sp\pas\tp5\tpc %1 /Td:\sp\pas\tp5 /U..\units /E..\ >CON

:End
