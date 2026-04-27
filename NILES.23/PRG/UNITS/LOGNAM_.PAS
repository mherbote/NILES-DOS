{$R-,S-,I-,D-,F-,V+,B+,N-,L- }
{$M 1500,0,0 }
{$DEFINE Debug }
{$UNDEF  Debug }

unit LogNam_;

interface

     uses dos,crt;

     type   LogNam          = record case bool:byte of
                                       1: (crc1 :                 word;
                                           crc2 :                 word;
                                           crc3 :                 word;
                                           mpz  : array[1.. 8] of char);
                                       2: (byt  : array[1..14] of byte);
                                     end;

     var    LogNam_d        : file   of LogNam;
            LogNam_p        :           LogNam;
            LogNam_exit     :           Boolean;

     procedure LogNam_O;
     procedure LogNam_R;
     procedure LogNam_W;
     procedure LogNam_C;

implementation

     procedure LogNam_O;
     begin Assign  (LogNam_d,'E:\SYSLOG\LOGNAM.DAT');
           SetFAttr(LogNam_d,Archive);
           Reset   (LogNam_d);
           if (IOResult<>0) or (FileSize(LogNam_d)<3) then LogNam_exit:=false
                                                      else LogNam_exit:=true;
           if LogNam_exit then begin Seek(LogNam_d,0); LogNam_R;
                                     Seek(LogNam_d,LogNam_p.byt[6]*2+3);
                               end;
     end;

     procedure LogNam_R;
     begin Read(LogNam_d,LogNam_p);
     end;

     procedure LogNam_W;
     begin Write(LogNam_d,LogNam_p);
     end;

     procedure LogNam_C;
     begin Close   (LogNam_d);
           SetFAttr(LogNam_d,Archive+ReadOnly+Hidden+SysFile);
     end;

end.
