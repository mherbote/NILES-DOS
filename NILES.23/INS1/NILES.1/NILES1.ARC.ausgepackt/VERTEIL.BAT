GOTO    %1

:End
ECHO    off
BREAK   off
        cls
SET     path=c:;c:\dos32;c:\bat;c:\utilitys\nc;c:\utilitys\eztape;c:\utilitys\diskcom;
PROMPT  $p$g
ECHO ษอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออป
ECHO บ            -(0000)------------------------------             (c) NILES-SOFT บ
ECHO บ            H a u p t - A U S W A H L - E b e n e                            บ
ECHO บ            -------------------------------------                            บ
ECHO บ            c   C A D         - Projekte                                     บ
ECHO บ                                                                             บ
ECHO บ            t   E z T a p e   - Aufruf                                       บ
ECHO บ                                                                             บ
ECHO บ            p   N o r t o n   - Programme                                    บ
ECHO บ            k                 - Kommander                                    บ
ECHO บ            m                 - Men                                         บ
ECHO บ            e                 - Editor                                       บ
ECHO บ                                                                             บ
ECHO บ            n   N u t z e r   - Men                                         บ
ECHO บ                                                                             บ
ECHO บ            v   V E N T U R A                                                บ
ECHO บ                                                                             บ
ECHO บ                                                                             บ
ECHO บ            l   L a u f w e r k (e) aktivieren                               บ
ECHO บ                                                                             บ
ECHO บ            y   Arbeit beenden                                               บ
ECHO ศอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ
        ask "             Eingabe der Auswahl ",ctpkmenvly
IF      errorlevel 10 goto N10
IF      errorlevel  9 goto N9
IF      errorlevel  8 goto N8
IF      errorlevel  7 goto N7
IF      errorlevel  6 goto N6
IF      errorlevel  5 goto N5
IF      errorlevel  4 goto N4
IF      errorlevel  3 goto N3
IF      errorlevel  2 goto N2

        GOTO    Cad

:N2
                eztape
        GOTO    End

:N3
        CLS
                ni
        GOTO    End

:N4
        CD      c:\
        CLS
                nc
        GOTO    End

:N5
        CLS
        CD      c:\bat
                c:
                nc
        GOTO    End

:N6
        CLS
                ne
        GOTO    End

:N7
        IF      exist c:\syslog\msh GOTO N7-e
        GOTO    End
:N7-e
        A:\BAT\ANWENDER.BAT End 8000
        GOTO    End

:N8
        CLS
    rem ECHO    ***********************************************
    rem ECHO    *   V E N T U R A   ist nicht installiert !   *
    rem ECHO    ***********************************************
    rem         pause
    rem GOTO    End
                e:
    rem IF      errorlevel 1 GOTO End
        CD      e:\gemsys
                gemvdi vp %1
                c:
        GOTO    End

:N9
        LAUFWERK.BAT End 6000

:N10
                c:
                cd c:\
                LOG-OFF.BAT
                demount d:
                demount e:
                demount f:
                demount g:
                demount h:
                demount i:
                LOG-OFF.BAT

rem ****************************************************************************
rem ****************************************************************************

:Norton
ECHO    off
BREAK   off
        cls
SET     path=c:;c:\dos32;c:\bat;c:\utilitys\nc;c:\utilitys\eztape;c:\utilitys\diskcom;
PROMPT  $p$g
ECHO ษอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออป
ECHO บ            -(3000)--------------------------------           (c) NILES-SOFT บ
ECHO บ            N O R T O N   A U S W A H L - E b e n e                          บ
ECHO บ            ---------------------------------------                          บ
ECHO บ            c   N o r t o n   C o m m a n d e r                              บ
ECHO บ                                                                             บ
ECHO บ            u   N o r t o n   U t i l i t y s                                บ
ECHO บ                                                                             บ
ECHO บ            i   N o r t o n   I n t e g r a t o r                            บ
ECHO บ                                                                             บ
ECHO บ            p   N o r t o n   C D                                            บ
ECHO บ                                                                             บ
ECHO บ            s   S y s t e m   I n f o                                        บ
ECHO บ                                                                             บ
ECHO บ                                                                             บ
ECHO บ            l   L a u f w e r k (e)   aktivieren                             บ
ECHO บ                                                                             บ
ECHO บ            z   zurck zur  Haupt-AUSWAHL-Ebene                              บ
ECHO ศอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ
        ask "             Eingabe der Auswahl ",cuipslz
IF      errorlevel 7 GOTO N73
IF      errorlevel 6 goto N63
IF      errorlevel 5 goto N53
IF      errorlevel 4 goto N43
IF      errorlevel 3 goto N33
IF      errorlevel 2 goto N23

        CD      c:\
        CLS
                nc
        GOTO    Norton

:N23
        CLS
                nu
        GOTO    Norton

:N33
        CLS
                ni
        GOTO    Norton

:N43
        CLS
                ncd
        GOTO    Norton

:N53
        CLS
                si c:
                pause
        GOTO    Norton

:N63
        LAUFWERK.BAT Norton 3600

:N73
GOTO    End

rem ****************************************************************************
rem ****************************************************************************

:Cad
ECHO    off
BREAK   off
        cls
SET     path=c:;c:\dos32;c:\bat;c:\utilitys\nc;c:\utilitys\eztape;c:\utilitys\diskcom;
PROMPT  $p$g
ECHO ษอออออออออออออออออออออออออออออออออออออออออออออออออออออหอออออออออออออออออออออออป
ECHO บ Prfen Sie, ob der Digitizer ausgeschaltet und ob   บ        (c) NILES-SOFT บ
ECHO บ             die ben”tigten Laufwerke aktiviert sind!บ                       บ
ECHO ฬอออออออออออออออออออออออออออออออออออออออออออออออออออออผ                       บ
ECHO บ                                                                             บ
ECHO บ            -(1000)-----------------------------                             บ
ECHO บ            C  A  D  - A U S W A H L - E b e n e                             บ
ECHO บ            ------------------------------------                             บ
ECHO บ            a   A u t o C A D   - Anwendung                                  บ
ECHO บ                                                                             บ
ECHO บ            d   A u t o C A D   - Demonstration                              บ
ECHO บ                                                                             บ
ECHO บ            g   C A D d y                                                    บ
ECHO บ                                                                             บ
ECHO บ            p   P C A  - test                                                บ
ECHO บ                                                                             บ
ECHO บ                                                                             บ
ECHO บ            l   L a u f w e r k (e) aktivieren                               บ
ECHO บ                                                                             บ
ECHO บ            z   zurck zur  Haupt-AUSWAHL-Ebene                              บ
ECHO ศอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ
        ask "             Eingabe der Auswahl ",adgplz
IF      errorlevel 6 goto N61
IF      errorlevel 5 goto N51
IF      errorlevel 4 goto N41
IF      errorlevel 3 goto N31
IF      errorlevel 2 goto N21

        CLS
    rem ECHO    ***********************************************
    rem ECHO    *  A u t o C A D    ist nicht installiert !   *
    rem ECHO    ***********************************************
    rem         pause
    rem GOTO    Cad
        GOTO    Acad

:N21
        CLS
    rem ECHO    ****************************************************
    rem ECHO    *   A u t o C A D - DEMO ist nicht installiert !   *
    rem ECHO    ****************************************************
    rem         pause
    rem GOTO    Cad
        GOTO    Acad-dem

:N31
        CLS
        ECHO    *******************************************
        ECHO    *   C A D d y   ist nicht installiert !   *
        ECHO    *******************************************
                pause
        GOTO    Cad
                f:
        IF      errorlevel 1 goto end
        CD      f:\caddy\3-04
                caddy
                c:
        GOTO    Cad

:N41
        cls
    rem ECHO    ***************************************
    rem ECHO    *   P C A   ist nicht installiert !   *
    rem ECHO    ***************************************
    rem         pause
    rem GOTO    Cad
                f:
    rem IF      errorlevel 1 GOTO Cad
        CD      f:\pca
        SET     path=f:\acad\d25;c:\utilitys\nc;c:\utilitys\diskcom
                nnpca25
                c:
        GOTO    Cad

:N51
        LAUFWERK.BAT Cad 1500

:N61
	GOTO      End

rem ****************************************************************************
rem ****************************************************************************

:Acad-dem
ECHO	  off
BREAK	  off
        f:
    rem IF      errorlevel 1 goto n7
SET     path=f:\acad\d25;c:\bat;c:\utilitys\nc;
SET     acadfreeram=50000
SET     lispstack=10000
SET     lispheap=30000
SET     acad=f:\acad\d25\cadkon
    rem CD      f:\acad
    rem         dsart10 artist10.cfg
CD      f:\acad\d25\cadkon

:Ac-d-e
CLS
ECHO ษอออออออออออออออออออออออออออออออออออออออออออออออออออออหอออออออออออออออออออออออป
ECHO บ Prfen Sie, ob der Digitizer ausgeschaltet und ob   บ        (c) NILES-SOFT บ
ECHO บ             die ben”tigten Laufwerke aktiviert sind!บ                       บ
ECHO ฬอออออออออออออออออออออออออออออออออออออออออออออออออออออผ                       บ
ECHO บ                                                                             บ
ECHO บ            -(1200)---------------------------------                         บ
ECHO บ            A u t o C A D    D e m o   A u s w a h l                         บ
ECHO บ            ----------------------------------------                         บ
ECHO บ            a   Fabrik                                                       บ
ECHO บ            b   Haus 1                                                       บ
ECHO บ            c   Haus 2                                                       บ
ECHO บ                                                                             บ
ECHO บ            d   Gelaende K SOB                                               บ
ECHO บ            e   Plan     Haus 5                                              บ
ECHO บ                                                                             บ
ECHO บ            f   Park-Gelnde                                                 บ
ECHO บ                                                                             บ
ECHO บ                                                                             บ
ECHO บ            z   Demonstration beenden                                        บ
ECHO ศอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ
        ask "             Eingabe der Auswahl ",abcdefz
IF      errorlevel 7 goto N712
IF      errorlevel 6 goto N612
IF      errorlevel 5 goto N512
IF      errorlevel 4 goto N412
IF      errorlevel 3 goto N312
IF      errorlevel 2 goto N212

        CLS
        ECHO           ษออออออออออออออออออออออออออออออออออออออออออออออออออออป
        ECHO           บ     Bitte Warten ,   A C A D    wird geladen !     บ
        ECHO           บ     ******************************************     บ
        ECHO           ศออออออออออออออออออออออออออออออออออออออออออออออออออออผ
        CD      f:..\sl1
                f:..\acad f:demo f:sl1
        CD      f:..\cadkon
        GOTO    Ac-d-e

:N212
        CLS
        ECHO           ษออออออออออออออออออออออออออออออออออออออออออออออออออออป
        ECHO           บ     Bitte Warten ,   A C A D    wird geladen !     บ
        ECHO           บ     ******************************************     บ
        ECHO           ศออออออออออออออออออออออออออออออออออออออออออออออออออออผ
        CD      f:..\sl2
                f:..\acad f:demo f:sl2
        CD      f:..\cadkon
        GOTO Ac-d-e

:N312
        CLS
        ECHO           ษออออออออออออออออออออออออออออออออออออออออออออออออออออป
        ECHO           บ     Bitte Warten ,   A C A D    wird geladen !     บ
        ECHO           บ     ******************************************     บ
        ECHO           ศออออออออออออออออออออออออออออออออออออออออออออออออออออผ
        CD      f:..\sl3
                f:..\acad f:demo f:sl3
        CD      f:..\cadkon
        GOTO    Ac-d-e

:N412
        CLS
        ECHO           ษออออออออออออออออออออออออออออออออออออออออออออออออออออป
        ECHO           บ     Bitte Warten ,   A C A D    wird geladen !     บ
        ECHO           บ     ******************************************     บ
        ECHO           ศออออออออออออออออออออออออออออออออออออออออออออออออออออผ
        CD      f:..\tp6
                f:..\acad f:sob f:start
        CD      f:..\cadkon
        GOTO Ac-d-e

:N512
        CLS
        ECHO           ษออออออออออออออออออออออออออออออออออออออออออออออออออออป
        ECHO           บ     Bitte Warten ,   A C A D    wird geladen !     บ
        ECHO           บ     ******************************************     บ
        ECHO           ศออออออออออออออออออออออออออออออออออออออออออออออออออออผ
        CD      f:..\tp6
                f:..\acad f:haus5 f:start
        CD      f:..\cadkon
        GOTO Ac-d-e

:N612
        CLS
        ECHO           ษออออออออออออออออออออออออออออออออออออออออออออออออออออป
        ECHO           บ     Bitte Warten ,   A C A D    wird geladen !     บ
        ECHO           บ     ******************************************     บ
        ECHO           ศออออออออออออออออออออออออออออออออออออออออออออออออออออผ
        CD      f:..\tp6
                f:..\acad f:layout f:start
        CD      f:..\cadkon
        GOTO Ac-d-e

:N712
        GOTO    Cad

rem ****************************************************************************
rem ****************************************************************************

:Acad
ECHO    off
BREAK   off
SET     acadfreeram=50000
SET     lispheap=30000
SET     lispstack=10000
        f:
CD      f:\acad
    rem DSART10 ARTIST10.CFG

:Ac-e
SET     path=f:\acad;c:\bat;c:\dos32;C:\utilitys\diskcom;c:\utilitys\nc;
CLS
ECHO ษอออออออออออออออออออออออออออออออออออออออออออออออออออออหอออออออออออออออออออออออป
ECHO บ Prfen Sie, ob der Digitizer ausgeschaltet und ob   บ        (c) NILES-SOFT บ
ECHO บ             die ben”tigten Laufwerke aktiviert sind!บ                       บ
ECHO ฬอออออออออออออออออออออออออออออออออออออออออออออออออออออผ                       บ
ECHO บ                                                                             บ
ECHO บ            -(1100)---------------------------------                         บ
ECHO บ            A u t o C A D    H a u p t A u s w a h l                         บ
ECHO บ            ----------------------------------------                         บ
ECHO บ            5   AutoCAD Deutsch     V 2.5                                    บ
ECHO บ            6   AutoCAD Englisch    V 2.6                                    บ
ECHO บ                                                                             บ
ECHO บ            t   AutoCAD Testaufruf  V 2.5                                    บ
ECHO บ                                                                             บ
ECHO บ            s   AutoCAD Symbolgenerator (zeichnen   )                        บ
ECHO บ            c   AutoCAD Symbolgenerator (compilieren)                        บ
ECHO บ                                                                             บ
ECHO บ                                                                             บ
ECHO บ            l   L a u f w e r k (e) aktivieren                               บ
ECHO บ                                                                             บ
ECHO บ            z   zurck zur CAD-AUSWAHL-Ebene                                 บ
ECHO ศอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ
        ask "             Eingabe der Auswahl ",56tlzsc
IF      errorlevel 7 GOTO N711
IF      errorlevel 6 GOTO N611
IF      errorlevel 5 GOTO N511
IF      errorlevel 4 GOTO N411
IF      errorlevel 3 GOTO N311
IF      errorlevel 2 GOTO N211

        CLS
        ECHO           ษออออออออออออออออออออออออออออออออออออออออออออออออออออป
        ECHO           บ     Bitte Warten ,   A C A D    wird geladen !     บ
        ECHO           บ     ******************************************     บ
        ECHO           ศออออออออออออออออออออออออออออออออออออออออออออออออออออผ
        SET     path=f:\acad\d25;c:\bat;c:\dos32;c:\utilitys\diskcom;c:\utilitys\nc;
        CD      f:\acad\d25\anwender
                f:
                acad test
        GOTO    Ac-e

:N211
        CLS
        ECHO           ษออออออออออออออออออออออออออออออออออออออออออออออออออออป
        ECHO           บ     Bitte Warten ,   A C A D    wird geladen !     บ
        ECHO           บ     ******************************************     บ
        ECHO           ศออออออออออออออออออออออออออออออออออออออออออออออออออออผ
        SET     path=d:\acad\e26;c:\bat;c:\dos32;c:\utilitys\diskcom;c:\utilitys\nc;
        CD      f:\acad\e26\anwender
                f:
                acad test
        GOTO    Ac-e

:N311
        CLS
        ECHO           ษออออออออออออออออออออออออออออออออออออออออออออออออออออป
        ECHO           บ     Bitte Warten ,   A C A D    wird geladen !     บ
        ECHO           บ     ******************************************     บ
        ECHO           ศออออออออออออออออออออออออออออออออออออออออออออออออออออผ
        SET     path=f:\acad\d25;c:\bat;c:\dos32;c:\utilitys\diskcom;c:\utilitys\nc;
        CD      f:\acad\d25\anwender
                f:
                acad test c:\bat\test.scr
        GOTO    Ac-e

:N411
        LAUFWERK.BAT Acad 1140

:N511
        GOTO    Cad

:N611
        CLS
        ECHO           ษออออออออออออออออออออออออออออออออออออออออออออออออออออป
        ECHO           บ     Bitte Warten ,   A C A D    wird geladen !     บ
        ECHO           บ     ******************************************     บ
        ECHO           ศออออออออออออออออออออออออออออออออออออออออออออออออออออผ
        SET     path=f:\acad\d25;c:\bat;c:\dos32;c:\utilitys\diskcom;c:\utilitys\nc;
        CD      f:\acad\d25\sg
                f:
                acad symbole shpedit
        GOTO    Ac-e
	  
:N711
        CLS
        ECHO           ษออออออออออออออออออออออออออออออออออออออออออออออออออออป
        ECHO           บ     Bitte Warten ,   A C A D    wird geladen !     บ
        ECHO           บ     ******************************************     บ
        ECHO           ศออออออออออออออออออออออออออออออออออออออออออออออออออออผ
        SET     path=f:\acad\d25;c:\bat;c:\dos32;c:\utilitys\diskcom;c:\utilitys\nc;
        CD      f:\acad\d25\sg
                f:
                acad symbole dxfgen
        CLS
        DEL     symbole.shp
                shp25ger
        DEL     symbole.dxf
        CLS
                acad symbole shpcom
        COPY    symbole.shx \acad\d25
        GOTO    Ac-e
