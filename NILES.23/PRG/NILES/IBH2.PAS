{$R-,S-,I-,D-,F-,V+,B+,N-,L+ }
{$M 1500,0,0 }
{$DEFINE Debug }
{$UNDEF  Debug }

{*******************************************
 * IBHELP.PAS                              *
 * Hilfsprogramm zur Installierung         *
 *                                         *
 *        (c) by NILES-SOFT 1988 VERS. 2.3 *
 *           Programmierer: Marcus Herbote *
 *******************************************}

uses   dos,crt,crt_,Fenster_,Syshalt_,Handle_;

const  copyrc                             = '(c) 88,89 by NILES-SOFT';
       pc1                                = 'M o d u l :     I  B  H  2';
       pc2                                = 'V e r s i o n   2  .  3';
       pc3                                = '11.04.89';
       Name_I                             = 3;
       Name_A : array[1..Name_I] of string[12] = ('PKXARC.COM','NC.ARC','ABZUG.ARC');
       Name_N : array[1..Name_I] of string[12] = ('A'         ,'B'     ,'C'        );
       path_d                             = '';


var    i,DEC                              :                    Integer;
       _j,_k                              :                    Byte;
       ii,iii                             :                    LongInt;
       Name                               : array[1..    7] of string[ 12];
       bbb                                :                    Byte;
       comm                               : file            of Byte;
       hilf                               :                    string[255];
       hilfc                              : array[0..  255] of byte absolute hilf;
       Reg                                :                    Registers;
       LWc                                :                    string[1];

procedure Sys_Halt(id:Integer);
begin Sys_Halt1(id); halt(1); end;

procedure deck(titel:string);
  var f1,f2,f3,f4:Integer;
begin if color then begin f1:=red; f2:=yellow; f3:=red; f4:=white; end
               else begin f1:=white; f2:=black; f3:=white; f4:=black; end;
      c2_write(1,1,''); Window( 1, 1,80,25); clrscr;
      fenster(1, 1, 1,80,24,'É','Í','»','º','È','¼','º','Í',copyrc,pc1,pc2,pc3);
      c_write( 5, 5,f1,f2,'±±±±      ±±   ±±   ±±           ±±±±±±±±±±    ±±±±±±±±±');
      c_write( 6, 5,f1,f2,'±± ±±     ±±   ±±   ±±           ±±            ±±');
      c_write( 7, 5,f1,f2,'±±  ±±    ±±   ±±   ±±           ±±            ±±');
      c_write( 8, 5,f1,f2,'±±   ±±   ±±   ±±   ±±           ±±±±±±±       ±±±±±±±±±   ±±±±±±±');
      c_write( 9, 5,f1,f2,'±±    ±±  ±±   ±±   ±±           ±±                   ±±');
      c_write(10, 5,f1,f2,'±±     ±± ±±   ±±   ±±           ±±                   ±±');
      c_write(11, 5,f1,f2,'±±      ±±±±   ±±   ±±±±±±±±±±   ±±±±±±±±±±    ±±±±±±±±±');
      c_write(13,40,f3,f4,'°°°°°°°°°       °°°°°°°     °°°°°°°°°');
      c_write(14,40,f3,f4,'°°      °°     °°     °°    °°');
      c_write(15,40,f3,f4,'°°       °°   °°       °°   °°');
      c_write(16,40,f3,f4,'°°       °°   °°       °°   °°°°°°°°°');
      c_write(17,40,f3,f4,'°°       °°   °°       °°          °°');
      c_write(18,40,f3,f4,'°°      °°     °°     °°           °°');
      c_write(19,40,f3,f4,'°°°°°°°°°       °°°°°°°     °°°°°°°°°');
      c2_write(22,10,'I  N  S  T  A  L  L  A  T  I  O  N  S  -  H i l f e ');
      c2_write(23,10,titel);
      c2_write(25,55,'<ENTER> fr weiter !'); readln;
end;


begin {$IFDEF Debug} CheckBreak:=true; {$ELSE} CheckBreak:=false; {$ENDIF}
      deck('                                          Start p h a s e');
      c1_write(1,1,''); Window( 1, 1,80,25); clrscr;
      fenster(1, 1, 1,80,24,'É','Í','»','º','È','¼','º','Í',copyrc,pc1,pc2,pc3);

      if ParamCount=0 then Sys_Halt(30) else LWc:=copy(ParamStr(1),1,1);

      i:=1; ii:=0; LWc[1]:=UpCase(LWc[1]);
      repeat Assign(comm,path_d+Name_A[i]); SetFAttr(comm,Archive); Reset(comm);
             if IOResult=0 then ii:=ii+1;
             i:=i+1;
      until i>Name_I;
      if ii<>Name_I then Sys_Halt(20);

      _j:=$21; _k:=$32; i:=1;
      repeat c1_write(10,10,'bearbeitete Datei: '+path_d+Name_A[i]+'            ');
             c1_write(12,10,'neuer Name       : '+LWc+':\'+Name_N[i]+'            ');
             c1_write(15,10,'Byte             :         von ');
             Handle_Open  (H1_,$00,path_d+Name_A[i]); write(FS:7); FS:=0;
             Handle_Create(H2_,$07,LWc+':\'+Name_N[i]);
             while (Handle_Read(H1_,50*1024)) and (FS1>0) do
             begin for iii:=1 to FS1 do
                       begin c2_write(15,29,''); 
                             DTA_[iii]:=DTA_[iii]+_j+_j-_k; _k:=_k+_j;
                       end;
                   Handle_Write(H2_,FS1); FS:=FS+FS1; write((FS):7);
             end;
             Handle_Close(H1_); Handle_Close(H2_); i:=i+1; _j:=_k;
      until i>Name_I;

      _j:=$52; _k:=$41;
      c1_write(10,10,'bearbeitete Datei: '+path_d+'INSTALL.DAT       ');
      c1_write(12,10,'neuer Name       : '+LWc+':\INSTALL.DAT              ');
      c1_write(15,10,'Byte             :         von ');
      Handle_Open  (H1_,$00,path_d+'INSTALL.DAT'); write(FS:7); FS:=0;
      Handle_Create(H2_,$00,LWc+':\INSTALL.DAT');
      while (Handle_Read(H1_,50*1024)) and (FS1>0) do
      begin for iii:=1 to FS1 do
                begin c2_write(15,29,''); 
                      DTA_[iii]:=DTA_[iii]+_j+_j-_k; _k:=_k+_j;
                end;
                Handle_Write(H2_,FS1); FS:=FS+FS1; write((FS):7);
      end;
      Handle_Close(H1_); Handle_Close(H2_);  halt;

      deck('                                 HilfsProgramm beendet ! ');
      c1_write(1,1,''); Window( 1, 1,80,25); clrscr;
end.
