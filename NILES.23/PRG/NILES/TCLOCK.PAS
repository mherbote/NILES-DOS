{$R-,S-,I-,D-,F-,V+,B+,N-,L+ }
{$M 1500,0,0 }
{$DEFINE Debug }
{$UNDEF  Debug }

{*******************************************
 * TCLOCK.PAS                              *
 * System-Datum und -Uhrzeit anzeigen      *
 *                                         *
 *        (c) by NILES-SOFT 1988 VERS. 1.0 *
 *           Programmierer: Marcus Herbote *
 *******************************************}

uses   dos,crt,crt_,fenster_;

const  copyrc                      = '(c) 88 by NILES-SOFT';
       pc1                         = 'M o d u l :     T  C  L  O  C  K';
       pc2                         = 'V e r s i o n   1  .  0';
       pc3                         = '13.05.88';

var    auswahl                     : array[1..50] of record x : integer;
                                                            y : integer;
                                                            t : string[255];
                                                     end;
       weiter                      : Boolean;
       w                           : Integer;
       reg                         : Registers;
       ch                          : Char;
       J,J1,J2,M,M1,M2,D,D1,D2,D11 :           Word;
       S,S1,S2,N,N1,N2,U,T1,T2,T11 :           Word;
       U1,U2                       :           Word;
       wei                         :           Boolean;
       Code                        :           Integer;
       hilf                        :           string[255];

function HexB(b:Byte):String;
const hex_array:array [0..15] of char='0123456789ABCDEF';
begin HexB:=hex_array[b shr 4]+hex_array[b and $0f]; end;

function HexBB(b:Byte):Byte;
const hex_array:array [0..15] of Byte=(0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15);
begin HexBB:=hex_array[b shr 4]*10+hex_array[b and $0f]; end;

function BHexB(b:Byte):Byte;
  var i:Integer;
begin i:=b div 10; BHexB:=i*16+(b-i*10); end;

procedure input_datum(www:Integer);
  var ch            : char;
      i             : integer;
      day,mon,y     : string[ 2];
      dat           : string[10];
begin repeat str(D:2,day); str(M:2,mon); str(J:2,y); dat:=day+'.'+mon+'.'+y+'  ';
        for i:=1 to 8 do if dat[i]=' ' then dat[i]:='0'; i:=1;
        repeat gotoxy(24,www); write(dat); gotoxy(23+i,www);
          ch:=readkey;
          case ch of
           #0: begin ch:=readkey;
                     case ch of
                     #75: case i of 7,4: i:=i-2;
                                      1: i:=8;
                                    else i:=i-1;
                          end;
                     #77: case i of 2,5: i:=i+2;
                                      8: i:=1;
                                    else i:=i+1;
                          end;
                     end;
               end;
     '0'..'9': begin dat[i]:=ch; case i of 2,5: i:=i+2;
                                             8: i:=1;
                                           else i:=i+1;
                                 end;
               end;
          end;
        until ch=#13;
        val(copy(dat,1,2),D,Code); val(copy(dat,4,2),M,Code); val(copy(dat,7,2),J,Code);
      until ((M in [1,3,5,7,8,10,12]) and (D<32)) or
            ((M in [  4,6,  9,11   ]) and (D<31)) or
            ((M in [2              ]) and (D<30));
end;

procedure input_time(www:Integer);
  var ch            : char;
      i             : integer;
      stund,min     : string[2];
      dat           : string[8];
begin repeat str(S:2,stund); str(N:2,min); dat:=stund+':'+min+'   ';
        for i:=1 to 5 do if dat[i]=' ' then dat[i]:='0'; i:=1;
        repeat gotoxy(37,www); write(dat); gotoxy(36+i,www);
          ch:=readkey;
          case ch of
           #0: begin ch:=readkey;
                     case ch of
                     #75: case i of 4: i:=i-2;
                                    1: i:=5;
                                  else i:=i-1;
                          end;
                     #77: case i of 2: i:=i+2;
                                    5: i:=1;
                                  else i:=i+1;
                          end;
                     end;
               end;
     '0'..'9': begin dat[i]:=ch; case i of 2: i:=i+2;
                                           5: i:=1;
                                         else i:=i+1;
                                 end;
               end;
          end;
        until ch=#13;
        val(copy(dat,1,2),S,Code); val(copy(dat,4,2),N,Code);
      until (N in [0..59]) or (S in [0..23]);
end;

procedure wahl1(aanz:Integer);
  var i : Integer;
  procedure c_ein;
  begin {textbackground(red); textcolor(yellow);
        gotoxy(auswahl[w].x,auswahl[w].y); write(auswahl[w].t);
        gotoxy(1,25);
        weiter:=false;}
  end;
  procedure c_aus;
  begin {textbackground(blue); textcolor(yellow);
        gotoxy(auswahl[w].x,auswahl[w].y); write(auswahl[w].t);}
  end;
begin Window(1,1,80,25); ch:=#0;
      if keypressed then begin ch:=readkey;
                               case UpCase(ch) of
                               'S': w:=1;
                               'C': w:=2;
                               'E': w:=3;
                               end;
                         end;
end;


begin {$IFDEF Debug} CheckBreak:=true; {$ELSE} CheckBreak:=false; {$ENDIF}
      c1_write(1,1,'');
      clrscr;
      Window( 9, 9,70,16); clrscr; Window( 1, 1,80,25);
      fenster(1, 9, 9,70,16,'É','Í','»','º','È','¼','º','Í',copyrc,pc1,pc2,pc3);

      auswahl[1].x:= 3; auswahl[1].y:=25; auswahl[1].t:='SYSTEM';
      auswahl[2].x:=33; auswahl[2].y:=25; auswahl[2].t:='C M O S';
      auswahl[3].x:=63; auswahl[3].y:=25; auswahl[3].t:='Programm beenden';
      for Code:=1 to 3 do
          begin GotoXY(auswahl[Code].x,auswahl[Code].y); Write(auswahl[Code].t); end;

      repeat GetDate(J1,M1,D1,D11); str(J1,hilf); val(copy(hilf,3,2),J1,Code);
                                                  val(copy(hilf,1,2),U1,Code);
                                    J2:=J1; M2:=M1; D2:=D1;
             GetTime(S1,N1,T1,T11); S2:=S1; N2:=N1;
             gotoxy(15,13); write('SYSTEM : ',D1:2,'.',M1:2,'.',U1:2,J1:2,'   ',S1:2,':',N1:2,':',T1:2);
             Port[$70]:=$32; U2:=Port[$71];
             Port[$70]:=$09; J2:=Port[$71];
             Port[$70]:=$07; D2:=Port[$71];
             Port[$70]:=$08; M2:=Port[$71];
             Port[$70]:=$04; S2:=Port[$71];
             Port[$70]:=$02; N2:=Port[$71];
             Port[$70]:=$00; T2:=Port[$71];
             gotoxy(15,14); write('C M O S: ');
             write(HexB(D2),'.',HexB(M2),'.',HexB(U2),HexB(J2),'   ');
             write(HexB(S2),':',HexB(N2),':',HexB(T2));
             w:=0; wahl1(3);
             case w of
               1: begin gotoxy(19,8); textbackground(red ); write('SYSTEM');
                        U:=U1; J:=J1; M:=M1; D:=D1; S:=S1; N:=N1;
                        input_datum(13); input_time(13);
                        J:=U*100+J; SetDate(J,M,D); SetTime(S,N,1,0);
                        textbackground(blue);
                        Window (10,12,69,15); clrscr; Window ( 1, 1,80,25);
                        gotoxy(19,8); write('      ');
                  end;
               2: begin gotoxy(19,8); textbackground(red ); write('C M O S');
                        U:=HexBB(U2); J:=HexBB(J2); M:=HexBB(M2);
                        D:=HexBB(D2); S:=HexBB(S2); N:=HexBB(N2);
                        input_datum(14); input_time(14);
                        Port[$70]:=$09; Port[$71]:=BHexB(J);
                        Port[$70]:=$07; Port[$71]:=BHexB(D);
                        Port[$70]:=$08; Port[$71]:=BHexB(M);
                        Port[$70]:=$04; Port[$71]:=BHexB(S);
                        Port[$70]:=$02; Port[$71]:=BHexB(N);
                        textbackground(blue);
                        Window (10,12,69,15); clrscr; Window ( 1, 1,80,25);
                        gotoxy(19,8); write('       ');
                  end;
             end;
      until w=3;

{$IFDEF Debug}
GetDate(J1,M1,D1,D11); str(J1,hilf); val(copy(hilf,3,2),J1,Code);
                       J2:=J1; M2:=M1; D2:=D1;
GetTime(S1,N1,T1,T11); S2:=S1; N2:=N1;
gotoxy(1,22); write(D :2,'.',M :2,'.',    J :2,'   ',S :2,':',N :2         );
gotoxy(1,23); write(D1:2,'.',M1:2,'.',U:2,J1:2,'   ',S1:2,':',N1:2,':',T1:2);
{$ENDIF}

end.
