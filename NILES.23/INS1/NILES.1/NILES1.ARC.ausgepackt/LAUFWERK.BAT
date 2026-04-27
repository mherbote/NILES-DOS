:End
ECHO    off
BREAK   off
CLS
SET     path=c:;c:\dos32;c:\bat;c:\utilitys\nc;c:\utilitys\eztape;c:\utilitys\diskcom;
PROMPT  $p$g
ECHO ษอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออป
ECHO บ                                                                             บ
ECHO บ            -(%2)-------------------------                  (c) NILES-SOFT บ
ECHO บ            L a u f w e r k (e)   aktivieren                                 บ
ECHO บ            --------------------------------                                 บ
ECHO บ            d      L a u f w e r k  D:                                       บ
ECHO บ                                                                             บ
ECHO บ            e      L a u f w e r k  E:                                       บ
ECHO บ                                                                             บ
ECHO บ            f      L a u f w e r k  F:                                       บ
ECHO บ                                                                             บ
ECHO บ            g      L a u f w e r k  G:                                       บ
ECHO บ                                                                             บ
ECHO บ            h      L a u f w e r k  H:                                       บ
ECHO บ                                                                             บ
ECHO บ            i      L a u f w e r k  I:                                       บ
ECHO บ                                                                             บ
ECHO ศอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ
        ask     "         Eingabe der Auswahl ",defghi
IF      errorlevel 6 goto N6
IF      errorlevel 5 goto N5
IF      errorlevel 4 goto N4
IF      errorlevel 3 goto N3
IF      errorlevel 2 goto N2

                mount d:
        IF      errorlevel 1 GOTO End
                d:
        GOTO    Lwe

:N2
                mount e:
        IF      ERRORLEVEL 1 GOTO End
                e:
        GOTO    Lwe

:N3
                mount f:
        IF      errorlevel 1 GOTO End
                f:
        GOTO    Lwe

:N4
                mount g:
        IF      errorlevel 1 GOTO End
                g:
        GOTO    Lwe

:N5
                mount h:
        IF      errorlevel 1 GOTO End
                h:
        GOTO    Lwe

:N6
                mount i:
        IF      errorlevel 1 GOTO End
                i:
        GOTO    Lwe

:Lwe
ECHO .
        ask "Weitere Laufwerke aktivieren <j/n>? ",nj
IF      errorlevel 2 GOTO End

        VERTEIL.BAT %1
