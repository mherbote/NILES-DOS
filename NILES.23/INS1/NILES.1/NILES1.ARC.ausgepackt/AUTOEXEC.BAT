@ECHO   off
BREAK   off
SET     comspec=c:\command.com
SET     path=c:;c:\dos32;c:\BAT;c:\utilitys\nc;c:\utilitys\eztape;c:\utilitys\diskcom;
PROMPT  $p$g
        c:\dos32\keybgr
rem     c:\utilitys\logmouse\mouse
rem     c:\utilitys\logmouse\menu
rem     c:\utilitys\logmouse\click
rem     c:\utilitys\micmouse\cpanel
        dsart10 artist10.cfg
        mode com1:9600

CD      c:\syslog
        basic clock
CD      c:\
        sa bold yellow on blue
        log-on
