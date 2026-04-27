{$R-,S-,I-,D-,F-,V+,B+,N-,L+ }
{$M 1024,0,0 }
{$DEFINE Debug }
{$UNDEF  Debug }

{*******************************************
 * TBATCH.PAS                              *
 * Simulation kurzer Tastatureingaben      *
 *            fuer Batch-Anwendungen       *
 *                                         *
 *        (c) by NILES-SOFT 1988 VERS. 2.3 *
 *           Programmierer: Marcus Herbote *
 *******************************************}

uses   dos,crt;

const  copyrc                      = '(c) 88,89 by NILES-SOFT';
       pc1                         = 'M o d u l :     T  B  A  T  C  H';
       pc2                         = 'V e r s i o n   2  .  3';
       pc3                         = '11.04.89';

type   str80      = string[80];

var    p          : integer;
       s          : str80;
       BufferHead : integer absolute $40:$1a;
       BufferTail : integer absolute $40:$1c;

function NextChar  : char;
begin p:=succ(p); if p<=length(s) then NextChar:=s[p] else NextChar:=' ' end;

procedure PutChar(c:char);
begin inline($FA); { Disable Interrupts }
      memw[$40:BufferTail]:=ord(c); BufferTail:=BufferTail+2;
      if BufferTail>=$3E then BufferTail:=$1E;
      inline($FB);    { Enable  Interrupts }
end;

procedure PutChar1(c:char);
begin inline($FA); { Disable Interrupts }
      memw[$40:BufferTail]:=ord(c); BufferTail:=BufferTail+1;
      if BufferTail>=$3E then BufferTail:=$1E;
      inline($FB);    { Enable  Interrupts }
end;

procedure Eintragen(s:str80);
var c:char;
begin p:=0; while p<length(s) do
            begin c:=NextChar;
                  case c of
                  '\': begin case UpCase(NextChar) of
                                  'S': begin PutChar1(^@);
                                             PutChar1(chr(ord(NextChar)-$40));
                                       end;
                                  'F': begin PutChar1(^@);
                                             case UpCase(NextChar) of
                                                  '9': PutChar1('C');
                                                  'A': PutChar1('D');
                                             end;
                                       end;
                                  'E':       PutChar(^[);
                                  'N': begin PutChar (^M ); PutChar (^J); end;
                                  'B':       PutChar (^H );
                                  'T':       PutChar (^I );
                                  '\':       PutChar ('\');
                                  ' ':       PutChar (' ');
                             end;
                       end;
                  '': PutChar(^M);
                  else PutChar(c);
                  end;
            end;
end;


begin {$IFDEF Debug} CheckBreak:=true; {$ELSE} CheckBreak:=false; {$ENDIF}
      s:='';
      if ParamCount<1 then s:=chr(27)+'\fa\n';
           {begin writeln(^G,'Kein Parameter angegeben !'); exit; end;}
      for p:=1 to ParamCount do s:=s+' '+Paramstr(p);
      delete(s,1,1);
      if length(s)<16 then Eintragen(s) else writeln(^G,'Zeichenkette zu lang !');
end.
