@ECHO   off
        sa bright yellow on blue /N
        c:\utilitys\diskcom\mount d:
IF      errorlevel 1 GOTO N1 
        d:
CD      d:\dbase3P
GOTO    Ende
:N1 
ECHO    "INVALID PASSWORT"
        c:
CD      c:\
:Ende
        sa bright yellow on blue /N
