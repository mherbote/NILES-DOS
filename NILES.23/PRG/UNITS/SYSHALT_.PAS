{$R-,S-,I-,D-,F-,V+,B+,N-,L- }
{$M 1500,0,0 }
{$DEFINE Debug }
{$UNDEF  Debug }

unit Syshalt_;

interface

     uses dos,crt,crt_;

     procedure sys_halt1(id:integer);

implementation

     procedure sys_halt1(id:integer);
     begin c_write(1,1,blue,yellow,''); clrscr; c_write(14,20,red,yellow,'');
           case id of
             1: write('Datei:  "LOGNAM.DAT"  nicht gefunden !  ');
             3: write('Datei:  "LOGNAM.DAT"   D e f e k t !    ');
             4: write('Datei:  "LOGMASCH.DAT"  nicht gefunden !');
             5: write('   zu viele PassWort-EingabeVersuche    ');
             2: write('Datei:  "LOGMASCH.DAT"   D e f e k t !  ');
            10: write('illeg. Žnderung an DATUM und/oder ZEIT !');
            20: write('Dateien konnten nicht gefunden werden  !');
            30: write('keine Programm - Parameter angegeben   !');
           end;
           c_write(15,20,red,yellow+blink,'         SYSTEM   wurde gestoppt !!!    ');
     end;

end.
