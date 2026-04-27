ECHO    off
IF      %2*==* GOTO oPar2
        d:\sp\pas\tp5\tpc %1_ /Td:\sp\pas\tp5 /U.. > %2
GOTO    Wei1

:oPar2
        d:\sp\pas\tp5\tpc %1_ /Td:\sp\pas\tp5 /U.. >CON

:Wei1
        copy *.tpu ..                                    > nul
        del  *.tpu                                       > nul

:End
