{$R-,S-,I-,D-,F-,V+,B+,N-,L- }
{$M 1500,0,0 }
{$DEFINE Debug }
{$UNDEF  Debug }

{******************************************************
 * E-PASS.PAS     automatisches Maschinentagebuch     *
 * P A S S W o r t  - Eintr„ge pflegen                *
 *                                                    *
 *                   (c) by NILES-SOFT 1988 VERS. 2.3 *
 *                      Programmierer: Marcus Herbote *
 ******************************************************}

uses   dos,crt,crt_,Fenster_,SysLog_,LogNam_,Batch_,Syshalt_,Mount_,Wahl_;

const  copyrc                      = '(c) 88,89 by NILES-SOFT';
       pc1                         = 'M o d u l :     E  -  P  A  S  S';
       pc2                         = 'V e r s i o n   2  .  3';
       pc3                         = '01.11.89';

var    i                           :           Integer;
       z                           :           LongInt;
       crc                         :           Word;
       Name,Pass1,Pass2            :           string[255];

procedure sys_halt(id:integer);
begin Demount_Log; sys_halt1(id);
      {$IFDEF Debug} halt(1); {$ELSE} i:=1; while i=1 do ; {$ENDIF}
end;

function vorhanden:Boolean;
begin repeat Name:='     ';
             c1_write(13,11,'Kurzbezeichnung des Bearbeiters: ');
             c2_write(13,44,Name); GotoXY(44,13); ReadLN(Name);
      until length(Name)=5;
      crc:=0; for i:=1 to 5 do crc:=crc+ord(Name[i])*i-ord(Name[i]);
      repeat LogNam_R; until (LogNam_p.crc1=crc) or eof(LogNam_d);
      if LogNam_p.crc1=crc then vorhanden:=true else vorhanden:=false;
end;


begin {$IFDEF Debug} CheckBreak:=true; {$ELSE} CheckBreak:=false; {$ENDIF}
      c1_write(1,1,''); Name:=ParamStr(2);
      if (ParamStr(1)='C') or (ParamStr(1)='c')
      then clrscr
      else begin if UpCase(Name[1])='U' then Window( 9, 7,70,21) else Window( 9, 9,70,21);
                    clrscr; Window(1,1,80,25); end;

      if UpCase(Name[1])='U'
      then fenster(1, 9, 7,70,16,'É','Í','»','º','È','¼','º','Í',copyrc,pc1,pc2,pc3)
      else fenster(1, 9, 9,70,16,'É','Í','»','º','È','¼','º','Í',copyrc,pc1,pc2,pc3);

      Mount_Log; LogNam_O; if not LogNam_exit then sys_halt(1);

      if UpCase(Name[1])='U'
      then repeat c1_write(24, 1,''); clreol;
             Window(10,12,69,15); clrscr; Window( 1, 1,80,25);
             auswahl[1].x:= 3; auswahl[1].y:=25; auswahl[1].t:='Passwort hinzufgen';
             auswahl[2].x:=25; auswahl[2].y:=25; auswahl[2].t:='Passwort l”schen';
             auswahl[3].x:=44; auswahl[3].y:=25; auswahl[3].t:='Passwort „ndern';
             auswahl[4].x:=63; auswahl[4].y:=25; auswahl[4].t:='Programm beenden';
             w:=4; wahl1(4);
             gotoxy(1,25); clreol; c2_write(15,50,''); LogNam_O;
             case w of
             1,3: begin case w of
                          1: write('Passwort hinzufgen');
                          2: write('Passwort „ndern');
                        end;
                        if vorhanden
                        then begin Seek(LogNam_d,FilePos(LogNam_d)-1);
                                   repeat Pass2:='                               ';
                                          c1_write(14,11,'Eingabe des Passwortes: ');
                                          c2_write(14,35,Pass2); GotoXY(35,14); Readln(Pass2);
                                   until length(Pass2)>3; i:=Pos(' ',Pass2);
                                   if i>0
                                   then begin Pass1:=Name+Copy(Pass2,1,i-1);
                                              Pass2:=Name+Pass2;
                                        end
                                   else begin Pass1:=Name+Pass2;
                                              Pass2:=Pass1;
                                              while length(Pass2)<255 do Pass2:=Pass2+' ';
                                        end;
{$IFDEF Debug}
c2_write(1,1,Name); writeln; writeln(Pass1); writeln(Pass2);
{$ENDIF}
                                   with LogNam_p do
                                   begin crc1:=0; crc2:=0; crc3:=0;
                                         for i:=1 to length(Name ) do crc1:=crc1+ord(Name [i])*i-ord(Name [i]);
                                         for i:=1 to length(Pass1) do crc2:=crc2+ord(Pass1[i])*i-ord(Pass1[i]);
                                         for i:=1 to length(Pass2) do crc3:=crc3+ord(Pass2[i])*i-ord(Pass2[i]);
                                   end;
                                   LogNam_W;
                             end
                        else begin if color
                                      then c_write(15,11,red  ,yellow+blink,'Bearbeiter existiert nicht')
                                      else c_write(15,11,white,black +blink,'Bearbeiter existiert nicht');
                                   for z:=1 to 200000 do ;
                             end;
                  end;
               2: begin write('Passwort l”schen');
                        if vorhanden
                        then begin Seek(LogNam_d,FilePos(LogNam_d)-1);
                                   Pass1:=Name ; while length(Pass1)<100 do Pass1:=Pass1+' ';
                                   Pass2:=Pass1; while length(Pass2)<255 do Pass2:=Pass2+' ';
                                   with LogNam_p do
                                   begin crc1:=0; crc2:=0; crc3:=0;
                                         for i:=1 to length(Name ) do crc1:=crc1+ord(Name [i])*i-ord(Name [i]);
                                         for i:=1 to length(Pass1) do crc2:=crc2+ord(Pass1[i])*i-ord(Pass1[i]);
                                         for i:=1 to length(Pass2) do crc3:=crc3+ord(Pass2[i])*i-ord(Pass2[i]);
                                   end;
                                   LogNam_W;
                             end
                        else begin if color
                                      then c_write(15,11,red  ,yellow+blink,'Bearbeiter existiert nicht')
                                      else c_write(15,11,white,black +blink,'Bearbeiter existiert nicht');
                                   for z:=1 to 200000 do ;
                             end;
                  end;
             end;
             c1_write(15,19,'');
             Window (10,12,69,15); clrscr; Window ( 1, 1,80,25);
             LogNam_C;
           until w=4
      else begin c2_write(15,50,''); write('Passwort hinzufgen');
                 Name:=ParamStr(3); crc:=0; for i:=1 to 5 do crc:=crc+ord(Name[i])*i-ord(Name[i]);
                 repeat LogNam_R; until (LogNam_p.crc1=crc) or eof(LogNam_d);
                 Seek(LogNam_d,FilePos(LogNam_d)-1);
                 repeat Pass2:='                               ';
                        c1_write(13,11,'Eingabe des Passwortes: ');
                        c2_write(13,35,Pass2); GotoXY(35,13); ReadLN(Pass2);
                 until length(Pass2)>3; i:=Pos(' ',Pass2);
                 if i>0
                 then begin Pass1:=Name+Copy(Pass2,1,i-1); Pass2:=Name+Pass2; end
                 else begin Pass1:=Name+Pass2;             Pass2:=Pass1;
                            while length(Pass2)<255 do Pass2:=Pass2+' ';
                      end;
{$IFDEF Debug}
c2_write(1,1,' '+Name+'/'+Pass1+'/'+Pass2);
{$ENDIF}
                 with LogNam_p do
                 begin crc1:=0; crc2:=0; crc3:=0;
                       for i:=1 to length(Name ) do crc1:=crc1+ord(Name [i])*i-ord(Name [i]);
                       for i:=1 to length(Pass1) do crc2:=crc2+ord(Pass1[i])*i-ord(Pass1[i]);
                       for i:=1 to length(Pass2) do crc3:=crc3+ord(Pass2[i])*i-ord(Pass2[i]);
                 end;
                 LogNam_W; LogNam_C;
           end;

      c1_write(1,1,'');
      if (ParamStr(1)='C') or (ParamStr(1)='c')
         then begin Window( 1, 1,80,25); clrscr;                    end
         else begin if (ParamStr(2)='U') or (ParamStr(2)='u')
                       then Window( 9, 7,70,16) else Window( 9, 9,70,21);
                       clrscr; Window(1,1,80,25); end;
      Demount_Log;
end.
