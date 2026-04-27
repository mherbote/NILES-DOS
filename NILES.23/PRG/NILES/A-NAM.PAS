{$R-,S-,I-,D+,F-,V+,B+,N-,L+ }
{$M 1500,0,0 }
{$DEFINE Debug }
{ $UNDEF  Debug }
{.PL96}
{******************************************************
 * A-NAM.PAS      automatisches Maschinentagebuch     *
 *                                                    *
 * L O G N A M  - Datei erstellen                     *
 *                                                    *
 *                   (c) by NILES-SOFT 1988 VERS. 2.0 *
 *                      Programmierer: Marcus Herbote *
 ******************************************************}

uses   dos,crt;

const  copyrc                      = '(c) 88 by NILES-SOFT';
       pc1                         = 'M o d u l :     A  -  N  A  M';
       pc2                         = 'V e r s i o n   2  .  0';
       pc3                         = '28.04.88';

type   SysLog                      = record proj    : array[1.. 8] of char;
                                            bea     : array[1.. 5] of char;
                                            dwg     : array[1.. 8] of char;
                                            dat     : array[1.. 8] of char;
                                            tims    : array[1.. 4] of char;
                                            time    : array[1.. 4] of char;
                                            min     : array[1.. 4] of char;
                                            sk      : array[1.. 2] of char;
                                     end;
       LogNamO                     = record bea     : array[1.. 5] of char;
                                            nil1    :                 char;
                                            Bearb   : array[1..22] of char;
                                            mpz     : array[1.. 8] of char;
                                            sk      : array[1.. 2] of char;
                                     end;
       LogNam                      = record crc1    :                 word;
                                            crc2    :                 word;
                                            crc3    :                 word;
                                            mpz     : array[1.. 8] of char;
                                            sk      : array[1.. 2] of char;
                                     end;

var    LogNamOd                    : file   of LogNamO;
       LogNamOp                    :           LogNamO;
       LogNamd                     : file   of LogNam;
       LogNamp                     :           LogNam;
       ch                          :           char;
       i                           :           Integer;
       z                           :           LongInt;
       Name,Pass1,Pass2            :           string[255];

 {$I FENSTER.INC}



begin textbackground(blue); textcolor(yellow); clrscr;
{$IFDEF Debug} CheckBreak:=true; {$ELSE} CheckBreak:=false; {$ENDIF}
      fenster(1, 1, 1,80,24,'É','Í','»','º','È','¼','º','Í');

      Assign(LogNamOd,'A:\SYSLOG\LOGNAMEO.DAT'); Reset(LogNamOd);
      if IOResult<>0
         then begin gotoxy( 9, 9); write('Die Datei: "LOGNAMEO.DAT" kann nicht gefunden werden !');
                    gotoxy(15,13); write('Weiter, dann <ENTER> drcken');
                    ch:=readkey; halt(1);
              end;
      Assign(LogNamd ,'C:\SYSLOG\LOGNAM.DAT'  ); SetFAttr(LogNamd,Archive); Reset(LogNamd );

      repeat Read(LogNamOd,LogNamOp); Read(LogNamd,LogNamp);
             with LogNamp do
             begin gotoxy(15,9); write(LogNamOp.bea,':  ',LogNamOp.Bearb,' ===> ');
                   for z:=1 to 50000 do ;
                   for i:=1 to 8 do mpz[i]:=chr(ord(mpz[i])-(crc1 and $FF));
                   write(mpz);
             end;
      until eof(LogNamd);

      close(LogNamd); SetFAttr(LogNamd,ReadOnly+Hidden+SysFile);
end.
