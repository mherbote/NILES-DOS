{$R-,S-,I-,D-,F-,V+,B+,N-,L- }
{$M 1500,0,0 }
{$DEFINE Debug }
{$UNDEF  Debug }

unit BauDat_;

interface

     uses dos,crt,crt_;

     type   baudat      = record
                                 schl : array[1.. 4] of char;
                                 bs1  : array[1.. 4] of char;
                                 bs2  : array[1.. 3] of char;
                                 bs3  : array[1.. 2] of char;
                                 bs4  : array[1.. 2] of char;
                                 bez  : array[1..35] of char;
                                 f1   : array[1.. 2] of char;
                          end;

     var    baud_d      : file of baudat;
            baud_p      :         baudat;
            baud_exit   :         Boolean;

     procedure baud_O;
     procedure baud_R;
     procedure baud_W;
     procedure baud_C;

implementation

     procedure baud_O;
     begin Assign  (baud_d,'BAU.DAT'); SetFAttr(baud_d,Archive);
           Reset   (baud_d);
           if (IOResult=0) and (FileSize(baud_d)>0) then baud_exit:=true
                                                     else baud_exit:=false;
           if not baud_exit then
              begin ClrScr;
                    c4_write(10,20,'Die Datei  "BAU.DAT"  ist nicht ');
                    c4_write(11,20,'      e x i s t e n t !!!       ');
                    baud_p.schl[1]:=ReadKey; halt(1);
              end;
     end;

     procedure baud_R; begin Read (baud_d,baud_p); end;

     procedure baud_W; begin Write(baud_d,baud_p); end;

     procedure baud_C; begin Close(baud_d);        end;


end.
