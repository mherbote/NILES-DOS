{$R-,S-,I-,D-,F-,V+,B+,N-,L+ }
{$M 1500,0,0 }
{$DEFINE Debug }
{$UNDEF  Debug }
{.PL96}

     uses dos,crt;

     type   LogNam1                 = record bea     : array[1.. 5] of char;
                                             nil1    :                 char;
                                             Bearb   : array[1..22] of char;
                                             mpz     : array[1.. 8] of char;
                                             sk      : array[1.. 2] of char;
                                      end;
     type   LogNam2                 = record bea     : array[1.. 5] of char;
                                             nil1    :                 char;
                                             Bearb   : array[1..22] of char;
                                             mpz     : array[1.. 8] of char;
                                             check   : array[1..80] of char;
                                             sk      : array[1.. 2] of char;
                                      end;

     var    LogNam1_d               : file   of LogNam1;
            LogNam1_p               :           LogNam1;
            LogNam2_d               : file   of LogNam2;
            LogNam2_p               :           LogNam2;
            leer                    : array[1..80] of char;
            i                       :           Integer;

begin Assign  (LogNam1_d,'A:\SYSLOG\LOGNAMEO.DAT');
      SetFAttr(LogNam1_d,Archive);
      Reset   (LogNam1_d);
      Assign  (LogNam2_d,'A:\SYSLOG\LOGNAMEO.');
      Rewrite (LogNam2_d);
      for i:=1 to 80 do leer[i]:=' ';
      while not Eof(LogNam1_d) do
      begin Read(LogNam1_d,LogNam1_p);
            with LogNam2_p do
            begin move(LogNam1_p.bea  [1],bea  [1], 5);
                  move(LogNam1_p.nil1    ,nil1    , 1);
                  move(LogNam1_p.Bearb[1],Bearb[1],22);
                  move(LogNam1_p.mpz  [1],mpz  [1], 8);
                  move(leer           [1],check[1],80);
                  move(LogNam1_p.sk   [1],sk   [1], 2);
            end;
            Write(LogNam2_d,LogNam2_p);
      end;
      Close(LogNam1_d); Close(LogNam2_d);
end.
