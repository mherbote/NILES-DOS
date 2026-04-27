ECHO    off
IF      %1*==* GOTO End
CD      \niles.23\wrk
        ibh1
        tbatch 
        ibh2 %1
COPY    i-exe  %1:\install1.exe >NUL
COPY    i1-bat %1:\install.bat  >NUL
COPY    i2-bat %1:\i2-bat       >NUL

:End
CD      \
