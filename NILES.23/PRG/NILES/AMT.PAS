{$R-,S-,I-,D-,F-,V+,B+,N-,L+ }
{$M 5000,0,0 }
{$DEFINE Debug }
{$UNDEF  Debug }

{******************************************************
 * AMT.PAS        automatisches Maschinentagebuch     *
 * S Y S L O G  - Eintragung vornehmen                *
 *                                                    *
 *                   (c) by NILES-SOFT 1988 VERS. 2.3 *
 *                      Programmierer: Marcus Herbote *
 ******************************************************}

uses   dos,crt,crt_,Fenster_,SysLog_,LogNam_,Batch_,Syshalt_,Mount_;

const  copyrc                      = '(c) 88,89 by NILES-SOFT';
       pc1                         = 'M o d u l :     A  M  T';
       pc2                         = 'V e r s i o n   2  .  3';
       pc3                         = '15.09.89';

var
       i,iP                        :           Integer;
       z                           :           LongInt;
       crc,cr1,cr2,cr3             :           Word;
       Name,Pass1,Pass2            :           string[255];
       J,J1,J2,M,M1,M2,D,D1,D2,D11 :           Word;
       S,S1,S2,N,N1,N2,U,T1,T2,T11 :           Word;
       J3,M3,D3,H,Mi               :           Word;
       wei                         :           Boolean;
       Code                        :           Integer;
       hilf,par2,par3,par4         :           string[255];

procedure sys_halt(id:Integer);
begin SysLog_C; LogNam_C; Demount_Log; sys_halt1(id); halt(99); end;

function vorhanden:Boolean;
begin c1_Write(15,14,'                       ');
      repeat Name:='.....';
             c1_Write(13,14,'Bearbeiterkennzeichen ==>                   ');
             c2_Write(13,39,Name);
             gotoxy(39,13); Readln(Name);
      until length(Name)=5;
      c1_Write(13,39,Name);
      crc:=0; for i:=1 to 5 do crc:=crc+ord(Name[i])*i-ord(Name[i]);
      LogNam_O; repeat LogNam_R; until (LogNam_p.crc1=crc) or eof(LogNam_d);
      if LogNam_p.crc1=crc then       vorhanden:=true
                           else begin vorhanden:=false;
                                      if color
                                         then c_Write(15,14,red  ,yellow+blink,'Kennzeichen unzulaessig')
                                         else c_Write(15,14,white,black +blink,'Kennzeichen unzulaessig');
                                end;
end;

procedure bea_pass;
begin while not vorhanden do for z:=1 to 400000 do ;
      Seek(LogNam_d,FilePos(LogNam_d)-1); LogNam_R;
      Pass1:=Name ; while length(Pass1)<100 do Pass1:=Pass1+' ';
      Pass2:=Pass1; while length(Pass2)<255 do Pass2:=Pass2+' ';
      cr1:=0; cr2:=0; cr3:=0;
      for i:=1 to length(Name ) do cr1:=cr1+ord(Name [i])*i-ord(Name [i]);
      for i:=1 to length(Pass1) do cr2:=cr2+ord(Pass1[i])*i-ord(Pass1[i]);
      for i:=1 to length(Pass2) do cr3:=cr3+ord(Pass2[i])*i-ord(Pass2[i]);
      if (cr2=LogNam_p.crc2) and (cr3=LogNam_p.crc3)
         then begin LogNam_C; SysLog_C;
                    exec('E:\UTILITYS\BATCH\E-PASS.EXE','N A '+Name); Mount_Log;
                    LogNam_O; SysLog_O;
                    repeat LogNam_R; until (LogNam_p.crc1=crc) or eof(LogNam_d);
                    Pass1:=Name ; while length(Pass1)<100 do Pass1:=Pass1+' ';
                    Pass2:=Pass1; while length(Pass2)<255 do Pass2:=Pass2+' ';
                    cr1:=0; cr2:=0; cr3:=0;
                    for i:=1 to length(Name ) do cr1:=cr1+ord(Name [i])*i-ord(Name [i]);
                    for i:=1 to length(Pass1) do cr2:=cr2+ord(Pass1[i])*i-ord(Pass1[i]);
                    for i:=1 to length(Pass2) do cr3:=cr3+ord(Pass2[i])*i-ord(Pass2[i]);
              end;
      iP:=0;
      repeat iP:=iP+1; if iP=4 then sys_halt(5);
             repeat Pass1:='                                   ';
                    c1_write(15,14,'bitte PassWort eingeben > ');
                    c2_write(15,39,Pass1); Pass1[0]:=chr(1);
                    repeat gotoxy(38+ord(Pass1[0]),15); ch:=ReadKey;
                           case ch of
                            #0: begin ch:=ReadKey;
                                      case ch of
                                      #71: begin Pass1:='                                   ';
                                                 c2_write(15,39,Pass1);
                                                 Pass1[0]:=chr(1);
                                           end;
                                      #75: begin write(' ');
                                                 if ord(Pass1[0])>1
                                                 then Pass1[0]:=chr(ord(Pass1[0])-1);
                                           end;
                                      end;
                                end;
                            #8: begin write(' ');
                                      if ord(Pass1[0])>1 then Pass1[0]:=chr(ord(Pass1[0])-1);
                                end;
                           #13: ;
                           else begin write('*'); Pass1[ord(Pass1[0])]:=ch;
                                      if ord(Pass1[0])<100 then Pass1[0]:=chr(ord(Pass1[0])+1);
                                end;
                           end;
                    until ch=#13;
             until length(Pass1)>3; i:=Pos(' ',Pass1);
             if i>0 then Pass1:=Name+Copy(Pass1,1,i-1)
                    else Pass1:=Name+Pass1;
             cr1:=0;
             for i:=1 to length(Pass1) do cr1:=cr1+ord(Pass1[i])*i-ord(Pass1[i]);
             if LogNam_p.crc2=cr1
                then wei:=true
                else begin wei:=false;
                           if color
                              then c_write(17,14,red  ,yellow+blink,'PassWort ungltig')
                              else c_write(17,14,white,black +blink,'PassWort ungltig');
                           for z:=1 to 200000 do ;
                           c1_write(17,14,'                 ');
                     end;
      until wei;
      GetDate(J1,M1,D1,D11); GetTime(S1,N1,T1,T11);
end;

procedure log_write(Pos:LongInt);
begin
{$IFDEF Debug}
      gotoxy(1,1); clreol; write('pppppppp,bbbbb,tttttttt,jjjjmmtt,ssss,eeee,mmmm');
      gotoxy(1,2); clreol; with SysLog_p do write(proj,',',bea,',',dwg,',',dat,',',tims,',',time,',',min,sk);
      gotoxy(1,3); clreol; write(D1:2,'.',M1:2,'.',J1:2,'  ',S1:2,':',N1);
      gotoxy(1,4); clreol; write(D2:2,'.',M2:2,'.',J2:2,'  ',S2:2,':',N2,'  ',T11);
      gotoxy(1,5); clreol; write(H,'  ',Mi); Readln;
{$ELSE}
      Seek(SysLog_d,Pos); SysLog_W;
{$ENDIF}
end;

procedure log_off(l_off:Boolean);
begin Seek(SysLog_d,FileSize(SysLog_d)-1); SysLog_R;
      if (SysLog_p.time='....') and (SysLog_p.min='....')
      then
         begin GetDate(J2,M2,D2,D11); GetTime(S2,N2,T2,T11);
           with SysLog_p do
           begin str(S2:2,hilf); Pass2:=      hilf;
                 str(N2:2,hilf); Pass2:=Pass2+hilf; move(Pass2[1],time[1],4);
                 for i:=1 to 4 do if time[i]=' ' then time[i]:='0';
                 val(copy(dat ,1,4),J1,Code); val(copy(dat ,5,2),M1,Code);
                 val(copy(dat ,7,2),D1,Code);
                 val(copy(tims,1,2),S1,Code); val(copy(tims,3,2),N1,Code);
           end;
           if  J1>J2                             then sys_halt(10);
           if (M1>M2)  and (M1<>12) and (D1<>31) then sys_halt(10);
           if (M1=M2)  and (D1> D2)              then sys_halt(10);
           if (D1<>D2) and (S1<=S2) then H:=24 else H:=0;
           if (D1=D2)  and (S1=S2)
              then begin H:=0; Mi:=N2-N1 end
              else if S2>S1 then begin H:=H+(S2-S1);
                                       if N2>=N1 then       Mi:=N2-N1
                                                 else begin Mi:=(60-N1)+N2; H:=H-1; end;
                                 end
                            else begin H:=(24-S1)+S2;
                                       if N2>N1  then       Mi:=N2-N1
                                                 else begin Mi:=(60-N1)+N2; H:=H-1; end;
                                 end;
           T11:=(H*60)+Mi;
           str(T11:4,hilf); move(hilf[1],SysLog_p.min[1],4);
           log_write(FileSize(SysLog_d)-1);
         end
      else if l_off then sys_halt(2)
                    else begin GetDate(J2,M2,D2,D11); GetTime(S2,N2,T2,T11);
                               with SysLog_p do
                               begin val(copy(dat ,1,4),J1,Code); val(copy(dat ,5,2),M1,Code);
                                     val(copy(dat ,7,2),D1,Code);
                               end;
                         end;
      if not l_off then begin val(copy(SysLog_p.time,1,2),S1,Code);
                              val(copy(SysLog_p.time,3,2),N1,Code);
                              J3:=J2; M3:=M2; D3:=D2; H:=S1; Mi:=N1;
                        end;
end;


begin {$IFDEF Debug} CheckBreak:=true; {$ELSE} CheckBreak:=false; {$ENDIF}
      c1_write(1,1,'');
      if (ParamStr(1)='C') or (ParamStr(1)='c')
         then       clrscr
         else begin Window(7,6,75,18); clrscr; Window(1,1,80,25); end;
      par2:=paramstr(2);
      if UpCase(par2[1])<>'C' then
         fenster(1, 7, 6,75,18,'É','Í','»','º','È','¼','º','Í',copyrc,pc1,pc2,pc3);

      Mount_Log; LogNam_O; SysLog_O;

      if not LogNam_exit then sys_halt(1);

      case upcase(par2[1]) of
      'S': if SysLog_exit
              then begin log_off(False); bea_pass;
{$IFDEF Debug} Writeln;
               Writeln(SysLog_p.Proj,'///',SysLog_p.dwg,'///',SysLog_p.bea);
               Writeln(J1,'-',J3,'   ',M1,'-',M3,'   ',D1,'-',D3);
               Writeln(S1,'-',H ,'   ',N1,'-',Mi); Readln;
{$ENDIF }
                         if (SysLog_p.Proj='-SYSTEM-') and (SysLog_p.dwg='-ANLAUF-') and
                            (SysLog_p.bea =Name ) and
                            (J1=J3) and (M1=M3) and (D1=D3) and
                            (S1=H ) and (N1=Mi)
                         then with SysLog_p do
                              begin time:='....'; min :='....';
                                    log_write(FileSize(SysLog_d)-1);
                              end
                         else with SysLog_p do
                              begin proj:='-SYSTEM-'; dwg :='-ANLAUF-'; time:='....'; min :='....';
                                    str(J1:4,hilf); Pass2:=      hilf;
                                    str(M1:2,hilf); Pass2:=Pass2+hilf;
                                    str(D1:2,hilf); Pass2:=Pass2+hilf; move(Pass2[1],dat [1],8);
                                    str(S1:2,hilf); Pass2:=      hilf;
                                    str(N1:2,hilf); Pass2:=Pass2+hilf; move(Pass2[1],tims[1],4);
                                    for i:=1 to 8 do if dat [i]=' ' then dat [i]:='0';
                                    for i:=1 to 4 do if tims[i]=' ' then tims[i]:='0';
                                    sk  :=#13#10;     move(Name[1],bea[1],5);
                                    log_write(FileSize(SysLog_d));
                              end;
                   end
              else begin Rewrite(SysLog_d); bea_pass;
                         with SysLog_p do
                         begin proj:='-SYSTEM-'; dwg :='-ANLAUF-'; time:='....'; min :='....';
                               str(J1:4,hilf); Pass2:=      hilf;
                               str(M1:2,hilf); Pass2:=Pass2+hilf;
                               str(D1:2,hilf); Pass2:=Pass2+hilf; move(Pass2[1],dat [1],8);
                               str(S1:2,hilf); Pass2:=      hilf;
                               str(N1:2,hilf); Pass2:=Pass2+hilf; move(Pass2[1],tims[1],4);
                               for i:=1 to 8 do if dat [i]=' ' then dat [i]:='0';
                               for i:=1 to 4 do if tims[i]=' ' then tims[i]:='0';
                               sk  :=#13#10;     move(Name[1],bea[1],5);
                               log_write(0);
                         end;
                   end;
      'C': if SysLog_exit
              then begin log_off(True);
                         par3:=ParamStr(3); for i:=length(par3) to 8 do par3:=par3+' ';
                         par4:=Paramstr(4); for i:=length(par4) to 8 do par4:=par4+' ';
                         par3[0]:=chr(8); par4[0]:=chr(8);
                         if (par3=SysLog_p.Proj) and (par4=SysLog_p.dwg)
                         then with SysLog_p do
                              begin time:='....'; min :='....';
                                    log_write(FileSize(SysLog_d)-1);
                              end
                         else with SysLog_p do
                              begin move(par3[1],Proj[1],8); move(par4[1],dwg [1],8);
                                    str(J2:4,hilf); Pass2:=      hilf;
                                    str(M2:2,hilf); Pass2:=Pass2+hilf;
                                    str(D2:2,hilf); Pass2:=Pass2+hilf; move(Pass2[1],dat [1],8);
                                    str(S2:2,hilf); Pass2:=      hilf;
                                    str(N2:2,hilf); Pass2:=Pass2+hilf; move(Pass2[1],tims[1],4);
                                    for i:=1 to 8 do if dat [i]=' ' then dat [i]:='0';
                                    for i:=1 to 4 do if tims[i]=' ' then tims[i]:='0';
                                    time:='....'; min :='....';
                                    log_write(FileSize(SysLog_d));
                              end;
                   end
              else       sys_halt(2);
      'E': if SysLog_exit then log_off(True) else sys_halt(2);
      end;

      SysLog_C; LogNam_C; Demount_Log;

      c1_write(1,1,'');
      if (ParamStr(1)='C') or (ParamStr(1)='c')
         then begin Window( 1, 1,80,25); clrscr;                    end
         else begin Window( 7, 6,75,18); clrscr; Window(1,1,80,25); end;
      halt(0);
end.
