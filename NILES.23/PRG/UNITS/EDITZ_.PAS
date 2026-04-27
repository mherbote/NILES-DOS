{$R-,S-,I-,D-,F-,V+,B+,N-,L- }
{$M 1500,0,0 }
{$DEFINE Debug }
{$UNDEF  Debug }

unit EditZ_;

interface

     uses  Dos,Crt,Crt_,Fenster_;

     const BEL       = #07;
           ESC       = #27;
           BS        = #08;
           CR        = #13;

     var   EditStr   : String;

     procedure EditZ(lng:Integer; x1,y1,x2,y2:Integer);


implementation

     procedure EditZ(lng:Integer; x1,y1,x2,y2:Integer);
       var x,xp,fp,dx,h:Integer; ch:Char; ins:Boolean;
     begin if lng<0 then lng:=255;
           if x2-x1>lng then x2:=x1+lng+2;
           fenster(1,x1,y1,x2,y2,'É','Í','»','º','È','¼','º','Í','','','','');
           if x2-x1>20 then begin Window (  x1,y1,x2,y2); GotoXY(3,y2-y1+1); Write(' [ENTER]=Ende '); end;
           x:=0; xp:=0; dx:=x2-x1-1; if lng<255 then ins:=false else ins:=true;
           if (lng<255) and (length(EditStr)>lng) then delete(EditStr,lng+1,length(EditStr)-lng);
           repeat Window(x1+1,y1+1,x2-1,y2-1); ClrScr;
                  if length(EditStr)>(dx*(y2-y1-1))-1
                     then begin if (x-xp>((dx*(y2-y1-1))-1)/2)
                                   then xp:=x-((dx*(y2-y1-1))-1) div 2
                                   else if (x<((dx*(y2-y1-1))-1)/2)
                                           then xp:=0
                                           else if (x-xp<((dx*(y2-y1-1))-1)/2)
                                                   then xp:=x-((dx*(y2-y1-1))-1) div 2;
                                Write(copy(EditStr,xp+1,(dx*(y2-y1-1))-1));
                          end
                     else Write(EditStr);
                  Window(x1  ,y1  ,x2  ,y2  );
                  GotoXY(   1,1); if ins  then Write('INS') else Write('REP');
                  GotoXY(x2-x1-3,1); if dx>7 then Write(x+1:3);
                  Window(x1+1,y1+1,x2-1,y2-1); GotoXY(((x-xp) mod dx)+1,((x-xp) div dx)+1);
                  ch:=ReadKey;
                  case ch of
                  #0: begin ch:=ReadKey;
                            case ch of
{ --->   }                  #77: if x+1 > length(EditStr) then Write(BEL) else x:=x+ 1;
{ <---   }                  #75: if x   =        0  then Write(BEL) else x:=x- 1;
{ hoch   }                  #72: if x+1 <       dx  then Write(BEL) else x:=x-dx;
{ runter }                  #80: if x+dx> length(EditStr) then Write(BEL) else x:=x+dx;
{ Pos 1  }                  #71:                                         x:=0;
{ Ende   }                  #79:                                         x:=length(EditStr);
{ Einfg  }                  #82: if ins then ins:=false else ins:=true;
{ Entf   }                  #83: if x+1 <=length(EditStr) then delete(EditStr,x+1,1)
                                                    else Write(BEL);
{ Ctrl-A }                 #115: if x=0
                                    then Write(BEL)
                                    else begin while (x>0) and (copy(EditStr,x,1)= ' ') do x:=x-1;
                                               while (x>0) and (copy(EditStr,x,1)<>' ') do x:=x-1;
                                         end;
{ Ctrl-F }                 #116: if x+1>length(EditStr)
                                    then Write(BEL)
                                    else begin while (x+1<length(EditStr)) and (copy(EditStr,x+2,1)<>' ') do x:=x+1;
                                               while (x+1<length(EditStr)) and (copy(EditStr,x+2,1)= ' ') do x:=x+1;
                                               x:=x+1;
                                         end;
                            end;
                      end;
                  BS: if x=0 then Write(BEL)
                             else begin delete(EditStr,x,1); x:=x-1; end;
{ Ctrl-A }        ^A: if x=0
                         then Write(BEL)
                         else begin while (x>0) and (copy(EditStr,x,1)= ' ') do x:=x-1;
                                    while (x>0) and (copy(EditStr,x,1)<>' ') do x:=x-1;
                              end;
{ Ctrl-F }        ^F: if x>length(EditStr)
                         then Write(BEL)
                         else begin while (x+1<length(EditStr)) and (copy(EditStr,x+2,1)<>' ') do x:=x+1;
                                    while (x+1<length(EditStr)) and (copy(EditStr,x+2,1)= ' ') do x:=x+1;
                                    x:=x+1;
                              end;
                  CR: ;
                 else if (length(EditStr)>=lng) and ins
                         then Write(BEL)
                         else if x+1>lng then Write(BEL)
                                         else begin if not ins then delete(EditStr,x+1,1);
                                                    insert(ch,EditStr,x+1); x:=x+1;
                                              end;
                  end;
           until ch=CR;
           if (lng<255) and (length(EditStr)>lng) then delete(EditStr,lng+1,length(EditStr)-lng);
           Window( 1, 1,80,25);
     end;


end.
