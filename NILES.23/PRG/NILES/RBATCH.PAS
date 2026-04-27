{$R-,S-,I-,D-,F-,V+,B+,N-,L+ }
{$M 5000,0,0 }
{$DEFINE Debug }
{$UNDEF  Debug }

{*******************************************
 * RBATCH.PAS                              *
 * Installierung des SYSTEMs   NILES-DOS   *
 *                                         *
 *        (c) by NILES-SOFT 1988 VERS. 2.0 *
 *           Programmierer: Marcus Herbote *
 *******************************************}

uses   dos,crt,crt_,Fenster_,Batch_,Mount_,Handle_;

const  copyrc                      = '(c) 88 by NILES-SOFT';
       pc1                         = 'M o d u l :     R  B  A  T  C  H';
       pc2                         = 'V e r s i o n   2  .  0';
       pc3                         = '01.06.88';

var    i,j,k,DEC                   :               integer;
       S_Rec                       : { record Fill : array[1..21] of byte;
                                              Attr : Byte;
                                              Time : LongInt;
                                              Size : LongInt;
                                              Name : string[12];
                                       end}
                                     SearchRec;
       Name                        :                    string[ 12];
       Attr                        :                    Word;
       ch                          :                    Char;
       bbb                         :                    Byte;
       comm,comm1                  : file            of Byte;
       config                      :                    Text;
       First                       :                    Boolean;
       hilf,hilf1,command          :                    string[255];
       J1,J2,M,M1,M2,D1,D2,D11     :                    Word;
       S1,N1,T1                    :                    Word;
       Name_,Pass1,Pass2           :                    string[255];
       hilfc                       : array[0..  255] of byte absolute hilf;
       Reg                         :                    Registers;
       ii,iii                      :                    LongInt;


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
      c2_write(22,10,'I  N  S  T  A  L  L  A  T  I  O  N    z u r Å c k s e t z e n');
      c2_write(23,10,titel);
      c2_write(25,55,'<ENTER> fÅr weiter !'); readln;
end;

procedure del_p(path:string);
begin c2_write(15,10,'bearbeiteter Pfad: '+path+'                       ');
      FindFirst(path+'\*.*',Archive+ReadOnly+Hidden+SysFile,S_Rec); DEC:=DosError;
      while (DEC=0) do
      begin Name:=S_Rec.Name; Assign(comm,path+'\'+Name); SetFAttr(comm,Archive);
            Erase(comm);
            FindNext(S_Rec); DEC:=DosError;
      end;
      RmDir(path);
end;


begin {$IFDEF Debug} CheckBreak:=true; {$ELSE} CheckBreak:=false; {$ENDIF}
      deck('                                          Start p h a s e');
      c1_write(1,1,''); Window( 1, 1,80,25); clrscr;
      fenster(1, 1, 1,80,24,'…','Õ','ª','∫','»','º','∫','Õ',copyrc,pc1,pc2,pc3);

      Mount_Log;
      del_p('E:\BAT\START_SY'); del_p('E:\BAT');
      del_p('E:\SYSLOG');
      del_p('E:\UTILITYS\BATCH'); del_p('E:\UTILITYS');

      del_p('C:\BAT\BATCH'); del_p('C:\BAT');
      del_p('C:\DOS');
      del_p('C:\UTILITYS\BATCH'); del_p('C:\UTILITYS\PUBLIC'); del_p('C:\UTILITYS\NC');
      del_p('C:\UTILITYS');
      del_p('C:\WORK');

      FindFirst('C:\NC.*',Archive+ReadOnly+Hidden+SysFile,S_Rec); DEC:=DosError;
      while (DEC=0) do
      begin Name:=S_Rec.Name; Assign(comm,'C:\'+Name); SetFAttr(comm,Archive);
            Erase(comm);
            FindNext(S_Rec); DEC:=DosError;
      end;

      DEC:=IOResult;
      Assign (config,'C:\CONFIG.SYS'); SetFAttr(config,Archive); Rewrite(config);
      Writeln(config,'device =fixt_drv.sys');
      Writeln(config,'buffers= 40');
      Writeln(config,'files  = 20');
      Writeln(config,'country=049');
      Close  (config);

      Reg.AH:=5; Reg.AL:=1; intr($10,Reg);
      Assign(comm ,'A:\COMMAND.COM'); Reset  (comm );
      repeat if IOResult<>0
                then begin c1_write(1,1,''); clrscr;
                           fenster(0,10, 9,70,16,'…','Õ','ª','∫','»','º','∫','Õ','','','','');
                           gotoxy(20,12); write('Legen Sie bitte Vfeature-WORK-Disk in Laufwerk A');
                           gotoxy(20,14); write('            Wenn bereit, dann <ENTER> drÅcken ! ');
                           ch:=readkey;
                           Assign(comm,'A:\COMMAND.COM'); Reset(comm);
                     end;
      until ioresult=0;
      Reg.AH:=5; Reg.AL:=0; intr($10,Reg);

      Handle_Open(H1_,0,'A:\COMMAND.COM'); Handle_Create(H2_,0,'C:\COMMAND.COM');
      while (Handle_Read(H1_,DTAl)) and (FS1>0) do begin Handle_Write(H2_,FS1); end;
      Handle_Close(H1_); Handle_Close(H2_);

      Handle_Open(H1_,0,'A:\MOUNT.COM'); Handle_Create(H2_,0,'C:\MOUNT.COM');
      while (Handle_Read(H1_,DTAl)) and (FS1>0) do begin Handle_Write(H2_,FS1); end;
      Handle_Close(H1_); Handle_Close(H2_);

      Handle_Open(H1_,0,'A:\DEMOUNT.COM'); Handle_Create(H2_,0,'C:\DEMOUNT.COM');
      while (Handle_Read(H1_,DTAl)) and (FS1>0) do begin Handle_Write(H2_,FS1); end;
      Handle_Close(H1_); Handle_Close(H2_);

      deck('                       E R S T - Installierung beendet ! ');

      c1_write(1,1,''); Window( 1, 1,80,25); clrscr;
end.
