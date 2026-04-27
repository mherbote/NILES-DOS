{$R-,S-,I-,D-,F-,V+,B+,N-,L+ }
{$M 3500,0,0 }
{$DEFINE Debug }
{$UNDEF  Debug }

{*******************************************
 * CLOCK.PAS                               *
 * Setzen von System-Datum und -Uhrzeit    *
 *                                         *
 *        (c) by NILES-SOFT 1988 VERS. 2.3 *
 *           Programmierer: Marcus Herbote *
 *******************************************}

uses   dos,crt,crt_,Fenster_,SysLog_,Batch_,Syshalt_,Mount_;

const  copyrc                      = '(c) 88,89 by NILES-SOFT';
       pc1                         = 'M o d u l :     C  L  O  C  K';
       pc2                         = 'V e r s i o n   2  .  3';
       pc3                         = '11.04.89';

var    J,J1,J2,M,M1,M2,D,D1,D2,D11 :           Word;
       S,S1,S2,N,N1,N2,U,T1,T2,T11 :           Word;
       wei                         :           Boolean;
       Code                        :           Integer;
       hilf                        :           string[255];

procedure input_datum;
  var ch            : char;
      i             : integer;
      day,mon,y     : string[2];
      dat           : string[8];
begin repeat str(D:2,day); str(M:2,mon); str(J:2,y); dat:=day+'.'+mon+'.'+y;
        for i:=1 to 8 do if dat[i]=' ' then dat[i]:='0'; i:=1;
        repeat c1_write(13,11,'heutiges Datum ===>'); c2_write(13,30,dat);
               gotoxy(29+i,13); ch:=readkey;
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
      c1_write(13,30,dat);
end;

procedure input_time;
  var ch            : char;
      i             : integer;
      stund,min     : string[2];
      dat           : string[5];
begin repeat str(S:2,stund); str(N:2,min); dat:=stund+':'+min;
        for i:=1 to 5 do if dat[i]=' ' then dat[i]:='0'; i:=1;
        repeat c1_write(15,11,'aktuelle Zeit  ===>'); c2_write(15,30,dat);
               gotoxy(29+i,15); ch:=readkey;
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
      until (N in [0..59]) and (S in [0..23]);
      c1_write(15,30,dat);
end;


begin {$IFDEF Debug} CheckBreak:=true; {$ELSE} CheckBreak:=false; {$ENDIF}
      c1_write(1,1,'');
      if paramstr(1)='C' then clrscr;
      Window( 9, 9,70,16); clrscr; Window( 1, 1,80,24);
      fenster(1, 9, 9,70,16,'É','Í','»','º','È','¼','º','Í',copyrc,pc1,pc2,pc3);
      GetDate(J1,M1,D1,D11); str(J1,hilf); val(copy(hilf,3,2),J1,Code);
                                           val(copy(hilf,1,2),U ,Code);
                             J2:=J1; M2:=M1; D2:=D1;
      GetTime(S1,N1,T1,T11); S2:=S1; N2:=N1;
{$IFDEF Debug}
gotoxy(1,20); write(D1:2,'.',M1:2,'.',U:2,J1:2,'   ',S1:2,':',N1:2,':',T1:2);
{$ENDIF}
      Mount_Log; SysLog_O;
      if SysLog_exit
         then begin Seek(SysLog_d,FileSize(SysLog_d)-1); SysLog_R;
{$IFDEF Debug}
gotoxy(1, 1); with SysLog_p do write(proj,',',bea,',',dwg,',',dat,',',tims,',',time,',',min,sk);
{$ENDIF}
                    val(copy(SysLog_p.dat ,3,2),J2,Code);
                    val(copy(SysLog_p.dat ,5,2),M2,Code);
                    val(copy(SysLog_p.dat ,7,2),D2,Code);
                    if SysLog_p.time='.....'
                       then begin val(copy(SysLog_p.tims,1,2),S2,Code);
                                  val(copy(SysLog_p.tims,3,2),N2,Code);
                            end
                       else begin val(copy(SysLog_p.time,1,2),S2,Code);
                                  val(copy(SysLog_p.time,3,2),N2,Code);
                            end;
                    if (J2<J1)
                    then begin J2:=J1; M2:=M1; D2:=D1; S2:=0; N2:=0; end
                    else if (J2=J1) and (M2<M1)
                         then begin    M2:=M1; D2:=D1; S2:=0; N2:=0; end
                         else if (M2=M1) and (D2<D1)
                              then begin       D2:=D1; S2:=0; N2:=0; end
                                   else if (D2=D1)
                                        then begin     S2:=S1; N2:=N1; end;
                    J:=J2; M:=M2; D:=D2;
                    repeat input_datum; wei:=true;
                           if            (J<J2) then wei:=false;
                           if (J=J2) and (M<M2) then wei:=false;
                           if (M=M2) and (D<D2) then wei:=false;
                    until wei;
                    if (J2<J)
                    then                           begin S2:=0; N2:=0; end
                    else if (J2=J) and (M2<M)
                         then                      begin S2:=0; N2:=0; end
                         else if (M2=M) and (D2<D)
                              then                 begin S2:=0; N2:=0; end;
                    S:=S1; N:=N1;
                    repeat input_time; wei:=true;
                           if            (S<S2) then wei:=false;
                           if (S=S2) and (N<N2) then wei:=false;
                    until wei;
              end
         else begin J:=J1; M:=M1; D:=D1;
                    repeat input_datum; wei:=true;
                           if            (J<J2) then wei:=false;
                           if (J=J2) and (M<M2) then wei:=false;
                           if (M=M2) and (D<D2) then wei:=false;
                    until wei;
                    S:=S1; N:=N1;
                    repeat input_time; wei:=true;
                           if            (S<S2) then wei:=false;
                           if (S=S2) and (N<N2) then wei:=false;
                    until wei;
              end;
      J:=U*100+J; SetDate(J,M,D); SetTime(S,N,1,0);
{$IFDEF Debug}
GetDate(J1,M1,D1,D11); str(J1,hilf); val(copy(hilf,3,2),J1,Code);
                       J2:=J1; M2:=M1; D2:=D1;
GetTime(S1,N1,T1,T11); S2:=S1; N2:=N1;
gotoxy(1,22); write(D :2,'.',M :2,'.',    J :2,'   ',S :2,':',N :2         );
gotoxy(1,23); write(D1:2,'.',M1:2,'.',U:2,J1:2,'   ',S1:2,':',N1:2,':',T1:2);
{$ENDIF}

      SysLog_C; Demount_Log;
      if paramstr(1)='C' then clrscr;
end.
