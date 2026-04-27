{$R-,S-,I-,D-,F-,V+,B+,N-,L- }
{$M 1500,0,0 }
{$DEFINE Debug }
{$UNDEF  Debug }

unit IStr_;

interface

     uses   dos,crt,crt_;

     function IStr(str1:string; y,x:integer):string;

implementation

     function IStr(str1:string; y,x:integer):string;
     var ch            : char;
         i,lng         : integer;
         hilf          : string[255];
     begin hilf:=str1; lng:=length(hilf); i:=1;
           repeat c2_write(y,x,hilf); gotoxy(x-1+i,y); ch:=readkey;
                  case ch of
                   #0: begin ch:=readkey;
                             case ch of
                             #75: if i=  1 then i:=lng else i:=i-1;
                             #77: if i=lng then i:=  1 else i:=i+1;
                             end;
                       end;
                   #8:       if i>1 then begin i:=i-1; hilf[i]:=' '; end;
          'é','ô','ö',
          'Ñ','î','Å',
         '·',' '..'~': begin hilf[i]:=ch;
                             if i=lng then i:=1 else i:=i+1;
                       end;
                  end;
           until ch=#13;
           c1_write(y,x,hilf); IStr:=hilf;
     end;

end.
