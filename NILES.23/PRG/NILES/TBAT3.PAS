{$R-,S-,I-,D-,F-,V+,B+,N-,L+ }
{$M 1024,0,0 }
{$DEFINE Debug }
{$UNDEF  Debug }

{*******************************************
 * TBAT1.PAS                               *
 *                                         *
 *                                         *
 *                                         *
 *        (c) by NILES-SOFT 1988 VERS. 2.3 *
 *           Programmierer: Marcus Herbote *
 *******************************************}

uses   dos,crt,Crt_,Handle_;

const  path1      = 'D:\UTILITYS\NC\';
       path2      = 'C:\';

var    ComSpec    : String[255];
       p          : Integer;
       dat        : File of Byte;


begin {$IFDEF Debug} CheckBreak:=true; {$ELSE} CheckBreak:=false; {$ENDIF}
      if ParamCount<1 then
         begin ClrScr; Writeln(^G,'Kein Parameter angegeben !'); exit; end;
      for p:=1 to ParamCount do
          begin Handle_Open  (H1_,$00,path1+ParamStr(p)); p:=p+1;
                Handle_Create(H2_,$00,path2+ParamStr(p));
                while (Handle_Read(H1_,50*1024)) and (FS1>0) do Handle_Write(H2_,FS1);
                Handle_Close(H1_); Handle_Close(H2_);
          end;
      c1_write( 1, 1,''); ClrScr;
end.
