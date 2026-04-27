echo off
cls
c:\utilitys\monitor\scratr 1e
c:\utilitys\files\sk
mount d:
if errorlevel 1 goto fehl

:zyk
cls
c:\utilitys\monitor\scratr 1e
echo .                                                                (c) NILES-Soft
echo .
echo .
echo          --------------------------------------
echo          A U S W A H L   der ProgrammKomponente
echo          --------------------------------------
echo          a   d  B  A  S  E  II
echo .
echo          x   Norton Commander  (SystemEbene)
echo .
echo          y   Arbeit beenden
echo          --------------------------------------
ASK "         Eingabe der Auswahl ",axy
if errorlevel  3 goto N3
if errorlevel  2 goto N2

        d:
        cd d:\dbase2
        dbase start
        goto zyk

:N2
        cls
        c:\utilitys\monitor\scratr 1e
        cd c:\
        nc
        goto zyk

:fehl
:N3
c:\bat\verteil.bat
