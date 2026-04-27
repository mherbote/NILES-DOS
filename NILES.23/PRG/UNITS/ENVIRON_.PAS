{$R-,S-,I-,D-,F-,V+,B+,N-,L- }
{$M 1500,0,0 }
{$DEFINE Debug }
{$UNDEF  Debug }

unit Environ_;

interface

            uses   dos,crt;

            type   StringType       = String[255];

            function SearchEnvironment(EnvString:StringType):StringType;

implementation

const  Error_Val:Integer= -1;

var    reg              : Registers;

function GetEnvironment(var EnvString:StringType; init:boolean):integer;
  const segm:integer=0; offs:integer=0;
  var   start,cseg1:integer;
begin reg.AH:=98; MsDos(Reg); cseg1:=reg.BX;
      if (segm=0) or init then begin segm:=memw[cseg1:$002C]; offs:=0; end;
      if mem[segm:offs]<>0
         then begin start:=offs; while mem[segm:offs]<>0 do offs:=succ(offs);
                    move(mem[segm:start],EnvString[1],offs-start);
                    EnvString[0]:=chr(offs-start); offs:=succ(offs);
                    GetEnvironment:=0;
              end
         else begin GetEnvironment:=Error_Val; EnvString:=''; end;
end;

function SearchEnvironment(EnvString:StringType):StringType;
var  dummy:StringType; first,ready:boolean; i:byte;
begin SearchEnvironment:='';
      for i:=1 to length(EnvString) do EnvString[i]:=UpCase(EnvString[i]);
      if pos('=',EnvString)=0 then EnvString:=EnvString+'='; first:=true; ready:=false;
      while (GetEnvironment(dummy,first)<>Error_Val) and not ready do
      begin first:=false;
            if pos(EnvString,copy(dummy,1,length(EnvString)))=1
               then begin SearchEnvironment:=dummy; ready:=true; end
               else ready:=false;
      end;
end;


end.
