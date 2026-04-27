type h2_type   = record h21 : Array[1..14] Of Char;
                        h22 : Array[1.. 6] Of Char;
                        cr,
                        lf  : Char;
                 end;

var  f1,f3     : Text;
     h1,hh     : String;
     hhh       : Array[1..14] Of Char;
     f2        : File Of h2_type;
     k2        : h2_type;
     h2        : Array[1..20] Of h2_type;
     i,j       : Integer;

begin Assign(f2,'verbind');   Reset(f2); i:=0;
      while not Eof(f2) do
            begin i:=i+1;
                  Read(f2,k2);
                  h2[i]:=k2;
            end;
      Assign(f1,ParamStr(1)); Reset(f1); Assign(f3,'LOGBUCH.NEU'); Rewrite(f3);
      while not Eof(f1) do
      begin Readln(f1,h1);
            if copy(h1,1,13)='Ger„te-Nummer'
               then begin hh:=copy(h1,16,14); move(hh[1],hhh,14);
                          Delete(h1,16,14); j:=0;
                          repeat j:=j+1; until (hhh=h2[j].h21) or (j=i);
                          if hhh=h2[j].h21 then hh:=h2[j].h22
                                           else hh:='      ';
                          h1:=hh; for j:=1 to 35 do h1:=h1+' ';
                    end;
            Writeln(f3,h1);
      end;
      Close(f1); Close(f2); Close(f3);
end.
