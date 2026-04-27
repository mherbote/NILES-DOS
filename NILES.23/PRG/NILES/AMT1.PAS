{$R-,S-,I-,D-,F-,V+,B+,N-,L+ }
{$M 5000,0,0 }
{$DEFINE Debug }
{$UNDEF  Debug }

uses   dos,crt,crt_,Fenster_;

type   logd1_type                  = Array[1..43] Of Char;

var    logd1                       : File Of   logd1_type;
       logd2                       :           Text;
       i,iP                        :           Integer;
       z                           :           LongInt;
       crc,cr1,cr2,cr3             :           Word;
       Name,Pass1,Pass2            :           string[255];
       J,J1,J2,M,M1,M2,D,D1,D2,D11 :           Word;
       S,S1,S2,N,N1,N2,U,T1,T2,T11 :           Word;
       J3,M3,D3,H,Mi               :           Word;
       wei                         :           Boolean;
       Code                        :           Integer;
       hilf                        :           logd1_type;
       par2,par3,par4              :           String;

label  1;


begin {$IFDEF Debug} CheckBreak:=true; {$ELSE} CheckBreak:=false; {$ENDIF}
      c1_write(1,1,''); clrscr;

      Assign(logd1,'logbuch'); Reset(logd1); Assign(logd2,'logbuch1'); Rewrite(logd2);
      while not Eof(logd1) do
      begin Read(logd1,hilf);
{$IFDEF Debug }
Write(hilf);
{$ENDIF }
            if copy(hilf,1,13)<>'Ger„te-Nummer'
               then begin val(copy(hilf,22,4),J1,Code); val(copy(hilf,26,2),M1,Code); val(copy(hilf,28,2),D1,Code);
                          val(copy(hilf,22,4),J2,Code); val(copy(hilf,26,2),M2,Code); val(copy(hilf,28,2),D2,Code);
                          val(copy(hilf,30,2),S1,Code); val(copy(hilf,32,2),N1,Code);
                          val(copy(hilf,34,2),S2,Code); val(copy(hilf,36,2),N2,Code);
                          if S2<S1 then D2:=D1+1
                                   else if (S2=S1) and (N2<N1)
                                           then begin T11:=0; goto 1; end;

      if (D1<>D2) and (S1<=S2) then H:=24 else H:=0;
      if (D1=D2)  and (S1=S2)
         then begin H:=0; Mi:=N2-N1 end
         else if S2>S1 then begin H:=H+(S2-S1);
                                  if N2>=N1 then       Mi:=N2-N1
                                            else begin Mi:=(60-N1)+N2; H:=H-1; end;
                            end
                       else begin H:=(24-S1)+S2;
                                  if N2>N1  then       Mi:=N2-N1
                                            else begin Mi:=(60-N1)+N2; H:=H-1; end;
                            end;
      T11:=(H*60)+Mi;
1:    str(T11:4,par2); move(par2[1],hilf[38],4);
if t11>1000 then begin
{ $IFDEF Debug }
Write  (D1:2,'.',M1:2,'.',J1,',',S1:2,':',N1:2,'  ');
Write  (D2:2,'.',M2:2,'.',J2,',',S2:2,':',N2:2,'   ');
Writeln(T11:4);
Write(hilf); Readln;
{ $ENDIF }            end;
                    end;
            Write(logd2,hilf);
      end;
      Close(logd1); Close(logd2);
end.
