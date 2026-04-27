{$R-,S-,I-,D-,F-,V+,B+,N-,L- }
{$M 1500,0,0 }
{$DEFINE Debug }
{$UNDEF  Debug }

unit LogNamO_;

interface

     uses dos,crt;

     type   LogNamO                 = record bea     : array[1.. 5] of char;
                                             nil1    :                 char;
                                             Bearb   : array[1..22] of char;
                                             mpz     : array[1.. 8] of char;
                                             check   : array[1..80] of char;
                                             sk      : array[1.. 2] of char;
                                      end;

     var    LogNamO_d               : file   of LogNamO;
            LogNamO_p               :           LogNamO;
            LogNamO_exit            :           Boolean;

     procedure LogNamO_O;
     procedure LogNamO_R;
     procedure LogNamO_W;
     procedure LogNamO_C;

implementation

     procedure LogNamO_O;
     begin Assign  (LogNamO_d,'A:\SYSLOG\LOGNAMEO.DAT');
           SetFAttr(LogNamO_d,Archive);
           Reset   (LogNamO_d);
           if (IOResult<>0) or (FileSize(LogNamO_d)=0) then LogNamO_exit:=false
                                                       else LogNamO_exit:=true;
     end;

     procedure LogNamO_R;
     begin Read(LogNamO_d,LogNamO_p);
     end;

     procedure LogNamO_W;
     begin Write(LogNamO_d,LogNamO_p);
     end;

     procedure LogNamO_C;
     begin Close   (LogNamO_d);
     end;

end.
