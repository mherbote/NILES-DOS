{$R-,S-,I-,D-,F-,V+,B+,N-,L- }
{$M 1500,0,0 }
{$DEFINE Debug }
{$UNDEF  Debug }

unit Wahl_;

interface

uses   dos,crt,crt_,Fenster_;

var   auswahl : array[1..15] of record x : integer;
                                       y : integer;
                                       t : string[255];
                                end;
      weiter  : Boolean;
      mouse   : Boolean;
      w       : Integer;
      reg     : Registers;
      ch      : Char;

procedure wahl1(aanz:Integer);

implementation

procedure wahl1(aanz:Integer);
  var i : Integer;
  procedure c_ein;
  begin c2_write(auswahl[w].y,auswahl[w].x,auswahl[w].t);
        gotoxy(1,25);
        if mouse then begin reg.cx:=(auswahl[w].x-1)*8+4;
                            reg.dx:=(auswahl[w].y-1)*8+4; reg.ax:=4; intr(51,reg);
                            reg.ax:=2;                               intr(51,reg);
                      end;
        weiter:=false;
  end;
  procedure c_aus;
  begin if mouse then begin reg.cx:=(auswahl[w].x-1)*8+4;
                            reg.dx:=(auswahl[w].y-1)*8+4; reg.ax:=4; intr(51,reg);
                            reg.ax:=2;                            intr(51,reg);
                      end;
        c1_write(auswahl[w].y,auswahl[w].x,auswahl[w].t);
  end;
begin Window(1,1,80,25); ch:=#0;
      for i:=1 to aanz do c1_write(auswahl[i].y,auswahl[i].x,auswahl[i].t);
      c_ein;
      repeat if mouse
             then begin reg.ax:=3; intr(51,reg);
                        if (reg.cx/8<auswahl[w].x-2)
                           then begin c_aus; if w> 1   then w:=w-1 else w:=aanz;
                                      c_ein;
                                end;
                        if (reg.cx/8>auswahl[w].x+2)
                           then begin c_aus; if w<aanz then w:=w+1 else w:=1;
                                      c_ein;
                                end;
                        if (reg.dx/8<auswahl[w].y-2)
                           then begin c_aus; if w> 1   then w:=w-1 else w:=aanz;
                                      c_ein;
                                end;
                        if (reg.dx/8>auswahl[w].y+2)
                           then begin c_aus; if w<aanz then w:=w+1 else w:=1;
                                      c_ein;
                                end;
                        case reg.bx of
                          0: begin ch:=#63; weiter:=true; end;
                          1: begin ch:=#13; weiter:=true; end;
                          2: begin ch:=#63; weiter:=true; end;
                          3: begin ch:=#63; weiter:=true; end;
                        end;
                  end;
             if keypressed
                    then begin ch:=readkey; c_aus;
                               case ch of
                                #0: begin ch:=readkey;                          { Spezialtasten: }
                                          case ch of
                                          #33: ;                                   { Alt-F }
                                          #44: ;                                   { Alt-Z }
                                          #45: ;                                   { Alt-X }
                                          #72: begin if w> 1   then w:=w-1         { Auf }
                                                               else w:=aanz; c_ein;
                                               end;
                                          #75: begin if w> 1   then w:=w-1         { Links }
                                                               else w:=aanz; c_ein;
                                               end;
                                          #77: begin if w<aanz then w:=w+1         { Rechts }
                                                               else w:=1;    c_ein;
                                               end;
                                          #80: begin if w<aanz then w:=w+1         { Ab }
                                                               else w:=1;    c_ein;
                                               end;
                                          #82: ;                                   { Ins }
                                          #83: ;                                   { Del }
                                          #68: ;                                   { F10 }
                                          else c_ein;
                                          end;
                                    end;
                               #13: ;                                          { RETURN (Enter) }
                               #27: ;                                              { ESC }
                               else                                        { "normales" Zeichen }
                               end;
                         end;
      until ch=#13;
end;

begin reg.ax:=0; intr(51,reg);
      case reg.ax of
        0: begin mouse:=false; end;
      $FF: begin mouse:=true;
                 reg.ax:=7; reg.cx:=0; reg.dx:=80*8; intr(51,reg);
                 reg.ax:=8; reg.cx:=0; reg.dx:=25*8; intr(51,reg);
                 reg.ax:=2;                          intr(51,reg);
           end;
      end;
end.