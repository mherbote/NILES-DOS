{$R-,S-,I-,D-,F-,V+,B+,N-,L+ }
{$M 1024,0,0 }
{$DEFINE Debug }
{$UNDEF  Debug }

{*******************************************
 * TBAT2.PAS                               *
 *                                         *
 *                                         *
 *                                         *
 *        (c) by NILES-SOFT 1988 VERS. 2.3 *
 *           Programmierer: Marcus Herbote *
 *******************************************}

uses   dos,crt,Crt_,Environ_;

var    ComSpec    : String[255];
       p          : Integer;
       dat        : Text;


begin {$IFDEF Debug} CheckBreak:=true; {$ELSE} CheckBreak:=false; {$ENDIF}
      ComSpec:=SearchEnvironment('COMSPEC'); delete(ComSpec,1,pos('=',ComSpec));
      delete(ComSpec,pos('COMMAND',ComSpec),length(ComSpec)-pos('COMMAND',ComSpec)+1);
      if ParamCount<1 then
         begin ClrScr; Writeln(^G,'Kein Parameter angegeben !'); exit; end;
      if copy(ParamStr(1),1,1)='*'
         then begin Assign(dat,copy(ParamStr(1),2,length(ParamStr(1))-1));
                    Rewrite(dat);
              end
         else begin Assign(dat,ParamStr(1));
                    Reset(dat);
                    if IOResult=0 then Append(dat) else Rewrite(dat)
              end;
      for p:=1 to ParamCount-1 do Write(dat,ParamStr(p+1),' ');
      Writeln(dat); Close(dat);
end.
