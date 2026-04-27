:End
ECHO    off
BREAK   off
CLS
SET     path=c:;c:\dos32;c:\bat;c:\utilitys\nc;c:\utilitys\eztape;c:\utilitys\diskcom;
PROMPT  $p$g
ECHO ษอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออป
ECHO บ                                                                             บ
ECHO บ            -(%2)-------------------------                  (c) NILES-SOFT บ
ECHO บ            A n w e n d e r   -  M e n    1                                 บ
ECHO บ            --------------------------------                                 บ
ECHO บ            m      Laufwerke mounten                                         บ
ECHO บ                                                                             บ
ECHO บ            d      Laufwerke demounten                                       บ
ECHO บ                                                                             บ
ECHO บ                                                                             บ
ECHO บ            z      zurck zur Haupt-AUSWAHL-Ebene                            บ
ECHO ศอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ
        ask     "             Eingabe der Auswahl ",mdzx
IF      errorlevel 4 GOTO N4
IF      errorlevel 3 GOTO N3
IF      errorlevel 2 GOTO N2

	a:\BAT\SPZ\MA.BAT 
rem VERTEIL %2

:N2
	c:\bat\DEMOUNTA.BAT 
rem c:\bat\VERTEIL.BAT %1 %2

:Anw-e
:N3
rem                c:
rem        CD      c:\bat
rem                c:\bat\VERTEIL.BAT %1

:N4
                disndata
        GOTO    End
