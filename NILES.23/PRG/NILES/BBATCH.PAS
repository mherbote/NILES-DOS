{$A-,B-,D-,E+,F-,I-,L-,N-,O-,R-,S-,V+}
{$M 16384,0,0 }
{$DEFINE Debug }
{$UNDEF  Debug }

{*******************************************
 * BBATCH.PAS                              *
 * Anfangsbedingungen des SYSTEMs setzen   *
 *                                         *
 *        (c) by NILES-SOFT 1988 VERS. 2.3 *
 *           Programmierer: Marcus Herbote *
 *******************************************}

uses   dos,crt,crt_,Fenster_,SysLog_,LogNam_,Batch_,Syshalt_,Mount_,nim_;

const  copyrc                      = '(c) 88,89 by NILES-SOFT';
       pc1                         = 'M o d u l :     B  B  A  T  C  H';
       pc2                         = 'V e r s i o n   2  .  3';
       pc3                         = '03.10.89';
       cfile : Array[1..3] of String[14] = ('C:\COMMAND.COM', 'C:\MOUNT.COM  ', 'C:\DEMOUNT.COM');

var    RenDat                      :           Text;
       crc,DEC                     :           Word;
       i                           :           Integer;
       path_dp                     :           String[80];
       Name,Pass1,Pass2            :           String;
       S_Rec                       :           SearchRec;

var formal1:str12;

procedure sys_halt(id:integer);
begin Demount_Log; Sys_halt1(id);
      {$IFDEF Debug} halt(1); {$ELSE} i:=0; repeat until i=1; {$ENDIF}
end;

function Datei:Boolean;
  var i:Integer;
begin i:=0;
      Assign(ip[1],path_bat2+'WURZEL'); Reset(ip[1]); if IOResult=0 then i:=i+1;
      Assign(ip[1],path_bat2+'0000'  ); Reset(ip[1]); if IOResult=0 then i:=i+1;
      if i=2 then Datei:=TRUE else Datei:=FALSE;
end;

procedure log;
begin SysLog_O; if not SysLog_exit then sys_halt(4);
      Seek(SysLog_d,FileSize(SysLog_d)-1); SysLog_R; SysLog_C;
      formal:=SysLog_p.bea;
      crc:=0; for i:=1 to 5 do crc:=crc+ord(formal[i])*i-ord(formal[i]);
      LogNam_O; if not LogNam_exit then sys_halt(1);
      repeat LogNam_R; until (LogNam_p.crc1=crc) or eof(LogNam_d);
      LogNam_C;
      if LogNam_p.crc1<>crc then sys_halt(3);
      for i:=1 to 8 do formal[i]:=chr(ord(LogNam_p.mpz[i])-(LogNam_p.crc1 and $FF));
      i:=1; repeat formal[0]:=chr(i); i:=i+1; until (formal[i]=' ') or (i>8);
end;

procedure exec_comm;
begin delete(cop[1],1,2);
      i:=pos(';',cop[1]); if i>0 then delete(cop[1],i,length(cop[1])-i+1);
      i:=pos(' ',cop[1]);
      if i=0
      then       cop[2]:=''
      else begin cop[2]:=copy(cop[1],i+1,length(cop[1])-i);
                 delete(cop[1],i,length(cop[1])-i+1);
           end;
      FindFirst(cop[1]+'.COM',AnyFile,S_Rec);
      if DosError=0
         then begin Writeln(ip[2],cop[1]+'.COM');
                    Writeln(ip[2],cop[2]);
              end
         else begin FindFirst(cop[1]+'.EXE',AnyFile,S_Rec);
                    if DosError=0 then begin Writeln(ip[2],cop[1]+'.EXE');
                                             Writeln(ip[2],cop[2]);
                                       end;
              end;
end;

begin {$IFDEF Debug} CheckBreak:=true; {$ELSE} CheckBreak:=false; {$ENDIF}
      c1_write(1,1,''); clrscr; f_bild:=true;
      fenster(1, 1, 3,80,24,'�','�','�','�','�','�','�','�',copyrc,pc1,pc2,pc3);
      s_env2:=''; s_env3:=''; path_dp:=path_progr; path_dp[1]:='E';

      for i:=1 to 3 do                            { Pfad C:\ bereinigen       }
      begin Assign(RenDat,cfile[i]); Reset(RenDat);
            if IOResult=0 then
               begin Close(RenDat); SetFAttr(RenDat,Archive); Erase(RenDat); end;
      end;

      Mount_Log; log; formal1:=formal;            { alte Men� - Daten l�schen }
      RmDir(path_bat1+formal1);
      if IOResult=5 then
         begin exec(path_progr+'DBATCH.EXE','d '+path_bat1+formal1+'\');
               RmDir(path_bat1+formal1);
         end;
      MkDir(path_bat1+'BATCH');
      if IOResult=5 then
         begin assign(ip[1],path_bat1+'BATCH'); rename(ip[1],path_bat1+formal1); end;

      exec(path_dp+'CLOCK.EXE','');                { Datum und Uhrzeit setzen  }

      Mount_Log; exec(path_progr+'AMT.EXE','N S'); { SYSLOG -Eintrag vornehmen }
      DEC:=DosExitCode;

      crc:=IOResult; Mount_Log; log;              { neue Men� - Daten laden   }
      RmDir(path_bat1+'BATCH'); crc:=IOResult;
      assign(ip[1],path_bat1+formal1); rename(ip[1],path_bat1+'BATCH'); crc:=IOResult;
      MkDir(path_bat1+'BATCH'); crc:=IOResult;
      if DEC=99 then begin {$IFDEF Debug} halt(1);
                                          {$ELSE} i:=0; repeat until i=1;
                                   {$ENDIF}
                             end;
      if formal<>formal1 then exec(path_progr+'DBATCH.EXE','d '+path_bat2);

      Assign(ip[1],path_bat2+'wurzel'); crc:=IOResult; reset(ip[1]);
      if ioresult<>0
      then begin Mount_Log; log;
                 exec(path_progr+'DBATCH.EXE','c '+'E:\BAT\'+formal+'\ '+path_bat2+' RH');
                 Assign(ip[1],path_bat2+'wurzel'); reset(ip[1]);
           end;

      repeat crc:=IOResult;
             if not Datei
                then begin c1_write(1,1,''); clrscr;
                           fenster(0,10, 9,70,16,'�','�','�','�','�','�','�','�','','','','');
                           gotoxy(20,12); write('Legen Sie bitte Ihre SYSTEM - Disk in Laufwerk A');
                           gotoxy(20,14); write('            Wenn bereit, dann <ENTER> dr�cken ! ');
                           ch:=readkey; Mount_Log; log;
                           exec(path_progr+'DBATCH.EXE','c '+'A:\bat\'+formal+'\ '+path_bat2+' RH');
                     end;
      until Datei;

      Demount_Log;

      ChDir('D:\UTILITYS\DRIVER');
      Assign(ip[2],path_bat2+'BATCH.BAT'); Rewrite(ip[2]);
      Assign(ip[1],path_bat2+'WURZEL'   ); Reset  (ip[1]);
      ini(1); ini(1); ini(1); w:=1;
      while (cop[1][1]='T') and not eof(ip[1]) do
      begin case cop[1][2] of
            ' ': begin exec_comm; w:=1; end;
            '*': begin c1_write(1,25,''); Window( 2, 6,79,23); ClrScr; Window( 1, 1,80,25);
                       i:=pos(';',cop[1]);
                       if i>0
                       then begin c2_write( 9,15,copy(cop[1],i+1,length(cop[1])-i)+': ');
                                  c2_write(10,15,copy(cop[1],3,i-3               ));
                            end
                       else begin c2_write(10,15,copy(cop[1],3,length(cop[1])-2)); end;
                       c1_write(12,20,'in das SYSTEM einbinden (J,N)? ');
                       gotoxy(1,25); if UpCase(ReadKey)='J' then begin exec_comm; w:=-1; end;
                 end;
            '+': if w=-1 then exec_comm;
            end;
            ini(1);
      end;
      Write(ip[2],#$1A); Close(ip[1]); Close(ip[2]); nim;
      Mount_Log; exec('E:\UTILITYS\BATCH\WPROTECT.COM','d:'); Demount_Log;
end.
