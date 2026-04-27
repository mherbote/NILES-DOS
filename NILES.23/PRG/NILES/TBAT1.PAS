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

uses   dos,crt,Crt_,Environ_;

var    ComSpec    : String[255];
       p          : Integer;
       dat        : File of Byte;


begin {$IFDEF Debug} CheckBreak:=true; {$ELSE} CheckBreak:=false; {$ENDIF}
      ComSpec:=SearchEnvironment('COMSPEC'); delete(ComSpec,1,pos('=',ComSpec));
      delete(ComSpec,pos('COMMAND',ComSpec),length(ComSpec)-pos('COMMAND',ComSpec)+1);
      if ParamCount<1 then
         begin ClrScr; Writeln(^G,'Kein Parameter angegeben !'); exit; end;
      Assign(dat,ParamStr(1)+'.ini'); SetFAttr(dat,Archive);
      exec(ComSpec+'COMMAND.COM','/C COPY '+ParamStr(1)+'.ini c:\nc.ini >NUL');
      SetFAttr(dat,ReadOnly+Hidden+SysFile);
      c1_write( 1, 1,''); ClrScr;
end.
