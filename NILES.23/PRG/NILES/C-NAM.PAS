{$R-,S-,I-,D-,F-,V+,B+,N-,L+ }
{$M 2500,0,0 }
{$DEFINE Debug }
{$UNDEF  Debug }

{******************************************************
 * C-NAM.PAS      automatisches Maschinentagebuch     *
 * L O G N A M  - Datei erstellen                     *
 *                                                    *
 *                   (c) by NILES-SOFT 1988 VERS. 2.3 *
 *                      Programmierer: Marcus Herbote *
 ******************************************************}

uses   dos,crt,crt_,Fenster_,SysLog_,LogNamO_,LogNam_,Mount_,Syshalt_;

const  copyrc                      = '(c) 88,89 by NILES-SOFT';
       pc1                         = 'M o d u l :     C  -  N  A  M';
       pc2                         = 'V e r s i o n   2  .  3';
       pc3                         = '03.05.89';

var    ch                          :           Char;
       i,user                      :           Integer;
       z                           :           LongInt;
       Name,Pass1,Pass2            :           String;
       crc                         :           Word;
       mpz                         :           String[8];

Label  Wei;

procedure sys_halt(id:integer);
begin Demount_Log; sys_halt1(id); halt(1); end;

function vorhanden:Boolean;
begin crc:=0; for i:=1 to 5 do crc:=crc+ord(Name[i])*i-ord(Name[i]);
      repeat LogNam_R; until (LogNam_p.crc1=crc) or eof(LogNam_d);
      if LogNam_p.crc1=crc
         then begin if color then c_write(17,11,red  ,yellow+blink,'Bearbeiter existiert schon')
                             else c_write(17,11,white,black +blink,'Bearbeiter existiert schon');
                    ch:=ReadKey;
                    vorhanden:=true;
              end
         else       vorhanden:=false;
end;

procedure LogNam_W1;
begin mpz:=LogNam_p.mpz;
      c1_write(14,11,'aktueller Menu - PATH - Name   : '); c2_write(14,44,mpz);
      c1_write(15,11,'aktuelles Nutzer-Password1     : '); c2_write(15,44,Pass1);
      c1_write(16,11,'aktuelles Nutzer-Password2     : '); c2_write(16,44,Pass2);
      Pass1:=Name+Pass1;
      if Length(Pass2)>0 then       Pass2:=Pass1+' '+Pass2
                         else begin Pass2:=Pass1;
                                    while length(Pass2)<255 do Pass2:=Pass2+' ';
                              end;
      with LogNam_p do
           begin crc1:=0; crc2:=0; crc3:=0;
                 for i:=1 to length(Name ) do crc1:=crc1+ord(Name [i])*i-ord(Name [i]);
                 for i:=1 to length(Pass1) do crc2:=crc2+ord(Pass1[i])*i-ord(Pass1[i]);
                 for i:=1 to length(Pass2) do crc3:=crc3+ord(Pass2[i])*i-ord(Pass2[i]);
           end;
      with LogNam_p do
           for i:=1 to 8 do mpz[i]:=chr(ord(mpz[i])+(crc1 and $FF));
      LogNam_W; LogNam_C; Delay(1000);
end;


(* Programmaufruf:   C-NAM   { C | * }   name   { menÅpfad | * }   pass1   [ pass2 ]
*)
begin {$IFDEF Debug} CheckBreak:=true; {$ELSE} CheckBreak:=false; {$ENDIF}
      c1_write(1,1,'');
      if (ParamStr(1)='C') or (ParamStr(1)='c')
         then clrscr
         else begin Window( 9, 7,70,18); clrscr; Window(1,1,80,25); end;
      fenster(1, 9, 7,70,18,'…','Õ','ª','∫','»','º','∫','Õ',copyrc,pc1,pc2,pc3);

      Mount_Log; LogNam_O; if not LogNam_exit then sys_halt(1);

      if ParamStr(1)='*'
         then begin if        ParamCount  < 4 then sys_halt(30);
                    if Length(ParamStr(2))<>5 then sys_halt(30);
                    Name:=ParamStr(2); c1_write(13,11,'Kurzbezeichnung des Bearbeiters: ');
                                       c2_write(13,44,Name);
                    if vorhanden then begin Demount_Log; halt(99); end;
                    Seek(LogNam_d,FileSize(LogNam_d)); mpz:=ParamStr(3);
                    if mpz='*'
                       then LogNam_p.mpz:='DEMO1   '
                       else if Length(ParamStr(3))>8
                               then move(mpz[1],LogNam_p.mpz[1],8)
                               else begin LogNam_p.mpz:='        ';
                                          move(mpz[1],LogNam_p.mpz[1],Length(mpz));
                                          for i:=Length(mpz)+1 to 8 do LogNam_p.mpz[i]:=' ';
                                    end;
                    Pass1:=ParamStr(4);
                    if ParamCount>4 then Pass2:=ParamStr(5) else Pass2:='';
                    LogNam_W1;
              end
         else begin LogNamO_O; user:=0;
                    if not LogNamO_exit
                       then begin c2_Write(13,15,'Die Datei: "LOGNAMEO.DAT" kann nicht gefunden werden !');
                                  c2_Write(15,20,'Weiter, dann beliebige Taste drÅcken');
                                  ch:=readkey; c1_write(1,1,'');
                                  if (ParamStr(1)='C') or (ParamStr(1)='c')
                                     then begin Window( 1, 1,80,25); clrscr;                    end
                                     else begin Window( 9, 9,70,16); clrscr; Window(1,1,80,25); end;
                                     Demount_Log; halt(99);
                            end;
                    repeat LogNam_O; LogNamO_R;
                           with LogNamO_p do
                           begin Name:=bea; c1_write(13,11,'Kurzbezeichnung des Bearbeiters: ');
                                            c2_write(13,44,Name); c1_Write(11,44,Bearb);
                                 if vorhanden then begin LogNam_C; Goto Wei; end;
                                 Seek(LogNam_d,FileSize(LogNam_d));
                                 if (check[1]=' ') and (check[2]=' ')
                                    then begin user:=user+1; Str(user:4,Pass1);
                                               Pass1:='user'+Pass1; Pass2:='';
                                               for i:=1 to Length(Pass1) do
                                                   if Pass1[i]=' ' then Pass1[i]:='0';
                                         end
                                    else begin i:=pos(' ',check);
                                               if i=0 then begin Pass1:=check;
                                                                 Pass2:='';
                                                           end
                                                      else begin Pass1:=copy(check,1,i-1);
                                                                 Pass2:=check;
                                                                 Delete(Pass2,1,i);
                                                                 i:=pos(' ',Pass2);
                                                                 if i<>0 then Delete(Pass2,i+1,Length(Pass2)-i);
                                                           end;
                                         end;
                                 if mpz='........' then LogNam_p.mpz:='DEMO1   '
                                                   else Move(mpz[1],LogNam_p.mpz[1],8);
                           end;
                           LogNam_W1;
Wei:                until eof(LogNamO_d);
                    LogNamO_C;
              end;

      c1_write(1,1,'');
      if (ParamStr(1)='C') or (ParamStr(1)='c')
         then begin Window( 1, 1,80,25); clrscr;                    end
         else begin Window( 9, 7,70,18); clrscr; Window(1,1,80,25); end;
      Demount_Log;
end.
