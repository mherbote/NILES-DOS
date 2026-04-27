{$R-,S-,I-,D-,F-,V+,B+,N-,L- }
{$M 1500,0,0 }
{$DEFINE Debug }
{$UNDEF  Debug }

unit Crt_;

interface

     uses dos,crt;

     var  farbe       : array[1..  2,1..  2] of integer;
          color       : Boolean;

     procedure c_write   (y,x,b,t : Byte; text : string);
     procedure c1_write  (y,x     : Byte; text : string);
     procedure c2_write  (y,x     : Byte; text : string);
     procedure c3_write  (y,x     : Byte; text : string);
     procedure c4_write  (y,x     : Byte; text : string);


implementation

     var Reg : Registers;

     procedure c_write(y,x,b,t:Byte; text:string);
     begin textbackground(b); textcolor(t);
           gotoxy(x,y); write(text);
     end;

     procedure c1_write(y,x:Byte; text:string);
     begin textbackground(farbe[1,1]); textcolor(farbe[1,2]);
           gotoxy(x,y); write(text);
     end;

     procedure c2_write(y,x:Byte; text:string);
     begin textbackground(farbe[2,1]); textcolor(farbe[2,2]);
           gotoxy(x,y); write(text);
     end;

     procedure c3_write(y,x:Byte; text:string);
     begin textbackground(farbe[1,1]); textcolor(farbe[1,2]+blink);
           gotoxy(x,y); write(text);
     end;

     procedure c4_write(y,x:Byte; text:string);
     begin textbackground(farbe[2,1]); textcolor(farbe[2,2]+blink);
           gotoxy(x,y); write(text);
     end;


begin intr($11,Reg);
      if (Reg.AX and $30)=$30
         then begin farbe[1,1]:=black; farbe[1,2]:=LightGray;
                    farbe[2,1]:=white; farbe[2,2]:=black;
                    color:=false;
              end
         else begin farbe[1,1]:=blue; farbe[1,2]:=yellow;
                    farbe[2,1]:=red;  farbe[2,2]:=yellow;
                    color:=true;
              end;
      c1_write(25,1,'');
end.
