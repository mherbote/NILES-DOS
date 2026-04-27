{$R-,S-,I-,D-,F-,V+,B+,N-,L+ }
{$M 3000,0,0 }
{$DEFINE Debug }
{$UNDEF  Debug }

{*******************************************
 * MBAT1.PAS                               *
 * COMMANDO-Prozessor des SYSTEMs          *
 *                                         *
 *        (c) by NILES-SOFT 1989 VERS. 2.3 *
 *           Programmierer: Marcus Herbote *
 *******************************************}

uses   dos,crt,crt_,Fenster_,Batch_;

const  copyrc                      = '(c) 88,89 by NILES-SOFT';
       pc1                         = 'Modul:   M B A T 1';
       pc2                         = 'Version  2 . 3';
       pc3                         = '18.05.89';

var    NamS,NamO                   : Word;
       i,j,k                       : Integer;

Label  zz;

function HexB(b:Byte):String;
const hex_array:array [0..15] of char='0123456789ABCDEF';
begin HexB:=hex_array[b shr 4]+hex_array[b and $0f]; end;

procedure color_clr;
begin c1_write(1,1,''); clrscr; end;

procedure bild(name:str12);
  var i1,i2,j : integer;
      xyc     : Boolean;
  procedure erweiterung;
    var i,j:integer;
  begin if length(cop[1])<16 then cop[1]:=cop[1]+'              ';
        move(cop[1][4],cop[2][1],12); cop[2][0]:=chr(12);
        assign(ip[2],path_bat2+cop[2]); reset(ip[2]);
        if IOResult=0
           then begin ini(2); end2:=end1+1;
                      while not eof(ip[2]) do
                      begin with drec[end2] do
                            begin move(cop[2][1],c,1); move(cop[2][2],k,1);
                                  cpos:=4; y:=ib(2); x:=ib(2);
                                  move(cop[2][9],t,length(cop[2])-8);
                                  t[0]:=chr(length(cop[2])-9);
                            end;
                            end2:=end2+1; ini(2);
                      end;
                      end2:=end2-1; close(ip[2]);
                      for j:=end1+1 to end2 do
                          begin gotoxy(drec[j].x,drec[j].y); write(drec[j].t) end;
                end;
  end;
  procedure fenster1(id:integer);
    var rah : record x1,y1                   : integer;
                     x2,y2                   : integer;
                     c1,c2,c3,c4,c5,c6,c7,c8 : char;
              end;
        i   : integer;
  begin cpos:=4;
        with rah do
             begin x1:=ib(id); y1:=ib(id); x2:=ib(id); y2:=ib(id);
                   c1:=cb(id); c2:=cb(id); c3:=cb(id); c4:=cb(id);
                   c5:=cb(id); c6:=cb(id); c7:=cb(id); c8:=cb(id);
                   if xyc
                      then begin fenster(2,x1,y1,x2,y2,c1,c2,c3,c4,c5,c6,c7,c8,copyrc,pc1,pc2,pc3);
                                 xyc:=false;
                           end
                      else       fenster(0,x1,y1,x2,y2,c1,c2,c3,c4,c5,c6,c7,c8,'','','','');
             end;
  end;
  procedure color_in(c1:integer);
  begin cpos:=4; farbe[1,1]:=ib(1); farbe[1,2]:=ib(1);
                 farbe[2,1]:=ib(1); farbe[2,2]:=ib(1);
        case c1 of 1: color_clr; end;
  end;
  procedure ueberlesen1;
  begin repeat ini(1); until (cop[1][1]<>'>') or (eof(ip[1])); end;
  procedure drec_in(var pos:integer; c1:integer);
  begin with drec[pos] do
             begin move(cop[1][1],c,1); move(cop[1][2],k,1);
                   cpos:=4; y:=ib(1); x:=ib(1);
                   move(cop[1][ 9],a,                5); a[0]:=chr(4);
                   move(cop[1][14],t,length(cop[1])-13); t[0]:=chr(length(cop[1])-14);
             end;
        case c1 of
          1: begin pos:=pos+1; ueberlesen1 end;
        end;
  end;
{.PA}
begin color_clr; zp:=2; xp:=2; yp:=1; xyc:=true;
      if f_bild
         then begin assign(ip[1],path_bat2+name ); reset(ip[1]);
                    ini(1);
                    if cop[1,1]='C' then color_in(1); close(ip[1]);
              end;
{-----------------}
      assign(ip[1],path_bat2+'WURZEL'); reset(ip[1]);
      ini(1); ini(1); ini(1);
      while (cop[1][1]='T') and not eof(ip[1]) do ini(1);
      while (cop[1][1] in ['C','W','E']) and not eof(ip[1]) do
            begin case cop[1][1] of
                  'E': erweiterung;
                  'W': fenster1(1);
                  'C': {if f_bild then color_in(1);}
                  end;
                  ini(1);
            end;
      end1:=2;
      while not eof(ip[1]) do drec_in(end1,1);
      end1:=end1-1; close(ip[1]);
{-----------------}
      assign(ip[1],path_bat2+name ); reset(ip[1]);
      repeat ini(1);
             case cop[1][1] of
             'E': erweiterung;
             'W': fenster1(1);
             'C': if f_bild then color_in(2);
             end;
      until (cop[1][1]<>'C') and (cop[1][1]<>'W') and (cop[1][1]<>'E') or (eof(ip[1]));
      end2:=1;
      if not eof(ip[1]) then drec_in(end2,0);
      ini(1); end2:=end1+1;
      while (not eof(ip[1])) and (cop[1][1]<>'>') and (cop[1][1]<>'$') do drec_in(end2,1);
      end2:=end2-1; close(ip[1]);
{-----------------}
{$IFDEF Debug}
      clrscr; writeln(end2);
      for i1:=1 to end2 do with drec[i1] do
          writeln(c,';',k,';',x:2,';',y:2,';',a,';',t); halt(1);
{$ENDIF}

      for i1:=1 to length(drec[1].t) do
          begin gotoxy(drec[1].x-1+i1,drec[1].y-1); write('-');
                gotoxy(drec[1].x-1+i1,drec[1].y+1); write('-');
          end;
      gotoxy(drec[1].x+1,drec[1].y-1); write(name);
      for i1:=1 to end2 do
          begin gotoxy(drec[i1].x-4,drec[i1].y); write(drec[i1].k);
                gotoxy(drec[i1].x  ,drec[i1].y); write(drec[i1].t);
                case drec[i1].k of
                'z': zp:=i1;
                'x': xp:=i1;
                'y': yp:=i1;
                end;
          end;
end;

{.PA}
procedure wahl;
  const hint    = 1;
        vorn    = 2;
        grund   = 1;
        ausw    = 2;
  var ch        : char;
      i         : integer;
      weiter    : boolean;
  procedure c_ein;
  begin c2_write(drec[w].y,drec[w].x-4,drec[w].k+'   '+drec[w].t);
        c1_write(25,1,'');
        if mouse then begin reg.cx:=(drec[w].x-1)*8+4;
                            reg.dx:=(drec[w].y-1)*8+4; reg.ax:=4; intr(51,reg);
                            reg.ax:=2;                            intr(51,reg);
                      end;
        weiter:=false;
  end;
  procedure c_aus;
  begin if mouse then begin reg.cx:=(drec[w].x-1)*8+4;
                            reg.dx:=(drec[w].y-1)*8+4; reg.ax:=4; intr(51,reg);
                            reg.ax:=2;                            intr(51,reg);
                      end;
        c1_write(drec[w].y,drec[w].x-4,drec[w].k+'   '+drec[w].t);
  end;
  procedure farb_mod;
    var f1,f2 : integer;
        ch    : char;
  begin f1:=grund; f2:=hint;
        f_bild:=false;
        c_write(25,1,red,yellow,anz0+anz1[f1]+anz2[f2]);
        repeat c_ein; ch:=readkey; c_aus;
               case ch of
                #0: begin ch:=readkey;
                          case ch of
                          #71: f1:=grund;           { Pos1 /...._e }
                          #79: f1:=ausw;            { Ende /...._a }
                          #82: f2:=hint;            { Einfg/hint_. }
                          #83: f2:=vorn;            { Entf /vorn_. }
                          #73: case f2 of           { Bild h       }
                                 1: if farbe[f1,f2]> 0
                                       then farbe[f1,f2]:=farbe[f1,f2]-1
                                       else farbe[f1,f2]:= 7;
                                 2: if farbe[f1,f2]> 0
                                       then farbe[f1,f2]:=farbe[f1,f2]-1
                                       else farbe[f1,f2]:=15;
                               end;
                          #81: case f2 of           { Bild r       }
                                 1: if farbe[f1,f2]< 7
                                       then farbe[f1,f2]:=farbe[f1,f2]+1
                                       else farbe[f1,f2]:=0;
                                 2: if farbe[f1,f2]<15
                                       then farbe[f1,f2]:=farbe[f1,f2]+1
                                       else farbe[f1,f2]:=0;
                               end;
                          end;
                    end;
          '0'..'9': farbe[f1,f2]:=ord(ch)-ord('0')   ;
          'a'..'f': farbe[f1,f2]:=ord(ch)-ord('a')+10;
          'A'..'F': farbe[f1,f2]:=ord(ch)-ord('A')+10;
               end;
               bild(nam);
               c_write(25,1,red,yellow,anz0+anz1[f1]+anz2[f2]);
        until ch=#68;
        c1_write(25, 1,''); clreol; f_bild:=true;
        Assign(ip[1],path_bat2+nam       ); assign(ip[2],path_bat2+nam+'.BAT');
        SetFAttr(ip[1],Archive); Reset(ip[1]); Rewrite(ip[2]);
        write(ip[2],'C ,'); i_out(farbe[1,1],2); i_out(farbe[1,2],2);
                            i_out(farbe[2,1],2); i_out(farbe[2,2],2);
        writeln(ip[2]);
        repeat ini(1);
               if cop[1][1]<>'C' then writeln(ip[2],cop[1]);
        until eof(ip[1]);
        close(ip[1]); close(ip[2]); erase(ip[1]); rename(ip[2],path_bat2+nam);
        SetFAttr(ip[2],ReadOnly+Hidden+SysFile);
end;
{.PA}
begin c_ein;
      repeat if mouse
             then begin reg.ax:=3; intr(51,reg);
                        if (reg.cx/8<drec[w].x-2)
                           then begin c_aus; if w> 2   then w:=w-1 else w:=end2;
                                      c_ein;
                                end;
                        if (reg.cx/8>drec[w].x+2)
                           then begin c_aus; if w<end2 then w:=w+1 else w:=2;
                                      c_ein;
                                end;
                        if (reg.dx/8<drec[w].y-2)
                           then begin c_aus; if w> 2   then w:=w-1 else w:=end2;
                                      c_ein;
                                end;
                        if (reg.dx/8>drec[w].y+2)
                           then begin c_aus; if w<end2 then w:=w+1 else w:=2;
                                      c_ein;
                                end;
                        case reg.bx of
                          0: begin               ch:=#63; weiter:=true;        end;
                          1: begin               ch:=#13; weiter:=true;        end;
                          2: begin c_aus; w:=zp; ch:=#63; weiter:=true; c_ein; end;
                          3: begin c_aus; w:=xp; ch:=#63; weiter:=true; c_ein; end;
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
                                          #72: begin if w> 2   then w:=w-1         { Auf }
                                                               else w:=end2; c_ein;
                                               end;
                                          #75: begin if w> 2   then w:=w-1         { Links }
                                                               else w:=end2; c_ein;
                                               end;
                                          #77: begin if w<end2 then w:=w+1         { Rechts }
                                                               else w:=2;    c_ein;
                                               end;
                                          #80: begin if w<end2 then w:=w+1         { Ab }
                                                               else w:=2;    c_ein;
                                               end;
                                          #82: ;                                   { Ins }
                                          #83: ;                                   { Del }
                                          #68: begin farb_mod; c_ein end;          { F10 }
                                          else c_ein;
                                          end;
                                    end;
                               #13: ;                                          { RETURN (Enter) }
                               #27: begin clrscr;                                  { ESC }
                                          bild(nam);
                                    end;
                               else                                        { "normales" Zeichen }
                                    begin for i:=2 to end2 do
                                              if ch=drec[i].k then w:=i;
                                              c_ein;
                                    end;
                               end;
                         end;
      until ch=#13;
      c_aus;
end;

procedure exec_bat(ei:integer);
begin cop[1]:=nam+' '+drec[w].c+' '+drec[w].k+' ';
      str(drec[w].x,cop[2]); cop[1]:=cop[1]+cop[2]+' ';
      str(drec[w].y,cop[2]); cop[1]:=cop[1]+cop[2];
      exec(path_progr+'CREATE_B.EXE',cop[1]);
      case ei of
        1: begin exec(path_progr+'CHANGE_B.EXE',nam);
{                exec(path_progr+'RESOLVE.EXE' ,nam);}
           end;
      end;
end;

procedure exec_comm;
begin delete(cop[1],1,2);
      i:=pos(';',cop[1]); if i>0 then delete(cop[1],i,length(cop[1])-i+1);
      i:=pos(' ',cop[1]);
      if i=0
      then       cop[2]:=''
      else begin cop[2]:=copy(cop[1],i+1,length(cop[1])-i);
                 delete(cop[1],i,length(cop[1])-i+1);
           end;
      exec(cop[1]+'.COM',cop[2]); if DosError=2 then exec(cop[1]+'.EXE',cop[2]);
end;


{.PA}
begin {$IFDEF Debug} CheckBreak:=true; {$ELSE} CheckBreak:=false; {$ENDIF}
      NamS:=MemW[PrefixSeg:$81]; NamO:=MemW[PrefixSeg:$83];
{$IFDEF Debug}
Writeln(HexB(Hi(NamS)),HexB(Lo(NamS)),':',HexB(Hi(NamO)),HexB(Lo(NamO)));
{$ENDIF}
      color_clr; f_bild:=true;

{ ===== H A U P T - Teil =============================================anfang= }
      nam:=''; for w:=0 to 3 do nam:=nam+chr(mem[NamS:NamO+w]);
      w:=MemW[NamS:NamO+4];

zz:   bild(nam); if w=-1 then w:=zp; wahl; gotoxy(1,25);

      case drec[w].c of
      'm': begin nam:=drec[w].a;

                 w:=-1;
           end;
      'b': exec_bat(1);
      'l': exec_bat(2);
      '~': exec_bat(1);
      'y': exec(path_progr+'EBATCH.EXE','');
      end;
      MemW[NamS:NamO+4]:=w; for w:=0 to 3 do mem[NamS:NamO+w]:=ord(nam[w+1]);
      w:=MemW[NamS:NamO+4];
      if w=-1 then Goto zz;
{ ===== H A U P T - Teil ===============================================ende= }
end.
