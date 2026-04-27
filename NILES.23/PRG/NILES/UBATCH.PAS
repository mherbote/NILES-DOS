{$R-,S-,I-,D-,F-,V+,B+,N-,L+ }
{$M 5000,0,0 }
{$DEFINE Debug }
{$UNDEF  Debug }

{*******************************************
 * UBATCH.PAS                              *
 * Modifizierung des SYSTEMs   NILES-DOS   *
 *                                         *
 *        (c) by NILES-SOFT 1988 VERS. 2.3 *
 *           Programmierer: Marcus Herbote *
 *******************************************}

uses   dos,crt,crt_,Fenster_,Syshalt_,Mount_,Handle_;

const  copyrc                      = '(c) 88 by NILES-SOFT';
       pc1                         = 'M o d u l :     U  B  A  T  C  H';
       pc2                         = 'V e r s i o n   2  .  3';
       pc3                         = '11.12.88';

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
       Name_,Pass1,Pass2           :                    string[255];
       hilfc                       : array[0..  255] of byte absolute hilf;
       Reg                         :                    Registers;
       BufferHead                  :                    Integer absolute $40:$1a;
       BufferTail                  :                    Integer absolute $40:$1c;
       ii,iii                      :                    LongInt;

procedure Sys_Halt(id:Integer);
begin Sys_Halt1(id); halt(id); end;

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
      if ParamCount<1 then Sys_Halt(30);
      deck('                                          Start p h a s e');
      c1_write(1,1,''); Window( 1, 1,80,25); clrscr;
      fenster(1, 1, 1,80,24,'…','Õ','ª','∫','»','º','∫','Õ',copyrc,pc1,pc2,pc3);
      GetDate(J1,M1,D1,D11); GetTime(S1,N1,T1,D11); Mount_Log;

      Assign(idat,'\INSTALL.DAT'); Reset(idat);
      if IOResult<>0 then Sys_Halt(20); i_j:=$52; i_k:=$41;
      while NextByte_idat<>'#' do ; byt2:=i_j-i_k; hilf:=NextByte_idat;
      liz:=NextString; if length(liz)<>14 then Sys_Halt(20);

      path_d     :=NextString; path_progr :=NextString; path_d:=''; { }
      path_progr2:=NextString; path_progr3:=NextString;
      command:=path_progr+'COMMAND.COM'; hilf:=NextString;
      k:=0; repeat k:=k+1; Name_C[k]:=NextString; until Name_C[k]='#'; k:=k-1;

      c2_write( 5, 3,'N  I  L  E  S  - D O S   - Modifizierung');
      k:=0; repeat k:=k+1;                Name_A[k]:=NextString;
                   if Name_A[k]<>'#' then Name_N[k]:=NextString;
            until Name_A[k]='#'; k:=k-1; Name_I:=k;
      i:=1; ii:=0;
      repeat FindFirst(path_d+Name_N[i],AnyFile,S_Rec);
             if DosError=0 then ii:=ii+1; i:=i+1;
      until i>Name_I;
      if ii<>Name_I then Sys_Halt(20);

      hilf:=NextString; repeat hilf:=NextString; until hilf='#'; { CONFIG.SYS }
      repeat hilf:=NextString; until hilf='#';                   { C-Pfade }
      repeat hilf:=NextString; until hilf='#';                   { COMM,Mount }
      repeat hilf:=NextString; until hilf='#';                   { D-Pfade }

{ path_progr lîschen }
      c1_write( 8,10,'Pfad: '+path_progr+'                           ');
      c1_write( 9,10,'      wird gelîscht');
      FindFirst(path_progr+'*.*',Archive+ReadOnly+Hidden+SysFile,S_Rec);
      while DosError=0 do
      begin if not ((S_Rec.Name='COMMAND.COM')  or
                    (S_Rec.Name='MOUNT.COM'  )  or (S_Rec.Name='DEMOUNT.COM'))
               then begin Assign(comm,path_progr+S_Rec.Name);
                          SetFAttr(comm,Archive); Erase(comm);
                    end;
            FindNext(S_Rec);
      end;

{ path_progr3 lîschen }
      c1_write( 8,10,'Pfad: '+path_progr3+'                          ');
      c1_write( 9,10,'      wird gelîscht');
      FindFirst(path_progr3+'*.*',Archive+ReadOnly+Hidden+SysFile,S_Rec);
      while DosError=0 do
      begin if not ((S_Rec.Name='WPROTECT.COM')  or (S_Rec.Name='WRENABLE.COM'))
               then begin Assign(comm,path_progr3+S_Rec.Name);
                          SetFAttr(comm,Archive); Erase(comm);
                    end;
            FindNext(S_Rec);
      end;

{ C:\UTILITYS\NC lîschen }
      c1_write( 8,10,'Pfad: C:\UTILITYS\NC                          ');
      c1_write( 9,10,'      wird gelîscht');
      FindFirst('C:\UTILITYS\NC\*.*',Archive+ReadOnly+Hidden+SysFile,S_Rec);
      while DosError=0 do
      begin Assign(comm,'C:\UTILITYS\NC\'+S_Rec.Name);
            SetFAttr(comm,Archive); Erase(comm);
            FindNext(S_Rec);
      end;

{ path_progr2 kopieren }
      c1_write( 8,10,'Pfade: C:\BAT und C:\UTILITYS\PUBLIC                 ');
      c1_write( 9,10,'       werden gesichert und dann gelîscht');
      MkDir(copy(ParamStr(1),1,1)+':\XXXXXXXX.XXX');
      MkDir(copy(ParamStr(1),1,1)+':\XXXXXXXX.XXX\BAT');
      MkDir(copy(ParamStr(1),1,1)+':\XXXXXXXX.XXX\PUBLIC');
      FindFirst('C:\BAT\*.*',Archive+ReadOnly+Hidden+SysFile,S_Rec);
      while DosError=0 do
      begin Assign(comm,'C:\BAT\'+S_Rec.Name); SetFAttr(comm,Archive);
            FindNext(S_Rec);
      end;
      FindFirst(path_progr2+'*.*',Archive+ReadOnly+Hidden+SysFile,S_Rec);
      while DosError=0 do
      begin Assign(comm,path_progr2+S_Rec.Name); SetFAttr(comm,Archive);
            FindNext(S_Rec);
      end;
      exec(command,'/C COPY C:\BAT\*.* '+
                              copy(ParamStr(1),1,1)+':\XXXXXXXX.XXX\BAT    >NUL');
      exec(command,'/C COPY '+path_progr2+'*.* '+
                              copy(ParamStr(1),1,1)+':\XXXXXXXX.XXX\PUBLIC >NUL');
      FindFirst('C:\BAT\*.*',Archive+ReadOnly+Hidden+SysFile,S_Rec);
      while DosError=0 do
      begin Assign(comm,'C:\BAT\'+S_Rec.Name); Erase(comm);
            FindNext(S_Rec);
      end;
      FindFirst(path_progr2+'*.*',Archive+ReadOnly+Hidden+SysFile,S_Rec);
      while DosError=0 do
      begin if not ((S_Rec.Name='PKARC.COM')  or (S_Rec.Name='PKXARC.COM'))
               then begin Assign(comm,path_progr2+S_Rec.Name); Erase(comm);
                    end;
            FindNext(S_Rec);
      end;

{ Dateien laden und aufblÑhen }
      _j:=$21; _k:=$32; i:=IOResult; i:=1;
      repeat c1_write(11,10,'bearbeitete Datei: '+path_d+Name_N[i]+'            ');
             c1_write(12,10,'Byte             :         von ');
             Handle_Open  (H1_,$00,path_d    +Name_N[i]); write(FS:7); FS:=0;
             Handle_Create(H2_,$00,copy(ParamStr(1),1,1)+':\XXXXXXXX.XXX\'+Name_A[i]);
             while (Handle_Read(H1_,DTAl)) and (FS1>0) do
             begin for iii:=1 to FS1 do
                       begin c2_write(12,29,''); write((FS+iii):7);
                             DTA_[iii]:=DTA_[iii]-_j-_j+_k; _k:=_k+_j;
                       end;
                       Handle_Write(H2_,FS1); FS:=FS+FS1;
             end;
             Handle_Close(H1_); Handle_Close(H2_); i:=i+1; _j:=_k;
      until i>Name_I;
      c1_write(12,29,''); write(FS:7);

{ PKXARC /r }
      hilf1:=path_progr2+Name_A[1];
      for ii:=2 to Name_I do
          begin c2_write(15,10,'bearbeitete Archiv-Datei: '+Name_A[ii]+'          ');
                hilf:='/r '+copy(ParamStr(1),1,1)+':\XXXXXXXX.XXX\'+Name_A[ii];
                case ii of 2: hilf:=hilf+' C:\UTILITYS\NC\';
                           3: hilf:=hilf+' '+copy(ParamStr(1),1,1)+':\XXXXXXXX.XXX\';
                end;
                exec(command,'/C '+hilf1+hilf+' >NUL');
                if ii=2 then exec(command,'/C del '+copy(ParamStr(1),1,1)+':\XXXXXXXX.XXX\'+Name_A[2]+' >NUL');
          end;
      exec(command,'/C '+hilf1+'/r '+copy(ParamStr(1),1,1)+':\XXXXXXXX.XXX\'+Name_A[2]+' C:\BAT\'+' >NUL');

{ path_progr2 }
      c2_write(15,10,'bearbeiteter   P f a d : '+path_progr2+'          ');
      repeat hilf:=NextString;
             if hilf<>'#' then
             begin Assign(comm,copy(ParamStr(1),1,1)+':\XXXXXXXX.XXX\'+hilf); SetFAttr(comm,Archive);
                   exec(command,'/C copy '+copy(ParamStr(1),1,1)+':\XXXXXXXX.XXX\'+hilf+path_progr2+hilf+' >NUL');
                   Delete(hilf,length(hilf),1);
                   Assign(comm,path_progr2+hilf); SetFAttr(comm,ReadOnly);
             end;
      until hilf='#';

{ path_progr  }
      c2_write(15,10,'bearbeiteter   P f a d : '+path_progr +'          ');
      repeat hilf:=NextString;
             if hilf<>'#' then
             begin Assign(comm,copy(ParamStr(1),1,1)+':\XXXXXXXX.XXX\'+hilf); SetFAttr(comm,Archive);
                   exec(command,'/C copy '+copy(ParamStr(1),1,1)+':\XXXXXXXX.XXX\'+hilf+path_progr+hilf+' >NUL');
                   Delete(hilf,length(hilf),1);
                   Assign(comm,path_progr+hilf); SetFAttr(comm,ReadOnly);
             end;
      until hilf='#';

{ path_progr3 }
      c2_write(15,10,'bearbeiteter   P f a d : '+path_progr3+'          ');
      repeat hilf:=NextString;
             if hilf<>'#' then
             begin Assign(comm,copy(ParamStr(1),1,1)+':\XXXXXXXX.XXX\'+hilf); SetFAttr(comm,Archive);
                   exec(command,'/C copy '+copy(ParamStr(1),1,1)+':\XXXXXXXX.XXX\'+hilf+path_progr3+hilf+' >NUL');
                   Assign(comm,path_progr3+hilf); SetFAttr(comm,ReadOnly);
             end;
      until hilf='#';

{ ..\START_SY }
      hilf1:=NextString; repeat hilf:=NextString; until hilf='#';

{ C:\BAT      }
      hilf1:=NextString;
      c2_write(15,10,'bearbeiteter   P f a d : '+hilf1      +'          ');
      repeat hilf:=NextString;
             if hilf<>'#' then
                begin Assign(comm,hilf1+hilf); SetFAttr(comm,ReadOnly+Hidden+SysFile); end;
      until hilf='#';

{ NC...       }
      c2_write(15,10,'bearbeitete Dateien:  N O R T O N                         ');
      repeat hilf:=NextString;
             i:=pos('C:\WORK',hilf);
             if i>0 then begin Delete(hilf,i,7);
                               Insert(copy(ParamStr(1),1,1)+':\XXXXXXXX.XXX',hilf,i);
                         end;
             if hilf<>'#' then exec(command,hilf+' >NUL');
      until hilf='#';

{ C:\         }
      hilf1:=NextString;
      c2_write(15,10,'bearbeiteter   P f a d : '+hilf1      +'          ');
      repeat hilf:=NextString;
             if hilf<>'#' then
             begin Assign(comm,hilf1+hilf);
                   SetFAttr(comm,ReadOnly+Hidden+SysFile);
             end;
      until hilf='#';
      c1_write(15,10,'bearbeitete Dateien:  N O R T O N                           ');
      c2_write(18,20,'Bitte warten, Ich bin gleich fertig !');

      FindFirst('C:\BAT\*.*',Archive,S_Rec);
      while (DosError=0) do
      begin Assign(comm,'C:\BAT\'+S_Rec.Name); SetFAttr(comm,ReadOnly);
            FindNext(S_Rec);
      end;
      FindFirst('C:\UTILITYS\NC\*.*',Archive,S_Rec);
      while (DosError=0) do
      begin Assign(comm,'C:\UTILITYS\NC\'+S_Rec.Name); SetFAttr(comm,ReadOnly);
            FindNext(S_Rec);
      end;

{ path_progr2 zurÅckkopieren }
      c1_write(18,10,'Pfade: C:\BAT und C:\UTILITYS\PUBLIC                 ');
      c1_write(19,10,'       werden zurÅckgespeichert');
      FindFirst(copy(ParamStr(1),1,1)+':\XXXXXXXX.XXX\BAT\*.*',Archive,S_Rec);
      while DosError=0 do
      begin Assign(comm,'C:\BAT\'+S_Rec.Name); Reset(comm);
            if IOResult<>0 then
               exec(command,'/C COPY '+copy(ParamStr(1),1,1)+':\XXXXXXXX.XXX\BAT\'+S_Rec.Name+
                                       ' C:\BAT >NUL');
            FindNext(S_Rec);
      end;
      FindFirst(copy(ParamStr(1),1,1)+':\XXXXXXXX.XXX\PUBLIC\*.*',Archive,S_Rec);
      while DosError=0 do
      begin Assign(comm,'C:\UTILITYS\PUBLIC\'+S_Rec.Name); Reset(comm);
            if IOResult<>0 then
               exec(command,'/C COPY '+copy(ParamStr(1),1,1)+':\XXXXXXXX.XXX\PUBLIC\'+S_Rec.Name+
                                       ' C:\UTILITYS\PUBLIC >NUL');
            FindNext(S_Rec);
      end;

      c4_write(22,20,'Bitte warten, Ich bin gleich fertig !');
      exec(path_progr+'DBATCH.EXE','D '+copy(ParamStr(1),1,1)+':\XXXXXXXX.XXX\PUBLIC\');
      exec(path_progr+'DBATCH.EXE','D '+copy(ParamStr(1),1,1)+':\XXXXXXXX.XXX\BAT\');
      exec(path_progr+'DBATCH.EXE','D '+copy(ParamStr(1),1,1)+':\XXXXXXXX.XXX\');
      RmDir(copy(ParamStr(1),1,1)+':\XXXXXXXX.XXX\PUBLIC');
      RmDir(copy(ParamStr(1),1,1)+':\XXXXXXXX.XXX\BAT');
      RmDir(copy(ParamStr(1),1,1)+':\XXXXXXXX.XXX');
      Demount_Log;
      deck('                   M o d i f i z i e r u n g   beendet ! ');

      c1_write(1,1,''); Window( 1, 1,80,25); clrscr;
end.
