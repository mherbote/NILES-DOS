{$R-,S+,I-,D+,F-,V+,B+,N-,L+ }
{$M 50000,0,0 }
{$DEFINE Debug }
{$UNDEF  Debug }

{*******************************************
 * IBATCH.PAS                              *
 * Installierung des SYSTEMs   NILES-DOS   *
 *                                         *
 *        (c) by NILES-SOFT 1988 VERS. 2.3 *
 *           Programmierer: Marcus Herbote *
 *******************************************}

uses   dos,crt,crt_,Fenster_,Syshalt_,SysLog_,LogNam_,Mount1_,Handle_,Wahl_,EditZ_;

const  copyrc                      = '(c) 88,89 by NILES-SOFT';
       pc1                         = 'M o d u l :     I  B  A  T  C  H';
       pc2                         = 'V e r s i o n   2  .  3';
       pc3                         = '15.09.89';

var    i,j,k,DEC,Name_I            :               Integer;
       _j,_k,i_j,i_k               :               Byte;
       S_Rec                       : { record Fill : array[1..21] of byte;
                                              Attr : Byte;
                                              Time : LongInt;
                                              Size : LongInt;
                                              Name : string[12];
                                       end}
                                     SearchRec;
       Name                        : array[1..    7] of string[ 13];
       Name_C                      : array[1..   40] of string[ 13];
       Name_A                      : array[1..   40] of string[ 13];
       Name_N                      : array[1..   40] of string[ 13];
       path_d     ,path_progr      :                    string[ 80];
       path_progr2,path_progr3     :                    string[ 80];
       Attr                        :                    Word;
       bbb,byt2                    :                    Byte;
       comm,idat                   : file            of Byte;
       config                      :                    Text;
       First                       :                    Boolean;
       hilf,hilf1,command,gken,liz :                    string[255];
       J1,J2,M,M1,M2,D1,D2,D11     :                    Word;
       S1,N1,T1                    :                    Word;
       Name_,Pass1,Pass2           :                    string;
       hilfc                       : array[0..  255] of byte absolute hilf;
       Reg                         :                    Registers;
       BufferHead                  :                    Integer absolute $40:$1a;
       BufferTail                  :                    Integer absolute $40:$1c;
       ii,iii                      :                    LongInt;
       ok                          :                    Char;
       mmm                         :                    Boolean;

procedure Sys_Halt(id:Integer);
begin Sys_Halt1(id); {$IFDEF Debug} halt(1); {$ELSE} i:=0; while i=0 do ; {$ENDIF} end;

procedure PutChar(c:char);
begin inline($FA); { Disable Interrupts }
      memw[$40:BufferTail]:=ord(c); BufferTail:=BufferTail+2;
      if BufferTail>=$3E then BufferTail:=$1E;
      inline($FB);    { Enable  Interrupts }
end;

function NextByte_idat:Char;
  var ch:Byte;
begin Read(idat,ch); NextByte_idat:=chr(ch-i_j-i_j+i_k); i_k:=i_k+i_j; end;

function NextString:string;
  var ch  : Char;
      Str : string[255];
begin Str[0]:=#0;
      repeat ch:=NextByte_idat;
             case ch of #10: ;
                        #13: ch:=#255;
                        ',': ch:=#255;
                        else begin Str[        0  ]:=chr(ord(Str[0])+1);
                                   Str[ord(Str[0])]:=ch;
                             end
             end;
      until ch=#255;
      NextString:=Str;
end;

function NextString1:string;
  var ch  : Char;
      Str : string[255];
begin Str[0]:=#0;
      repeat ch:=NextByte_idat;
             case ch of #10: ;
                        #13: ch:=#255;
                        else begin Str[        0  ]:=chr(ord(Str[0])+1);
                                   Str[ord(Str[0])]:=ch;
                             end
             end;
      until ch=#255;
      NextString1:=Str;
end;

procedure deck(titel:string);
  var f1,f2,f3,f4:Integer;
begin if color then begin f1:=red; f2:=yellow; f3:=red; f4:=white; end
               else begin f2:=white; f1:=black; f4:=white; f3:=black; end;
      c_write( 1, 1,f1,f2,''); Window( 1, 1,80,25); clrscr;
      fenster(1, 1, 1,80,24,'…','Õ','ª','∫','»','º','∫','Õ',copyrc,pc1,pc2,pc3);
      c_write( 5, 5,f1,f2,'±±±±      ±±   ±±   ±±           ±±±±±±±±±±    ±±±±±±±±±');
      c_write( 6, 5,f1,f2,'±± ±±     ±±   ±±   ±±           ±±            ±±');
      c_write( 7, 5,f1,f2,'±±  ±±    ±±   ±±   ±±           ±±            ±±');
      c_write( 8, 5,f1,f2,'±±   ±±   ±±   ±±   ±±           ±±±±±±±       ±±±±±±±±±   ±±±±±±±');
      c_write( 9, 5,f1,f2,'±±    ±±  ±±   ±±   ±±           ±±                   ±±');
      c_write(10, 5,f1,f2,'±±     ±± ±±   ±±   ±±           ±±                   ±±');
      c_write(11, 5,f1,f2,'±±      ±±±±   ±±   ±±±±±±±±±±   ±±±±±±±±±±    ±±±±±±±±±');
      c_write(13,40,f3,f4,'∞∞∞∞∞∞∞∞∞       ∞∞∞∞∞∞∞     ∞∞∞∞∞∞∞∞∞');
      c_write(14,40,f3,f4,'∞∞      ∞∞     ∞∞     ∞∞    ∞∞');
      c_write(15,40,f3,f4,'∞∞       ∞∞   ∞∞       ∞∞   ∞∞');
      c_write(16,40,f3,f4,'∞∞       ∞∞   ∞∞       ∞∞   ∞∞∞∞∞∞∞∞∞');
      c_write(17,40,f3,f4,'∞∞       ∞∞   ∞∞       ∞∞          ∞∞');
      c_write(18,40,f3,f4,'∞∞      ∞∞     ∞∞     ∞∞           ∞∞');
      c_write(19,40,f3,f4,'∞∞∞∞∞∞∞∞∞       ∞∞∞∞∞∞∞     ∞∞∞∞∞∞∞∞∞');
      c2_write(22,10,'I  N  S  T  A  L  L  A  T  I  O  N  S  -  P r o g r a m m');
      c2_write(23,10,titel);
      c2_write(25,55,'<ENTER> fÅr weiter !'); readln;
end;


begin {$IFDEF Debug} CheckBreak:=true; {$ELSE} CheckBreak:=false; {$ENDIF}
      deck('                                          Start p h a s e');
      c1_write(1,1,''); Window( 1, 1,80,25); clrscr; mmm:=FALSE;
      fenster(1, 1, 1,80,24,'…','Õ','ª','∫','»','º','∫','Õ',copyrc,pc1,pc2,pc3);
      GetDate(J1,M1,D1,D11); GetTime(S1,N1,T1,D11);

      Assign(idat,'\INSTALL.DAT'); Reset(idat);
      if IOResult<>0 then Sys_Halt(20); i_j:=$52; i_k:=$41;
      while NextByte_idat<>'#' do ; byt2:=i_j-i_k; hilf:=NextByte_idat;
      liz:=NextString; if length(liz)<>14 then Sys_Halt(20);

      path_d     :=NextString; path_progr :=NextString; path_d:=''; { }
      path_progr2:=NextString; path_progr3:=NextString;
      command:=path_progr+'COMMAND.COM'; hilf:=NextString;
      k:=0; repeat k:=k+1; Name_C[k]:=NextString; until Name_C[k]='#'; k:=k-1;

      FindFirst('C:\*.*',ReadOnly+Hidden+SysFile+Directory,S_Rec); i:=0;
      while (DosError=0) and (i<7) do
      begin i:=i+1; Name[i]:=S_Rec.Name; FindNext(S_Rec); end;
      while (DosError=0) do
      begin i:=i+1; FindNext(S_Rec); end;
      k:=i;
      for i:=1 to 7 do
          begin First:=false;
                for j:=1 to 7 do if Name[i]=Name_C[j] then First:=True;
                if First then k:=k-1;
          end;
      if k>0 then First:=false else First:=true;

      if First
      then begin c2_write( 5, 3,'N  I  L  E  S  - D O S   - ERST-Installierung');
                 k:=0; repeat k:=k+1;                Name_A[k]:=NextString;
                              if Name_A[k]<>'#' then Name_N[k]:=NextString;
                       until Name_A[k]='#'; k:=k-1; Name_I:=k;
                 i:=1; ii:=0;
                 repeat FindFirst(path_d+Name_N[i],AnyFile,S_Rec);
                        if DosError=0 then ii:=ii+1;
                        i:=i+1;
                 until i>Name_I;
                 if ii<>Name_I then Sys_Halt(20);
{ GerÑtekennung eingeben }
                 repeat hilf:='..............';
                        c1_write( 7,10,'Geben Sie bitte Ihre GerÑtekennung ein:');
                        c2_write( 7,50,hilf);
                        GotoXY(50, 7); Readln(hilf);
                 until (length(hilf)>4) and (length(hilf)<15);
                 c1_write( 7,50,hilf); gken:='              ';
                 for i:=1 to length(hilf) do gken[i]:=hilf[i];
{ Modifikation von  COMMAND.COM }
                 repeat repeat hilf:='..............';
                               c1_write( 8,10,'PassWord von Laufwerk E eingeben      :');
                               c2_write( 8,50,hilf);
                               GotoXY(50, 8); Readln(hilf);
                        until (length(hilf)>4) and (length(hilf)<15);
                        c1_write( 8,50,'**************');
                        inline($FA); BufferHead:=$1E; BufferTail:=$1E; inline($FB);
                        j:=length(hilf); for i:=1 to j do PutChar(hilf[i]); PutChar(^M);
                        Reg.AH:=$35; Reg.AL:=$10; MsDos(Reg); i:=Reg.ES; j:=Reg.BX; k:=$CF;
                        Reg.AH:=$25; Reg.AL:=$10; Reg.DS:=Seg(k); Reg.DX:=Ofs(k); MsDos(Reg);
                        exec('C:\DEMOUNT.COM','e:'); exec('C:\MOUNT.COM','e:');
                        DEC:=DosExitCode;
                        Reg.AH:=$25; Reg.AL:=$10; Reg.DS:=i; Reg.DX:=j; MsDos(Reg);
                        if DEC=1 then
                        begin c1_write( 1, 1,''); Window( 9, 9,79,23); clrscr;
                              c2_write(10,10,'Falsches PassWort eingegeben');
                              c1_write(15,20,'<ENTER> fÅr weiter !');
                              Readln;
                              c1_write( 1, 1,''); Window( 9, 9,79,23); clrscr;
                                                  Window( 1, 1,80,25);
                        end;
                 until DEC=0;
                 Assign(comm,'C:\COMMAND.COM'); SetFAttr(comm,Archive); Reset(comm);
                 k:=FileSize(comm); j:=k-(k div 128)*128;
                 if j<64 then for i:=k to k+128 do
                                  begin Seek(comm,i); bbb:=Random(255); Write(comm,bbb); end
                         else for i:=k to k+j   do
                                  begin Seek(comm,i); bbb:=Random(255); Write(comm,bbb); end;
                 bbb:=length(hilf); Seek(comm,FileSize(comm)-33); Write(comm,bbb);
                 for i:=1 to length(hilf) do
                     begin bbb:=hilfc[i]+i+i+i; Seek(comm,FileSize(comm)-2*i); Write(comm,bbb); end;
                 Close(comm);
{ Modifikation von  CONFIG.SYS }
                 hilf:=NextString; Assign (config,hilf);
                 SetFAttr(config,Archive); Rewrite(config);
                 repeat hilf:=NextString1;
                        if hilf<>'#' then Writeln(config,hilf);
                 until hilf='#';
                 Close  (config); SetFAttr(config,Archive+ReadOnly);
{ Anlegen der benîtigten Pfade und umkopieren von Dateien }
{ C-Pfade }      repeat hilf:=NextString; if hilf<>'#' then MkDir(hilf);
                 until hilf='#';
{ D-Pfade }      repeat hilf:=NextString; if hilf<>'#' then MkDir(hilf);
                 until hilf='#';

{ COMM,Mount }   hilf1:=NextString; hilf:='/C copy c:\'+hilf1+path_progr+hilf1+' >NUL';
                 exec('C:\COMMAND.COM',hilf); Delete(hilf1,length(hilf1),1);
                 Assign(comm,'C:\'+hilf1); SetFAttr(comm,Archive); Erase(comm);
                 repeat hilf1:=NextString;
                        if hilf1<>'#' then
                           begin hilf:='/C copy c:\'+hilf1+path_progr+hilf1+' >NUL';
                                 exec(command,hilf);
                                 hilf:='/C copy c:\'+hilf1+path_progr2+hilf1+' >NUL';
                                 exec(command,hilf); Delete(hilf1,length(hilf1),1);
                                 Assign(comm,'C:\'+hilf1); SetFAttr(comm,Archive); Erase(comm);
                                 Assign(comm,path_progr +hilf1); SetFAttr(comm,ReadOnly);
                                 Assign(comm,path_progr2+hilf1); SetFAttr(comm,ReadOnly);
                           end;
                 until hilf1='#';
{ E-Pfade }      repeat hilf:=NextString; if hilf<>'#' then MkDir(hilf);
                 until hilf='#';
{ Dateien laden und aufblÑhen }
                 _j:=$21; _k:=$32; i:=IOResult; i:=1;
                 repeat c1_write(11,10,'bearbeitete Datei: '+path_d+Name_N[i]+'            ');
                        c1_write(12,10,'Byte             :         von ');
                        Handle_Open  (H1_,$00,path_d    +Name_N[i]); write(FS:7); FS:=0;
                        Handle_Create(H2_,$00,'D:\WORK\'+Name_A[i]);
                        while (Handle_Read(H1_,DTAl)) and (FS1>0) do
                        begin for iii:=1 to FS1 do
                              begin c2_write(12,29,''); 
                                    DTA_[iii]:=DTA_[iii]-_j-_j+_k; _k:=_k+_j;
                              end;
                              Handle_Write(H2_,FS1); FS:=FS+FS1; Write(FS:7);
                        end;
                        Handle_Close(H1_); Handle_Close(H2_); i:=i+1; _j:=_k;
                 until i>Name_I;
                 c1_write(12,29,''); write(FS:7);
{ PKXARC /r }    hilf1:='D:\WORK\'+Name_A[1];
                 for ii:=2 to Name_I do
                 begin c2_write(15,10,'bearbeitete Archiv-Datei: '+Name_A[ii]+'          ');
                       hilf:='/r D:\WORK\'+Name_A[ii];
                       case ii of 2: hilf:=hilf+' D:\UTILITYS\NC\';
                                  3: hilf:=hilf+' D:\WORK\';
                       end;
                       exec(command,'/C '+hilf1+hilf+' >NUL');
                       if ii=2 then exec(command,'/C del D:\WORK\'+Name_A[2]+' >NUL');
                 end;
                 exec(command,'/C '+hilf1+'/r D:\WORK\'+Name_A[2]+' D:\BAT\'+' >NUL');
{ path_progr2 }  c2_write(15,10,'bearbeiteter   P f a d : '+path_progr2+'          ');
                 repeat hilf:=NextString;
                        if hilf<>'#' then
                        begin Assign(comm,'D:\WORK\'+hilf); SetFAttr(comm,Archive);
                              exec(command,'/C copy D:\WORK\'+hilf+path_progr2+hilf+' >NUL');
                              Delete(hilf,length(hilf),1);
                              Assign(comm,path_progr2+hilf); SetFAttr(comm,ReadOnly);
                        end;
                 until hilf='#';
{ path_progr  }  c2_write(15,10,'bearbeiteter   P f a d : '+path_progr +'          ');
                 repeat hilf:=NextString;
                        if hilf<>'#' then
                        begin Assign(comm,'D:\WORK\'+hilf); SetFAttr(comm,Archive);
                              exec(command,'/C copy D:\WORK\'+hilf+path_progr+hilf+' >NUL');
                              Delete(hilf,length(hilf),1);
                              Assign(comm,path_progr+hilf); SetFAttr(comm,ReadOnly);
                        end;
                 until hilf='#';
{             }  Assign(comm,command); Reset(comm); k:=FileSize(comm);
                 Seek(comm,k-33); Read(comm,bbb); j:=bbb;
                 BufferHead:=$1E; BufferTail:=$1E;
                 for i:=1 to j do
                     begin Seek(comm,k-2*i); Read(comm,bbb); PutChar(chr(bbb-i-i-i)); end;
                 Close(comm); PutChar(^M);
                 Reg.AH:=$35; Reg.AL:=$10; MsDos(Reg); i:=Reg.ES; j:=Reg.BX; k:=$CF;
                 Reg.AH:=$25; Reg.AL:=$10; Reg.DS:=Seg(k); Reg.DX:=Ofs(k); MsDos(Reg);
                 exec(path_progr+'COMMAND.COM','/C '+path_progr+'MOUNT.COM e:');
                 Reg.AH:=$25; Reg.AL:=$10; Reg.DS:=i; Reg.DX:=j; MsDos(Reg);
{ path_progr3 }  c2_write(15,10,'bearbeiteter   P f a d : '+path_progr3+'          ');
                 repeat hilf:=NextString;
                        if hilf<>'#' then
                        begin Assign(comm,'D:\WORK\'+hilf); SetFAttr(comm,Archive);
                              exec(command,'/C copy D:\WORK\'+hilf+path_progr3+hilf+' >NUL');
                              Assign(comm,path_progr3+hilf); SetFAttr(comm,ReadOnly);
                        end;
                 until hilf='#';
{ ..\START_SY }  hilf1:=NextString;
                 c2_write(15,10,'bearbeiteter   P f a d : '+hilf1      +'          ');
                 repeat hilf:=NextString;
                        if hilf<>'#' then
                        begin Assign(comm,'D:\WORK\'+hilf); SetFAttr(comm,Archive);
                              exec(command,'/C copy D:\WORK\'+hilf+hilf1+hilf+' >NUL');
                              Assign(comm,hilf1+hilf); SetFAttr(comm,ReadOnly);
                        end;
                 until hilf='#';
                 if not color then begin Assign(comm,hilf1+'0000');
                                         SetFAttr(comm,Archive); Reset(comm);
                                         bbb:=ord('0'); Seek(comm,13); Write(comm,bbb);
                                         Close(comm); SetFAttr(comm,ReadOnly);
                                   end;
{ C:\BAT      }  hilf1:=NextString;
Write(hilf1);
Readln;
                 c2_write(15,10,'bearbeiteter   P f a d : '+hilf1      +'          ');
                 repeat hilf:=NextString;
                        if hilf<>'#' then
                        begin Assign(comm,'D'+hilf1+hilf); SetFAttr(comm,Archive);
                              exec(command,'/C copy D'+hilf1+hilf+'C'+hilf1+hilf+' >NUL');
                              Erase (comm);
                              Assign(comm,'C'+hilf1+hilf); SetFAttr(comm,ReadOnly+Hidden+SysFile);
                        end;
                 until hilf='#';
Readln;
{ NC...       }  c2_write(15,10,'bearbeitete Dateien:  N O R T O N         ');
                 repeat hilf:=NextString;
                        if hilf<>'#' then exec(command,hilf+' >NUL');
                 until hilf='#';
{ D:\         }  hilf1:=NextString;
                 c2_write(15,10,'bearbeiteter   P f a d : '+hilf1      +'          ');
                 repeat hilf:=NextString;
                        if hilf<>'#' then
                        begin Assign(comm,hilf1+hilf);
                              SetFAttr(comm,ReadOnly+Hidden+SysFile);
                        end;
                 until hilf='#';
                 hilf1:=NextString;
                 c2_write(15,10,'bearbeiteter   P f a d : '+hilf1      +'          ');
                 repeat hilf:=NextString;
                        if hilf<>'#' then
                        begin Assign(comm,hilf1+hilf); SetFAttr(comm,Archive);
                              exec(command,'/C copy '+hilf1+hilf+' C:\'+hilf+' >NUL');
                              Erase (comm);
                              Assign(comm,'C:\'+hilf); SetFAttr(comm,ReadOnly);
                        end;
                 until hilf='#';
                 c1_write(15,10,'bearbeitete Dateien:  N O R T O N                       ');
                 c2_write(18,20,'Bitte warten, Ich bin gleich fertig !');
Readln;
                 FindFirst('D:\BAT\*.*',Archive,S_Rec);
                 while (DosError=0) do
                 begin Assign(comm,'D:\BAT\'+S_Rec.Name); SetFAttr(comm,ReadOnly);
                       FindNext(S_Rec);
                 end;
                 FindFirst('D:\UTILITYS\NC\*.*',Archive,S_Rec);
                 while (DosError=0) do
                 begin Assign(comm,'D:\UTILITYS\NC\'+S_Rec.Name); SetFAttr(comm,ReadOnly);
                       FindNext(S_Rec);
                 end;

                 exec(path_progr+'DBATCH.EXE','D D:\WORK\'); RmDir('D:\WORK');
                 Mount_Log;
{ AnfangsInitialisierung der LOGMASCH.DAT }
                 c2_write(15,10,'AnfangsInitialisierung des  MASCHINENTAGEBUCHES');
                 SysLog_O; Rewrite(SysLog_d);
                 with SysLog_p do
                 begin proj:='-SYSTEM-'; time:='....'; bea :='IiIiI';
                       dwg :='-I N I -'; min :='....'; sk:=#13#10;
                       str(J1:4,hilf); hilf1:=      hilf;
                       str(M1:2,hilf); hilf1:=hilf1+hilf;
                       str(D1:2,hilf); hilf1:=hilf1+hilf; move(hilf1[1],dat [1],8);
                       str(S1:2,hilf); hilf1:=      hilf;
                       str(N1:2,hilf); hilf1:=hilf1+hilf; move(hilf1[1],tims[1],4);
                       for i:=1 to 8 do if dat [i]=' ' then dat [i]:='0';
                       for i:=1 to 4 do if tims[i]=' ' then tims[i]:='0';
                 end;
                 SysLog_W; SysLog_C;
{ AnfangsInitialisierung der LOGNAM.DAT }
                 LogNam_O; Rewrite(LogNam_d);
                 for i:=1 to 14 do LogNam_p.byt[i]:=Random(256);
                 LogNam_p.byt[6]:=0; LogNam_p.byt[12]:=byt2; LogNam_W;
{ GerÑtekenng. } for i:=1 to 14 do
                 begin LogNam_p.byt[i]:=ord(gken[i])+i-byt2; byt2:=byt2+2*i+i; end;
                 LogNam_W;
{ DOS-Lizenz   } for i:=1 to 14 do
                 begin LogNam_p.byt[i]:=ord(liz [i])+i-byt2; byt2:=byt2+4*i;   end;
                 LogNam_W;
{ 1.Abr.-satz  } Name_:='IiIiI';
                 Pass1:=Name_; while length(Pass1)<100 do Pass1:=Pass1+' ';
                 Pass2:=Pass1; while length(Pass2)<255 do Pass2:=Pass2+' ';
                 with LogNam_p do
                 begin crc1:=0; crc2:=0; crc3:=0;
                       for i:=1 to length(Name_) do crc1:=crc1+ord(Name_[i])*i-ord(Name_[i]);
                       for i:=1 to length(Pass1) do crc2:=crc2+ord(Pass1[i])*i-ord(Pass1[i]);
                       for i:=1 to length(Pass2) do crc3:=crc3+ord(Pass2[i])*i-ord(Pass2[i]);
                       mpz:='START_SY';
                       for i:=1 to 8 do mpz[i]:=chr(ord(mpz[i])+(crc1 and $FF));
                 end;
                 LogNam_W; LogNam_C; Demount_Log;
                 deck('                       E R S T - Installierung beendet ! ');
           end
      else begin w:=9; c1_write(23,1,''); clreol; c1_write(24,1,''); clreol;
                 auswahl[1].x:=16; auswahl[1].y:= 7; auswahl[1].t:='Datei: C:\CONFIG.SYS bearbeiten          ';
                 auswahl[2].x:=16; auswahl[2].y:= 9; auswahl[2].t:='NUTZER-Steuerdatei erzeugen    [C-NAM   ]';
                 auswahl[3].x:=16; auswahl[3].y:=10; auswahl[3].t:='NUTZER lîschen / hinzufÅgen    [E-NAM   ]';
                 auswahl[4].x:=16; auswahl[4].y:=11; auswahl[4].t:='NUTZERpassworte lîschen/Ñndern [E-PASS  ]';
                 auswahl[5].x:=16; auswahl[5].y:=12; auswahl[5].t:='NUTZER MenÅs kopieren          [C-MENU  ]';
                 auswahl[6].x:=16; auswahl[6].y:=13; auswahl[6].t:='NUTZER MenÅs bearbeiten        [E-MENU  ]';
                 auswahl[7].x:=16; auswahl[7].y:=15; auswahl[7].t:='LOGBUCH Auswertungsabzug                 ';
                 auswahl[8].x:=16; auswahl[8].y:=17; auswahl[8].t:='Datei: C:\PATH.TXT bearbeiten  [E-PATH  ]';
                 auswahl[9].x:=16; auswahl[9].y:=24; auswahl[9].t:='P r o g r a m m    b e e n d e n         ';
                 repeat fenster(1, 1, 1,80,22,'…','Õ','ª','∫','»','º','∫','Õ',copyrc,pc1,pc2,pc3);
                        c2_write( 5, 3,'Modifizierung der Installierung');
                        wahl1(9);
                        case w of
{ ne config.sys }         1: begin Assign(comm,'C:\CONFIG.SYS'); SetFAttr(comm,Archive);
                                   exec('D:\UTILITYS\NC\NE.COM','C:\CONFIG.SYS');
                                   SetFAttr(comm,ReadOnly);
                                   Assign(comm,'C:\CONFIG.~SY'); Reset(comm);
                                   if IOResult=0 then erase(comm);
                             end;
{ C-NAM    }              2: begin c1_write(24,1,''); clreol;
                                   Mount_Log;   exec(path_progr3+'C-NAM.EXE','N');
                                   Demount_Log;
                             end;
{ E-NAM    }              3: begin Mount_Log;   exec(path_progr3+'E-NAM.EXE','N U');
                                   Demount_Log;
                             end;
{ E-PASS   }              4: begin Mount_Log;   exec(path_progr3+'E-PASS.EXE','N U');
                                   Demount_Log;
                             end;
{ C-MENU   }              5: begin Pass1:='A:\BAT'; Pass2:='START_SY';
                                   repeat Window( 2, 4,79,21); ClrScr; Window( 1, 1,80,25);
                                          c1_write( 7,16,'Quell-Laufwerk und -Pfad fÅr MenÅs:');
                                          EditStr:=Pass1; EditZ(-1,18,15,58,17); Pass1:=EditStr;
                                          c1_write( 7,52,Pass1);
                                          c1_write( 9,16,'Nutzer-MenÅ-Pfad                  :');
                                          EditStr:=Pass2; EditZ(-1,18,15,58,17); Pass2:=EditStr;
                                          c1_write( 9,52,Pass2);
                                          Window(18,15,79,17); ClrScr; Window( 1, 1,80,25);
                                          c1_write(12,10,'(E)ingaben wiederholen   (K)opieren   (L)îschen   (A)bbruch');
                                          repeat ok:=UpCase(ReadKey); until ok in ['E','K','L','A'];
                                   until ok in ['K','L','A'];
                                   if ok='K' then
                                      begin Mount_Log;
                                            exec(path_progr3+'C-MENU.EXE','* '+Pass1+'  '+Pass2+' *');
                                            mmm:=TRUE;
                                            Demount_Log;
                                      end;
                                   if ok='L' then
                                      begin Mount_Log;
                                            exec(path_progr3+'C-MENU.EXE','* '+Pass1+'  '+Pass2+' -');
                                            mmm:=TRUE;
                                            Demount_Log;
                                      end;
                                   Window( 2, 4,79,21); ClrScr; Window( 1, 1,80,25);
                             end;
{ E-MENU   }              6: begin Mount_Log;   exec(path_progr3+'E-MENU.EXE','N U');
                                   Demount_Log;
                             end;
{ LogBuch  }              7: begin Assign(config,'A:\LOGBUCH'); Reset(config);
                                   if IOResult=0 then Append(config) else Rewrite(config);
                                   Mount_Log;
                                   LogNam_O; Seek(LogNam_d,0); LogNam_R;
                                   byt2:=LogNam_p.byt[12];
                                   LogNam_R; write(config,'GerÑte-Nummer: ');
                                   for i:=1 to 14 do
                                       begin Write(config,chr(LogNam_p.byt[i]-i+byt2));
                                             byt2:=byt2+2*i+i;
                                       end; Writeln(config,'            ');
                                   LogNam_C; SysLog_O;
                                   repeat SysLog_R;
                                          if SysLog_p.min<>'....' then
                                             with SysLog_p do
                                                  Writeln(config,proj,bea,dwg,dat,tims,time,min);
                                   until SysLog_p.min='....';
                                   Rewrite(SysLog_d); SysLog_W;
                                   SysLog_C; Demount_Log; Close(config);
                             end;
{ E-PATH   }              8: begin Mount_Log;   exec(path_progr3+'E-PATH.EXE','N U');
                                   Demount_Log;
                             end;
                        end;
                        i:=IOResult;
                 until w=9;
                 deck('                                 Modifizierung beendet ! ');
           end;

      c1_write(1,1,''); Window( 1, 1,80,25); clrscr;
      if mmm then exec(path_progr2+'INT19O.COM','');
end.
