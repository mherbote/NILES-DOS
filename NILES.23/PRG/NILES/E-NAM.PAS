{$R-,S-,I-,D-,F-,V+,B+,N-,L+ }
{$M 5000,0,0 }
{$DEFINE Debug }
{$UNDEF  Debug }

{******************************************************
 * E-NAM.PAS      automatisches Maschinentagebuch     *
 *                                                    *
 * L O G N A M  - Datei erstellen                     *
 *                                                    *
 *                   (c) by NILES-SOFT 1988 VERS. 2.3 *
 *                      Programmierer: Marcus Herbote *
 ******************************************************}

uses   dos,crt,crt_,Fenster_,SysLog_,LogNamO_,LogNam_,Batch_,Syshalt_,Mount_,Wahl_,IStr_;

const  copyrc                      = '(c) 88,89 by NILES-SOFT';
       pc1                         = 'M o d u l :     E  -  N  A  M';
       pc2                         = 'V e r s i o n   2  .  3';
       pc3                         = '11.04.89';

var    i                           :                Integer;
       z                           :                LongInt;
       crc                         :                Word;
       mpz                         :                string[8];
       Name,Pass1,Pass2            :                string[255];

procedure sys_halt(id:integer);
begin Demount_Log; sys_halt1(id); halt(1); end;

function vorhanden:Boolean;
begin repeat Name:='     ';
             c1_write(13,11,'Kurzbezeichnung des Bearbeiters: ');
             c2_write(13,44,Name); gotoxy(44,13); readln(Name);
      until length(Name)=5;
      crc:=0; for i:=1 to 5 do crc:=crc+ord(Name[i])*i-ord(Name[i]);
      repeat LogNam_R; until (LogNam_p.crc1=crc) or eof(LogNam_d);
      if LogNam_p.crc1=crc then vorhanden:=true else vorhanden:=false;
end;


begin {$IFDEF Debug} CheckBreak:=true; {$ELSE} CheckBreak:=false; {$ENDIF}
      c1_write(1,1,''); Name:=ParamStr(2);
      if (ParamStr(1)='C') or (ParamStr(1)='c')
      then clrscr
      else begin Window( 9, 7,70,18); clrscr; Window(1,1,80,25); end;
      fenster(1, 9, 7,70,18,'…','Õ','ª','∫','»','º','∫','Õ',copyrc,pc1,pc2,pc3);

      Mount_Log; LogNam_O; if not LogNam_exit then sys_halt(1);

      w:=5;
      repeat c1_write(24, 1,''); clreol;
             Window(10,12,69,17); clrscr; Window( 1, 1,80,25);
             auswahl[1].x:= 3; auswahl[1].y:=24; auswahl[1].t:='Bearbeiter hinzufÅgen';
             auswahl[2].x:= 3; auswahl[2].y:=25; auswahl[2].t:='Bearbeiter lîschen';
             auswahl[3].x:=33; auswahl[3].y:=24; auswahl[3].t:='Menu-PATH-Name zeigen';
             auswahl[4].x:=33; auswahl[4].y:=25; auswahl[4].t:='Menu-PATH-Name Ñndern';
             auswahl[5].x:=63; auswahl[5].y:=25; auswahl[5].t:='Programm beenden';
             wahl1(5);
             gotoxy(1,24); clreol; gotoxy(1,25); clreol;
             c2_write(17,47,''); LogNam_O;
             case w of
               1: begin write('Bearbeiter hinzufÅgen');
                        if vorhanden
                        then begin if color
                                      then c_write(17,11,red  ,yellow+blink,'Bearbeiter existiert schon')
                                      else c_write(17,11,white,black +blink,'Bearbeiter existiert schon');
                                   for z:=1 to 200000 do ;
                             end
                        else begin Seek(LogNam_d,FileSize(LogNam_d));
                                   c1_write(15,11,'M e n u  -  P A T H  -  N a m e: ');
                                   mpz:=IStr('........',15,44);
                                   if mpz='........'
                                      then LogNam_p.mpz:='DEMO1   '
                                      else move(mpz[1],LogNam_p.mpz[1],8);
                                   Pass1:=Name ; while length(Pass1)<100 do Pass1:=Pass1+' ';
                                   Pass2:=Pass1; while length(Pass2)<255 do Pass2:=Pass2+' ';
                                   with LogNam_p do
                                   begin crc1:=0; crc2:=0; crc3:=0;
                                         for i:=1 to length(Name ) do crc1:=crc1+ord(Name [i])*i-ord(Name [i]);
                                         for i:=1 to length(Pass1) do crc2:=crc2+ord(Pass1[i])*i-ord(Pass1[i]);
                                         for i:=1 to length(Pass2) do crc3:=crc3+ord(Pass2[i])*i-ord(Pass2[i]);
                                   end;
                                   with LogNam_p do
                                        for i:=1 to 8 do mpz[i]:=chr(ord(mpz[i])+(crc1 and $FF));
                                   LogNam_W;
                             end;
                  end;
               2: begin write('Bearbeiter lîschen');
                        if vorhanden
                        then begin Seek(LogNam_d,FilePos(LogNam_d)-1);
                                   LogNam_p.crc1:=Random($FFFF);
                                   LogNam_p.crc2:=Random($FFFF);
                                   LogNam_p.crc3:=Random($FFFF);
                                   LogNam_W;
                             end
                        else begin if color
                                      then c_write(17,11,red  ,yellow+blink,'Bearbeiter existiert nicht')
                                      else c_write(17,11,white,black +blink,'Bearbeiter existiert nicht');
                                   for z:=1 to 200000 do ;
                             end;
                  end;
               3: begin write('Menu-PATH-Name zeigen');
                        if vorhanden
                        then begin with LogNam_p do
                                        for i:=1 to 8 do mpz[i]:=chr(ord(mpz[i])-(crc1 and $FF));
                                   move(LogNam_p.mpz[1],mpz[1],8); mpz[0]:=chr(8);
                                   c1_write(15,11,'aktueller Menu - PATH - Name: ');
                                   c2_write(15,44,mpz);
                                   c2_write(24,47,'Weiter mit <ENTER>');
                                   readln;
                             end
                        else begin if color
                                      then c_write(17,11,red  ,yellow+blink,'Bearbeiter existiert nicht')
                                      else c_write(17,11,white,black +blink,'Bearbeiter existiert nicht');
                                   for z:=1 to 200000 do ;
                             end;
                  end;
               4: begin write('Menu-PATH-Name Ñndern');
                        if vorhanden
                        then begin Seek(LogNam_d,FilePos(LogNam_d)-1);
                                   with LogNam_p do
                                        for i:=1 to 8 do mpz[i]:=chr(ord(mpz[i])-(crc1 and $FF));
                                   move(LogNam_p.mpz[1],mpz[1],8); mpz[0]:=chr(8);
                                   c1_write(15,11,'neuer   Menu - PATH - Name    : ');
                                   mpz:=IStr(mpz,15,44);
                                   if mpz='........'
                                      then LogNam_p.mpz:='DEMO1   '
                                      else Move(mpz[1],LogNam_p.mpz[1],8);
                                   with LogNam_p do
                                        for i:=1 to 8 do mpz[i]:=chr(ord(mpz[i])+(crc1 and $FF));
                                   LogNam_W;
                             end
                        else begin if color
                                      then c_write(17,11,red  ,yellow+blink,'Bearbeiter existiert nicht')
                                      else c_write(17,11,white,black +blink,'Bearbeiter existiert nicht');
                                   for z:=1 to 200000 do ;
                             end;
                  end;
             end;
             LogNam_C;
      until w=5;

      c1_write(1,1,'');
      if (ParamStr(1)='C') or (ParamStr(1)='c')
         then begin Window( 1, 1,80,25); clrscr;                    end
         else begin Window( 9, 7,70,18); clrscr; Window(1,1,80,25); end;
      Demount_Log;
end.
